import mongoose from "mongoose";

const vitalSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true 
    },
    bloodPressure: {
        type: Number,
        required: true
    },
    heartRate: {
        type: Number,
        required: true
    },
    sugarLevel: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required: true
    },
    cholesterol: {
        type: Number,
        required: true
    },
    activityLevel: {
        type: String,
        enum: ["Sedentary", "Lightly Active", "Active", "Very Active"],
        required: true,
    },
    gender:{
        type: String,
        enum: ["Male", "Female", "Other"],
        required: true,
    },
    age:{
        type: Number,
        required: true,
    }
},
{ timestamps: true } // Adds createdAt and updatedAt fields
);

const VitalModel = mongoose.model("Vital", vitalSchema);
export default VitalModel;