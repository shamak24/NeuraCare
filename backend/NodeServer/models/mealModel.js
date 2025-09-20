import mongoose from "mongoose";

const mealSchema = new mongoose.Schema({
  mealName: { 
    type: String, 
    required: true 
},
  category: { 
    type: [String], 
    required: true 
  }, // breakfast, lunch, dinner
  cuisine:{
    type: String,
    required: true
  },
  vegan: { 
    type: boolean, 
    required: true 
  },
  vegetarian: { 
    type: boolean, 
    required: true 
  },
  glutenFree: { 
    type: boolean, 
    required: true 
  },
  lactoseFree:{
    type: boolean,
    required: true
  },
  keto:{
    type: boolean,
    required: true
  },
  ingredients:{
    type: [String],
    required: true
  },
  instructions:{
    type: [String],
    required: true
  },
  description:{
    type: [String],
    required: true
  }
});

const Meal = mongoose.model("Meal", mealSchema);
export default Meal;
