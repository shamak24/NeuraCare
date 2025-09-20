import express from 'express';
import { ensureAuthenticated } from '../middleware/Auth.js';
import { addMed, getMedsByUser, removeMed } from '../Controllers/MedController.js';
const router = express.Router();

router.post('/', ensureAuthenticated, addMed);
router.get('/', ensureAuthenticated, getMedsByUser);
router.delete('/', ensureAuthenticated, removeMed);



export default router;