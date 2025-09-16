import mongoose from "mongoose";
import UserModel from "../Models/User.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import VitalModel from "../models/Vitals.js";

const addVital = async (req, res)=>{
    try{
        const { bloodPressure, heartRate, sugarLevel} = req.body;
        const userId = req.user._id;
        const vital = new VitalModel({ userId, bloodPressure, heartRate, sugarLevel });
        await vital.save();
        res.status(201).json({ message: "Vital added successfully", success: true });
    }catch(err){
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

const getVitalsByUser = async (req, res)=>{
    try{
        const userId = req.user._id;
        const vitals = await VitalModel.find({userId}).sort({ createdAt: -1 });
        res.status(200).json({ vitals, success: true });
    }catch(err){
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

export { addVital, getVitalsByUser };