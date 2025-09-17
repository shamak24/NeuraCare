import mongoose from "mongoose";
import UserModel from "../Models/User.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const signup = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const user = await UserModel.findOne({ email });
    if (user) {
      return res.status(409).json({
        message: "User is already exist, you can login",
        success: false,
      });
    }
    const userModel = new UserModel({ name, email, password });
    userModel.password = await bcrypt.hash(password, 10);
    await userModel.save();
    const token = jwt.sign(
      { email: userModel.email, _id: userModel._id },
      process.env.JWT_SECRET,
      { expiresIn: "5d" }
    );
    res.cookie("token", token, {
      httpOnly: true,
      secure: true,
      expires: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000),
    });
    res.status(201).json({
      message: "Signup successfully",
      success: true,
      token,
    });
  } catch (err) {
    res.status(500).json({
      message: "Internal server error",
      success: false,
    });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await UserModel.findOne({ email });
    const errorMsg = "Auth failed email or password is wrong";
    if (!user) {
      return res.status(401).json({ message: errorMsg, success: false });
    }
    const isPassEqual = await bcrypt.compare(password, user.password);
    if (!isPassEqual) {
      return res.status(401).json({ message: errorMsg, success: false });
    }
    const token = jwt.sign(
      { email: user.email, _id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: "24h" }
    );
    res.cookie("token", token, {
      httpOnly: true,
      secure: true,
      expires: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000),
    });
    res.status(200).json({
      message: "Login Success",
      success: true,
      token,
      email,
      name: user.name,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Internal server errror",
      success: false,
    });
  }
};

const logout = async (req, res) => {
  try {
    res.clearCookie("token");
    res.status(200).json({
      message: "Logout Success",
      success: true,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Internal server error",
      success: false,
    });
  }
};

const profile = async (req, res) => {
  try {
    // req.user should contain the id from JWT
    const user = await UserModel.findById(req.user._id).select("-password"); // exclude password
    if (!user) return res.status(404).json({ message: "User not found" });

    res.json(user); // return user data
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

export { signup, login, logout, profile };
