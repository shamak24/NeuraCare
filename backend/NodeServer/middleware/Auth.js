import jwt from "jsonwebtoken";
import UserModel from "../Models/User.js";
const ensureAuthenticated = async (req, res, next) => {
    const auth = req.headers['authorization'] || req.cookies.token;
    if (!auth) {
        return res.status(403)
            .json({ message: 'Unauthorized, JWT token is require' });
    }
    try {
        const decoded = jwt.verify(auth, process.env.JWT_SECRET);
        req.user = await UserModel.findById(decoded._id);
        next();
    } catch (err) {
        return res.status(403)
            .json({ message: 'Unauthorized, JWT token wrong or expired' });
    }
}

export { ensureAuthenticated };