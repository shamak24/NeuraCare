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
    type: Boolean, 
    required: true 
  },
  vegetarian: { 
    type: Boolean, 
    required: true 
  },
  glutenFree: { 
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
  ingredients:{
    type: [String],
    required: true
  },
  instructions:{
    type: [String],
    required: true
  },
  description:{
    type: String,
    required: true
  }
});

const Meal = mongoose.model("Meal", mealSchema);
export default Meal;
