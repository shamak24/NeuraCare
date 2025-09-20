import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import './Models/db.js';
import AuthRouters from './routers/AuthRouters.js';
import VitalRouter from './routers/VitalRouter.js';
import ConnectDBWithRetry from './Models/db.js';
import cookieParser from 'cookie-parser';
import MedRouter from './routers/MedRouter.js';
import DietRouter from './routers/DietRouter.js';
import HistoryRouter from './routers/HistoryRouter.js';
import HealthScoreRouter from './routers/HealthScore.js';
import GeminiRouter from './routers/GeminiRouter.js';
import MealRouter from './routers/MealRouter.js';

const app = express();
dotenv.config();
ConnectDBWithRetry();
const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());
app.use(cookieParser());
app.use(cors());
app.use('/auth', AuthRouters);
app.use('/vitals', VitalRouter);
app.use('/meds', MedRouter);
app.use('/diet', DietRouter);
app.use('/history', HistoryRouter);
app.use('/healthScore', HealthScoreRouter);
app.use('/gemini', GeminiRouter);
app.use('/meals', MealRouter);

app.get('/', (req, res) => {
    res.send('Hello from NeuraCare backend!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
