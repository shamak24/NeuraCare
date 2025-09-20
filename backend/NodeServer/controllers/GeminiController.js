import { GoogleGenerativeAI } from "@google/generative-ai";
import DietModel from '../models/diet.js';
import VitalModel from '../models/Vitals.js';
import PrevHistoryModel from '../models/prevhistory.js';
import MedModel from '../models/meds.js'
import dotenv from 'dotenv';
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// Helper function to safely format data
const formatData = (data) => {
  if (!data) return 'No data available';
  
  // If data is empty object or array
  if ((typeof data === 'object' && Object.keys(data).length === 0) || 
      (Array.isArray(data) && data.length === 0)) {
    return 'No data available';
  }

  try {
    // Handle Mongoose documents
    if (data.toObject) {
      const cleanData = Object.entries(data.toObject())
        .filter(([key, value]) => {
          return value !== null && value !== undefined && value !== '' 
            && key !== '_id' && key !== '__v';
        })
        .reduce((obj, [key, value]) => {
          obj[key] = value;
          return obj;
        }, {});
      return Object.keys(cleanData).length ? JSON.stringify(cleanData) : 'No data available';
    }

    // Handle arrays (like results from Model.find())
    if (Array.isArray(data)) {
      const cleanArray = data.map(item => {
        if (item.toObject) {
          return Object.entries(item.toObject())
            .filter(([key, value]) => {
              return value !== null && value !== undefined && value !== ''
                && key !== '_id' && key !== '__v';
            })
            .reduce((obj, [key, value]) => {
              obj[key] = value;
              return obj;
            }, {});
        }
        return item;
      });
      return JSON.stringify(cleanArray);
    }

    // Handle plain objects
    const cleanData = Object.entries(data)
      .filter(([key, value]) => {
        return value !== null && value !== undefined && value !== ''
          && key !== '_id' && key !== '__v';
      })
      .reduce((obj, [key, value]) => {
        obj[key] = value;
        return obj;
      }, {});
    
    return Object.keys(cleanData).length ? JSON.stringify(cleanData) : 'No data available';

  } catch (error) {
    console.error('Error formatting data:', error);
    return 'Error formatting data';
  }
};

const generateChat = async (req, res) => {
  try {
    const { message, type } = req.body;
    const userId = req.user._id;
    
    if (!message) {
      return res.status(400).json({ error: "Message is required" });
    }

    const baseInstruction = "Provide a very concise response in simple words (maximum 30 words): ";

    let prompt = '';
    switch (type) {
      case 'symptoms':
        const history = await PrevHistoryModel.findOne({ userId });
        prompt = `${baseInstruction} Medical history: ${formatData(history)}. Query: ${message}`;
        break;
      case 'diet':
        const dietPreferences = await DietModel.findOne({ userId });
        prompt = `${baseInstruction} Diet preferences: ${formatData(dietPreferences)}. Query: ${message}`;
        break;
      case 'lifestyle':
        const vitals = await VitalModel.findOne({ userId });
        prompt = `${baseInstruction} Vitals: ${formatData(vitals)}. Query: ${message}`;
        break;
      case 'diseases':
        const prevHistory = await PrevHistoryModel.findOne({ userId });
        const meds = await MedModel.find({ userId });
        prompt = `${baseInstruction} History: ${formatData(prevHistory)}. 
                 Medications: ${formatData(meds)}. Query: ${message}`;
        break;
      default:
        prompt = `${baseInstruction} ${message}`;
    }

    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });
    const result = await model.generateContent(prompt);
    let responseText = await result.response.text();

    // Clean up the response
    responseText = responseText
      .replace(/\\n/g, ' ')
      .replace(/\s+/g, ' ')
      .replace(/[^\w\s.,!?-]/g, '')
      .trim();

    res.json({
      success: true,
      userMessage: message,
      botReply: responseText,
      dataUsed: {
        type,
        prompt: prompt.substring(0, 100) + '...' // For debugging
      }
    });
  } catch (error) {
    console.error("Error in generatingChat:", error);
    res.status(500).json({ 
      error: "Something went wrong with Gemini API",
      details: error.message 
    });
  }
};

export { generateChat };