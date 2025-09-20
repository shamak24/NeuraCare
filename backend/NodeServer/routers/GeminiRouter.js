import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import {generateChat, generateDiet, generateDisease} from '../controllers/GeminiController.js';
const router = express.Router();

router.post('/chat', ensureAuthenticated, generateChat);
router.post('/diet', ensureAuthenticated, generateDiet);
router.post('/disease', ensureAuthenticated, generateDisease);



export default router;