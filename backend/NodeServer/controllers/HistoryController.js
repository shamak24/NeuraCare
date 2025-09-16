import prevHistoryModel from '../models/prevhistory.js';

const addHistory = async (req, res) => {
  try {
    const diseases = req.body.diseases || [];
    const surgeries = req.body.surgeries || [];
    const familyHistory = req.body.familyHistory || [];
    const userId = req.user._id;
    const newHistory = new prevHistoryModel({ userId, diseases, surgeries, familyHistory });
    await newHistory.save();
    res.status(201).json({ message: "Previous history added successfully", history: newHistory });
  } catch (error) {
    console.error("Error in addHistory:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const getHistory = async (req, res) => {
  try {
    const userId = req.user._id;
    const history = await prevHistoryModel.findOne({ userId });
    if (!history) {
      return res.status(404).json({ message: "No history found", success: false });
    }
    res.status(200).json({ history, success: true });
  } catch (error) {
    console.error("Error in getHistory:", error);
    res.status(500).json({ message: "Internal server error", success: false });
  }
};
export { addHistory, getHistory };