import { GoogleGenerativeAI } from "@google/generative-ai";
import DietModel from '../models/diet.js';
import VitalModel from '../models/Vitals.js';
import PrevHistoryModel from '../models/prevhistory.js';
import dotenv from 'dotenv';
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const generateChat = async (req, res) => {
  try {
    // Get user input from request body
    const message = req.body.message;
    const userId = req.user._id;
    const type = req.body.type;
    if (!message) {
      return res.status(400).json({ error: "Message is required" });
    }

    // Construct prompt based on message type
    let prompt = '';
    switch (type) {
      case 'symptoms':
        const history = await PrevHistoryModel.findOne({ userId });
        prompt = `Based on the following user's medical history: ${JSON.stringify(history)}, 
                 ${message}. Please provide a detailed 
                 but easy to understand response with possible causes and when to seek 
                 medical attention.`;
        break;
      case 'diet':
        const dietPreferences = await DietModel.findOne({ userId });
        prompt = `Given these dietary preferences and restrictions: ${JSON.stringify(dietPreferences)}, 
                 ${message}. Please suggest a balanced diet plan.`;
        break;
      case 'lifestyle':
        const vitals = await VitalModel.findOne({ userId });
        prompt = `Considering these vital statistics: ${JSON.stringify(vitals)}, 
                 ${message}. Please provide lifestyle recommendations.`;
        break;
      case 'diseases':
        const prevHistory = await PrevHistoryModel.findOne({userId, diseases});
        const meds = await MedModel.find({userId, medName});
        prompt = `Given the user's previous disease history: ${JSON.stringify(prevHistory)}, with current medications: ${JSON.stringify(meds)},
        ${message}. Please provide information on managing and preventing recurrence.`;
        break;
    }

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

    const result = await model.generateContent(prompt);
    const responseText = result.response.text();

    // Send back AI response
    res.json({
      success: true,
      userMessage: message,
      botReply: responseText,
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