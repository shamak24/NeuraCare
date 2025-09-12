import express from 'express';
const router = express.Router();
import { signupValidation, loginValidation, logoutValidation } from "../middleware/authValidation.js";
import { login, signup, logout } from "../controllers/Authcontroller.js";

router.post('/login', loginValidation, login);

router.post('/signup', signupValidation, signup);

router.post('/logout', logoutValidation, logout);

export default router;