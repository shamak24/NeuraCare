import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import './Models/db.js';
import AuthRouters from './routers/AuthRouters.js';
import ProductRouter from './routers/ProductRouter.js';

const app = express();
dotenv.config();
const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());
app.use(cors());
app.use('/auth', AuthRouters);
app.use('/products', ProductRouter);

app.get('/', (req, res) => {
    res.send('Hello from NeuraCare backend!');
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
