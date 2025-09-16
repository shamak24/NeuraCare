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
        required: true
    },
    vegetarian:{
        type: Boolean,
        required: true
    },
    glutenFree:{
        type: Boolean,
        required: true
    },
    lactoseFree:{
        type: Boolean,
        required: true
    },
    keto:{
        type: Boolean,
        required: true
    },
    paleo:{
        type: Boolean,
        required: true
    },
    lowFodmap:{
        type: Boolean,
        required: true
    },
    pescatarian:{
        type: Boolean,
        required: true
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