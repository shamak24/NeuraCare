import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true
    },
    email:{
        type: String,
        required: true,
        unique: true
    },
    password:{
        type: String,
        required: true
    },
    healthScore:{
        type: Number,
        default: 0
    },
    healthPoints:{
        type: Number,
        default: 0
    }
})

// Check if model exists before compiling
const UserModel = mongoose.models.User || mongoose.model("User", userSchema);

export default UserModel;