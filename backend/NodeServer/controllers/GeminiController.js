import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from 'dotenv';
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const generateChat = async (req, res) => {
  try {
    // Get user input from request body
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({ error: "Message is required" });
    }

    // Parse the message if it's a JSON string
    let parsedMessage;
    try {
      parsedMessage = typeof message === 'string' ? JSON.parse(message) : message;
    } catch (error) {
      console.error(error);
      return res.status(400).json({ error: "Invalid JSON format" });
    }

    // Construct prompt based on message type
    let prompt = '';
    switch (parsedMessage.type) {
      case 'symptoms':
        prompt = `Based on the following symptoms: ${parsedMessage.data.join(', ')}, 
                 what could be the potential health concerns? Please provide a detailed 
                 but easy to understand response with possible causes and when to seek 
                 medical attention.`;
        break;
      case 'diet':
        prompt = `Given these dietary preferences and restrictions: ${JSON.stringify(parsedMessage.data)}, 
                 suggest healthy meal options and nutritional advice. Include information about 
                 balanced nutrition and portion control.`;
        break;
      case 'lifestyle':
        prompt = `Considering these lifestyle factors: ${JSON.stringify(parsedMessage.data)}, 
                 provide recommendations for improving health and wellness. Include both 
                 short-term and long-term suggestions.`;
        break;
      default:
        prompt = `Please provide health advice regarding: ${message}`;
    }

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

    const result = await model.generateContent(prompt);
    const responseText = await result.response.text();

    // Send back AI response
    res.json({
      success: true,
      userMessage: parsedMessage,
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