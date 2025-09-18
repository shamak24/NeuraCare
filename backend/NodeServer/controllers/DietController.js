import DietModel from "../models/diet.js";

const addDiet = async (req, res)=>{
    const { vegan, vegetarian, glutenFree, lactoseFree, keto, cuisinePreferences, allergies } = req.body || "false";
    const userId = req.user._id;
    if(!vegan && !vegetarian && !glutenFree && !lactoseFree && !keto && !cuisinePreferences && !allergies){
        return res.status(400).json({ message: "dietary preferences must be specified." });
    }
    if(await DietModel.findOne({userId})){
        return res.status(409).json({ message: "Dietary preferences already exist for this user." });
    }
    try{
        const diet = new DietModel({ userId, vegan, vegetarian, glutenFree, lactoseFree, keto, cuisinePreferences, allergies });
        await diet.save();
        res.status(201).json({ message: "Dietary preferences added successfully.", diet });
    }catch(error){
        console.error("Error adding dietary preferences:", error);
        res.status(500).json({ message: "Internal server error." });
    }
}

const getDiet = async (req,res)=>{
    const userId = req.user._id;
    try{
        const diet = await DietModel.findOne({ userId });
        if(!diet){
            return res.status(404).json({ message: "Dietary preferences not found." });
        }
        res.status(200).json(diet);
    }catch(error){
        console.error("Error retrieving dietary preferences:", error);
        res.status(500).json({ message: "Internal server error." });
    }
}

export { addDiet, getDiet };