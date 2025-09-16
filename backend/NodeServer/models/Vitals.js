import mongoose from "mongoose";

const vitalSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    bloodPressure:{
        type: Number,
        required: true
    },
    heartRate:{
        type: Number,
        required: true
    },
    sugarLevel:{
        type: Number,
        required: false
    }
},
{timestamps: true} // This will add createdAt and updatedAt fields
);

const VitalModel = mongoose.model("Vital", vitalSchema);
export default VitalModel;