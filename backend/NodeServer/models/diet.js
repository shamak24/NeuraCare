import mongoose from "mongoose";

const dietSchema = new mongoose.Schema({
    userId:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true // one-to-one relation
    },
    vegan:{
        type: Boolean,
        default: false,
    },
    vegetarian:{
        type: Boolean,
        default: false
    },
    glutenFree:{
        type: Boolean,
        default: false
    },
    lactoseFree:{
        type: Boolean,
        default: false
    },
    keto:{
        type: Boolean,
        default: false
    },
    paleo:{
        type: Boolean,
        default: false
    },
    lowFodmap:{
        type: Boolean,
        default: false
    },
    pescatarian:{
        type: Boolean,
        default: false
    },
    allergies:{
        type: [String],
        required: false
    }
},
{ timestamps: true } 
)

const DietModel = mongoose.model("Diet", dietSchema);
export default DietModel;