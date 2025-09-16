import express from 'express';
const router = express.Router();
import { signupValidation, loginValidation } from "../middleware/authValidation.js";
import { login, signup, logout, profile } from "../controllers/Authcontroller.js";
import { ensureAuthenticated } from '../middleware/Auth.js';


router.post('/login', loginValidation, login);

router.post('/signup', signupValidation, signup);

router.post('/logout', logout);

router.get('/profile', ensureAuthenticated, profile);

export default router;