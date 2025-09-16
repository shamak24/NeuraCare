import mongoose from "mongoose";

const vitalSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true // one-to-one relation
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
        required: false
    },
    weight: {
        type: Number,
        required: true
    },
    chlorestrol: {
        type: Number,
        required: false
    },
    activityLevel: {
        type: String,
        required: true
    }
},
{ timestamps: true } // Adds createdAt and updatedAt fields
);

const VitalModel = mongoose.model("Vital", vitalSchema);
export default VitalModel;