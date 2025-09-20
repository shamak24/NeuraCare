import UserModel from "../models/User.js";
import VitalModel from "../models/Vitals.js";
import HistoryModel from "../models/prevhistory.js";
import MedModel from "../models/meds.js";
import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const calculateHealthScore = async (req, res) => {
    try {
        const userId = req.user._id;

        // Fetch all user health data
        const vitals = await VitalModel.findOne({ userId });
        const history = await HistoryModel.findOne({ userId });
        const medications = await MedModel.find({ userId });

        if (!vitals) {
            return res.status(404).json({ 
                success: false, 
                message: "Vital information not found" 
            });
        }

        // Construct prompt for Gemini
        const prompt = `You are a medical expert analyzing health data. Respond ONLY with a JSON object, no additional text or markdown:
        {
            "healthScore": (number between 0-100, higher is better),
            "risks": [three key health risks as strings],
            "preventiveMeasures": [three preventive measures as strings],
            "comorbidityAdvice": "brief management advice"
        }

        Base your analysis on:
        Vitals: ${JSON.stringify(vitals)}
        Medical History: ${JSON.stringify(history)}
        Current Medications: ${JSON.stringify(medications)}

        Keep each text response under 15 words. Do not include any markdown formatting or backticks.`;

        const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });
        const result = await model.generateContent(prompt);
        let aiResponse = await result.response.text();

        // Clean up the response
        aiResponse = aiResponse
            .replace(/```json\n?/g, '')  // Remove ```json
            .replace(/```\n?/g, '')      // Remove closing ```
            .trim();                     // Remove whitespace

        // Parse cleaned response
        const analysis = JSON.parse(aiResponse);

        // Validate analysis structure
        if (!analysis.healthScore || !analysis.risks || !analysis.preventiveMeasures || !analysis.comorbidityAdvice) {
            throw new Error("Invalid response structure from AI");
        }

        // Update user's health score
        await UserModel.findByIdAndUpdate(userId, { 
            healthScore: analysis.healthScore 
        });

        res.status(200).json({
            success: true,
            ...analysis
        });

    } catch (error) {
        console.error("Error calculating health score:", error);
        res.status(500).json({ 
            success: false, 
            message: "Error calculating health score",
            error: error.message,
            details: error.stack
        });
    }
};

export { calculateHealthScore };