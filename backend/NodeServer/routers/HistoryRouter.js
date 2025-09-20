import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { addHistory, getHistory } from '../controllers/HistoryController.js';
const router = express.Router();

router.post('/', ensureAuthenticated, addHistory);
router.get('/', ensureAuthenticated, getHistory);



export default router;