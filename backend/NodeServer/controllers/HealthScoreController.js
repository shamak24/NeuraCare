import UserModel from "../models/User.js";

const calculateHealthScore = (vitals, prevhistory, user)=>{

    //VITALS MAX - 25 POINTS
    let vitalPoints = 0;
    //BLOOD PRESSURE
    if(vitals.bpHigh<120 && vitals.bpLow<80) vitalPoints +=10;
    else if(vitals.bpHigh<=129 && vitals.bpLow<80) vitalPoints +=7;
    else if(vitals.bpHigh<=139 && vitals.bpLow<=89) vitalPoints +=4;

    //HEART RATE
    if(vitals.heartRate>=60 && vitals.heartRate<100) vitalPoints +=10;
    else if(vitals.heartRate<60 && vitals.heartRate>100) vitalPoints +=5;

    //SUGAR LEVEL
    if(vitals.sugarLevel<100) vitalPoints +=10;
    else if(vitals.sugarLevel>=100 && vitals.sugarLevel<=125) vitalPoints +=5;

    const BMI = (vitals.weight)/( (vitals.height/100) * (vitals.height/100));
    if(BMI>=18.5 && BMI<=24.9) vitalPoints +=10;
    else if(BMI>=25 && BMI<=29.9) vitalPoints +=5;

    //CHOLESTEROL
    if(vitals.cholesterol<200) vitalPoints +=10;
    else if(vitals.cholesterol>=200 && vitals.cholesterol<=239) vitalPoints +=5;

    //ACTIVITY LEVEL
    if(vitals.activityLevel.toLowerCase() === "very active") vitalPoints +=10;
    else if(vitals.activityLevel.toLowerCase() === "active") vitalPoints +=7;
    else if(vitals.activityLevel.toLowerCase() === "lightly active") vitalPoints +=4;

    const totalVitalPoints = (vitalPoints/25)*25;

    //LIFESSTYLE MAX - 15 POINTS
    //SMOKING AND DRINKING
    let lifestylePoints = 0;
    if(vitals.sleepHours>=7 && vitals.sleepHours<=9) lifestylePoints +=10;
    else if(vitals.sleepHours>=6 && vitals.sleepHours<7 || vitals.sleepHours>9 && sleepHours<=10) lifestylePoints +=5;
    if(vitals.drinking) lifestylePoints+=5;
    else lifestylePoints +=10;
    if(!vitals.smoking) lifestylePoints+=10;
    const totalLifestylePoints = (lifestylePoints/15)*20;


    if(vitals.sleepHours<6) score -=10;
    if(vitals.smoking) score -=10;
    if(vitals.drinking) score -=10;
    return score;
}

const getScore = async (req,res)=>{
    const userId = req.user._id;
    try{
        // Changed findOne query to find by _id instead of userId
        const user = await UserModel.findById(userId);
        if(!user){
            return res.status(404).json({ message: "User not found." });
        }
        res.status(200).json(user.healthScore);
    }catch(error){
        console.error("Error retrieving user health score", error);
        res.status(500).json({ message: "Internal server error." });
    }
}

export { getScore };