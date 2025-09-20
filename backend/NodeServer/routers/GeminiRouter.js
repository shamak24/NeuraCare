import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import {generateChat} from '../controllers/GeminiController.js';
const router = express.Router();

router.post('/', ensureAuthenticated, generateChat);


export default router;