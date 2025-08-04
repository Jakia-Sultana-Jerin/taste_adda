const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
 // id: { type: String, required: true, unique: true },
  firebaseUid: { type: String, required: true, unique: true },
  userName: { type: String, required: true },
  description: { type: String },
  email: { type: String, required: true},
  phoneNumber: { type: String },
  country: { type: String },
  profilePicture: { type: String },
  joined: { type: Date }
}, {
  timestamps: true,
});
const User = mongoose.model("User", userSchema);

module.exports = User;
