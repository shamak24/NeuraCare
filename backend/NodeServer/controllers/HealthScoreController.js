import UserModel from "../models/User.js";


const getDiet = async (req,res)=>{
    const userId = req.user._id;
    try{
        const user = await UserModel.findOne({ userId });
        if(!user){
            return res.status(404).json({ message: "User not found." });
        }
        res.status(200).json(user.healthScore);
    }catch(error){
        console.error("Error retrieving user health score", error);
        res.status(500).json({ message: "Internal server error." });
    }
}

export { addDiet, getDiet };