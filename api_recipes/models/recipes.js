// models/recipe.js
const mongoose = require("mongoose");

const reviewSchema = new mongoose.Schema({
  id: String,
  user: String,
  attachment: String,
  description: String,
  rating:String,
}, );

const recipeSchema = new mongoose.Schema({
  id: String,
  title: String,
  description: String,
  category: String,
  thumbUrl: String,
  steps: [String],
  ingredients: mongoose.Schema.Types.Mixed,
  Uploaderprofilepic: String,
  reviews: [reviewSchema]
});

module.exports = mongoose.model("Recipe", recipeSchema);
