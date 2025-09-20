import express from 'express';
const router = express.Router();
import { signupValidation, loginValidation } from "../middleware/authValidation.js";
import { login, signup, logout, profile } from "../controllers/AuthController.js";
import { ensureAuthenticated } from '../middleware/Auth.js';


router.post('/login', loginValidation, login);

router.post('/signup', signupValidation, signup);

router.post('/logout', logout);

router.get('/profile', ensureAuthenticated, profile);

router.post('/verify-token', ensureAuthenticated, (req, res) => {
    res.status(200).json({ message: 'Token is valid', user: req.user });
});

export default router;