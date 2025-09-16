import mongoose from "mongoose";

const medsSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    medName: {
        type: String,
        required: true
    },
    timing: {
        morning: {
            hr: { type: Number },
            min: { type: Number }
        },
        afternoon: {
            hr: { type: Number },
            min: { type: Number }
        },
        evening: {
            hr: { type: Number },
            min: { type: Number }
        },
        night: {
            hr: { type: Number },
            min: { type: Number }
        },
    },
    number: {
        type: Number,
        default: 1
    }
},
{ timestamps: true } // Adds createdAt and updatedAt fields
)

const MedModel = mongoose.model("Med", medsSchema);
export default MedModel;