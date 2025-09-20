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

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

    const result = await model.generateContent(message);

    // Extract the response text
    const responseText = result.response.text();

    // Send back AI response
    res.json({
      success: true,
      userMessage: message,
      botReply: responseText,
    });
  } catch (error) {
    console.error("Error in generateChat:", error);
    res.status(500).json({ error: "Something went wrong with Gemini API" });
  }
};

export {generateChat};