import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { addDiet, getDiet } from '../controllers/HealthScoreController.js';
const router = express.Router();

router.get('/', ensureAuthenticated, getScore);



export default router;