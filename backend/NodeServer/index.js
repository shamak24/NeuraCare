import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import './Models/db.js';
import AuthRouters from './routers/AuthRouters.js';
import ProductRouter from './routers/ProductRouter.js';
import VitalRouter from './routers/VitalRouter.js';
import ConnectDBWithRetry from './Models/db.js';
import cookieParser from 'cookie-parser';
const app = express();
dotenv.config();
ConnectDBWithRetry();
const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());
app.use(cookieParser());
app.use(cors());
app.use('/auth', AuthRouters);
app.use('/products', ProductRouter);
app.use('/vitals', VitalRouter);

app.get('/', (req, res) => {
    res.send('Hello from NeuraCare backend!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
