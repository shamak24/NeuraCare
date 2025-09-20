import MedModel from '../models/meds.js';

const addMed = async (req, res) => {
    try{
        const medname = req.body.medName;
        const number = req.body.number || 1;
        if(!medname){
            return res.status(400).json({ message: "Medication name is required", success: false });
        }
        const userId = req.user._id;
        const morning = req.body.morning || {};
        const afternoon = req.body.afternoon || {};
        const evening = req.body.evening || {};
        const night = req.body.night || {};
        const med = new MedModel({ userId, medName: medname, timing: { morning, afternoon, evening, night }, number });
        await med.save();
        res.status(201).json({ message: "Medication added successfully", success: true });
    }catch(err){
        console.error(err);
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

const getMedsByUser = async (req, res) => {
    try{
        const userId = req.user._id;
        const meds = await MedModel.find({userId}).sort({ createdAt: -1 });
        res.status(200).json({ meds, success: true });
    }catch(err){
        console.error(err);
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

const removeMed = async (req, res) =>{
    try{
        const userId = req.user._id;
        const medName = req.body.medName;
        const med = await MedModel.findOne({userId: userId, medName: medName});
        if(!med){
            return res.status(404).json({message: "Medication not found", success: false});
        }
        await MedModel.deleteOne({userId: userId, medName: medName});
        res.status(200).json({message: "Medication removed successfully", success: true});
    }catch(err){
        console.error(err);
        res.status(500).json({message: "Internal Server error", success: false});
    }
    
}

export { addMed, getMedsByUser, removeMed };