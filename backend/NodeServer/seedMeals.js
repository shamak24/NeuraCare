import mongoose from "mongoose";
import Meal from "./models/mealModel.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const seedMeals = async () => {
  try {
    // Read meals.json using absolute path
    const mealsData = JSON.parse(
      fs.readFileSync(path.join(__dirname, "data", "meals.json"), "utf-8")
    );

    // Insert new meals
    if (await Meal.countDocuments() === 0) {
      await Meal.insertMany(mealsData);
      console.log("Meals inserted successfully");
    } else {
      console.log("Meals already exist in the database. Skipping insertion.");
    }

    return true;
  } catch (error) {
    console.error("Error seeding meals:", error);
    return false;
  }
};

export { seedMeals };
