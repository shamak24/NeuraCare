import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { calculateHealthScore } from '../controllers/HealthScoreController.js';
const router = express.Router();

router.get('/', ensureAuthenticated, calculateHealthScore);



export default router;