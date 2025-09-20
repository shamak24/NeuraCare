import Meal from './models/mealModel.js';
import Diet from './models/diet.js';

const setMeals = async (req, res) => {
    const userId = req.user._id;
    try {
        // Get user's cuisine preference
        const diet = await Diet.findOne({ userId });
        const cuisinePreference = diet.cuisinePreferences;
        const vegan = diet.vegan;
        const vegetarian = diet.vegetarian;
        const glutenfree = diet.glutenfree;
        const lactosefree = diet.lactosefree;
        const keto = diet.keto;

        // Query based on cuisine preference
        const query = cuisinePreference ? { cuisine: cuisinePreference } : {};

        // Get all meal for each category
        let meals;
        if (!cuisinePreference || cuisinePreference.length === 0) {
            meals = {
                breakfast: await Meal.find({ category: "Breakfast" }),
                lunch: await Meal.find({ category: "Lunch" }),
                dinner: await Meal.find({ category: "Dinner" })
            };
        } else {
            meals = {
                breakfast: await Meal.find({...query, category: "Breakfast" }),
                lunch: await Meal.find({...query, category: "Lunch" }),
                dinner: await Meal.find({...query, category: "Dinner" })
            };
        }

        // Get random meals for each now
        const breakfast = meals.breakfast[Math.floor(Math.random() * meals.breakfast.length)];
        const lunch = meals.lunch[Math.floor(Math.random() * meals.lunch.length)];
        const dinner = meals.dinner[Math.floor(Math.random() * meals.dinner.length)];

        // Send response
        res.status(200).json({
            success: true,
            meals: {
                breakfast,
                lunch,
                dinner
            },
            cuisinePreference: cuisinePreference || "Random"
        });

    }catch (error) {
        console.error("Error setting meals:", error);
        res.status(500).json({ 
            success: false, 
            message: "Internal server error" 
        });
    }
};

export { setMeals };