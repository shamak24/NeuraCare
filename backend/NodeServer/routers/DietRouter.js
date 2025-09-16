import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { addDiet, getDiet } from '../Controllers/DietController.js';
const router = express.Router();

router.post('/', ensureAuthenticated, addDiet);
router.get('/', ensureAuthenticated, getDiet);



export default router;