
import VitalModel from "../models/Vitals.js";

const addVital = async (req, res)=>{
    try{
        const { bloodPressure, heartRate, sugarLevel, weight, cholesterol, activityLevel, gender, age,height } = req.body;
        const userId = req.user._id;
        if(!bloodPressure || !heartRate || !sugarLevel || !weight || !cholesterol || !activityLevel || !gender || !age || !height){
            return res.status(400).json({ message: "All fields are required", success: false });
        }
        if(await VitalModel.findOne({ userId })){
            return res.status(409).json({ message: "Vital for this user already exists", success: false });
        }
        const vital = new VitalModel({ userId, bloodPressure, heartRate, sugarLevel, weight, cholesterol, activityLevel, gender, age,height });
        await vital.save();
        res.status(201).json({ message: "Vital added successfully", success: true });
    }catch(err){
        console.error(err);
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

const getVitalsByUser = async (req, res)=>{
    try{
        const userId = req.user._id;
        const vitals = await VitalModel.findOne({userId});
        if(!vitals){
            return res.status(404).json({ message: "No vitals found for this user", success: false });
        }
        res.status(200).json({ vitals, success: true });
    }catch(err){
        console.error(err);
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

export { addVital, getVitalsByUser };