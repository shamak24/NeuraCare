import mongoose from "mongoose";

const prevHistorySchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true // one-to-one relation
    },
    diseases: {
        type: [String],
        required: false
    },
    surgeries: {
        type: [String],
        required: false
    },
    familyHistory: {
        type: [String],
        required: false
    },
},
{ timestamps: true } // Adds createdAt and updatedAt fields
);

const PrevHistoryModel = mongoose.model("PrevHistory", prevHistorySchema);
export default PrevHistoryModel;