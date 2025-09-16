import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { addVital, getVitalsByUser } from '../controllers/VitalController.js';
const router = express.Router();

router.post('/', ensureAuthenticated, addVital);
router.get('/', ensureAuthenticated, getVitalsByUser);



export default router;