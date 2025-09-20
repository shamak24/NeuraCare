import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import {setMeals} from '../mealBackend.js';
const router = express.Router();


router.get("/", ensureAuthenticated, setMeals);

export default router;