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

app.get('/', (req, res) => {
    res.send('Hello from NeuraCare backend!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
