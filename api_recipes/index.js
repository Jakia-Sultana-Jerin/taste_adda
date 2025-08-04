require('dotenv').config();
const express = require("express");
const app = express();
const cors = require("cors");
const db = require("./db");
const User = require("./models/user");
const Recipes = require("./models/recipes");

const multer=require("multer")




const PORT = 3000;
const HOST = '0.0.0.0';

app.use(cors({ origin: "*" }));
app.use(express.json());
app.use('/uploads', express.static('uploads'));











const admin = require('firebase-admin');
const serviceAccount = require("./serviceaccout.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Middleware to verify Firebase ID token

const verifyFirebaseToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: true, message: 'Unauthorized. No token.' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.uid = decodedToken.uid;
    req.decodedToken = decodedToken; // optional: useful for email, name, etc.
    next();
  } catch (error) {
    console.error('❌ Firebase token verification failed:', error.message);
    return res.status(401).json({ error: true, message: 'Invalid or expired token.' });
  }
};

module.exports = verifyFirebaseToken;

//const recipesData = require('./models/data/recipes.json');

// 
//const verifyFirebaseToken = require('./verifyFirebaseToken');

// Storage config
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });




app.post(
  '/upload',
  verifyFirebaseToken,           
  upload.single('profilePicture'),
  async (req, res) => {
    if (!req.file) return res.status(400).send('No file uploaded');

    const url = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;

   
        const user = await User.findOne({ firebaseUid: req.uid });
         const userId = req.uid;  // 

    // Example: MongoDB 
    await User.updateOne(
      { _id: user._id },
      { $set: { profilePicture: url } }
    );

    res.json({ url });
  }
);


app.get("/recipes", async (req, res) => {
  try {
    const recipes = await Recipes.find().sort({ createdAt: -1 });
    res.status(200).json({ data: recipes, error: false });
  } catch (error) {
    console.error("GET /recipes error:", error);
    res.status(500).json({ error: "Failed to fetch recipes" });
  }
});


// POST /recipes route
app.post("/recipes", async (req, res) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).send("Unauthorized");
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    console.log("Received token:", idToken);
    const uid = decodedToken.uid;

    
    const { title, description, thumbUrl, steps, ingredients, category } = req.body;

    if (!title || !description || !thumbUrl || !steps || !ingredients || !category) {
      return res.status(400).json({
        error: true,
        message: "Missing required fields",
      });
    }
   const user = await User.findOne({ firebaseUid: uid });
    const newRecipe = await Recipes.create({
      title,
      description,
      thumbUrl,
      steps,
      ingredients,
      category,
      Uploaderprofilepic: user.profilePicture, // Use the profile picture from the request body
      reviews: [],
      createdBy: User._id, // 
    });

    console.log("✅ Recipe added:", newRecipe);

    res.status(201).json({
      error: false,
      data: newRecipe,
    });
  } catch (e) {
    console.error("❌ Error:", e.message);
    res.status(401).json({ error: true, message: "Unauthorized or failed to create recipe" });
  }
});


app.get("/recipes/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const recipe = await Recipes.findById(id);

    if (!recipe) {
      return res.status(404).json({
        data: null,
        error: true,
        message: "Recipe not found",
      });
    }

    res.status(200).json({
      data: recipe,
      error: false,
    });
  } catch (error) {
    console.error("GET /recipes/:id error:", error);
    res.status(500).json({ error: true, message: "Failed to fetch recipe" });
  }
});


// app.get("/recipes/:id", verifyFirebaseToken, async (req, res) => {
//   try {
//     const { _id } = req.params;

//     // Validate ObjectId
//     if (!mongoose.Types.ObjectId.isValid(_id)) {
//       return res.status(400).json({ data: null, error: true, message: "Invalid recipe ID" });
//     }

//     const recipe = await Recipes.findById(_id);

//     if (!recipe) {
//       return res.status(404).json({ data: null, error: true, message: "Recipe not found" });
//     }

//     // Exclude _id and __v if you want
//     const { __v, ...cleanRecipe } = recipe.toObject();

//     return res.status(200).json({ data: cleanRecipe, error: false });

//   } catch (error) {
//     console.error(error);
//     return res.status(500).json({ data: null, error: true, message: "Server error" });
//   }
// });


// app.get("/recipes/:id", async (req, res) => {
//   try {
//     const { id } = req.params;
//     const recipe = await Recipes.findById(id); //  searching by "id" field

//     if (!recipe) {
//       return res.status(404).json({ data: null, error: true, message: "Recipe not found" });
//     }

//     const { _id, __v, ...cleanRecipe } = recipe.toObject();
//     return res.status(200).json({ data: cleanRecipe, error: false });

//   } catch (error) {
//     console.error(error);
//     return res.status(500).json({ data: null, error: true, message: "Server error" });
//   }
// });


app.get("/users/me", verifyFirebaseToken, async (req, res) => {
  try {
    const uid = req.uid;
    console.log("Decoded UID:", uid);

    const user = await User.findOne({ firebaseUid: uid });

    if (!user) {
      return res.status(404).json({ error: true, message: "User not found" });
    }

    res.json({ error: false, data: user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: true, message: "Server error" });
  }
});


// POST /users - Create or update user after verifying ID token
app.post('/users', verifyFirebaseToken, async (req, res) => {
  const { name, email } = req.body;
  const uid = req.uid; // Comes from verifyFirebaseToken

  console.log(" Verified UID:", uid);

  const user = await User.findOneAndUpdate(
    { firebaseUid: uid },
    { name, email, firebaseUid: uid },
    { upsert: true, new: true }
  );

  return res.status(200).json({ error: false, data: user });
});



app.put('/users/:id', verifyFirebaseToken,async (req, res) => {
  const { id } = req.params;
  const { userName, email, phoneNumber,profilePicture,country,description} = req.body;

 

  const updatedUser = await User.findByIdAndUpdate(
    id,
    {
      userName,
      email,
      phoneNumber,
      profilePicture,
      country,
      description
    },
    { new: true }
  );

  res.json({
    error: false,
    data: updatedUser
  });
});




// DELETE
app.delete('/recipes/:id', async (req, res) => {
  try{
      const { id } = req.params;
  const deleterecipe =await  Recipes.findByIdAndDelete(id);
  if (!deleterecipe) {
    return res.status(404).json({ data: [], error: true, message: 'Recipe not found' });
  }
  res.status(200).json({  error: false, message: "Deleted successfully" });
  console.log("Deleted successfully",deleterecipe)
  }
  catch(e){
    res.status(500).json({ message: "Error deleting recipe", error: e.message });
  }
 

});


// POST new review for a recipe
app.post("/recipes/:id/reviews", async (req, res) => {
  try {
    const { id } = req.params;
    const { user, description, rating, profilepic } = req.body;

    console.log("🔵 Incoming review payload:", req.body);

    const recipe = await Recipes.findById(id);
    if (!recipe) {
      return res.status(404).send({ error: true, message: "Recipe not found" });
    }

    console.log("🔵 Recipe before push:", recipe);

    if (!user || !description || !rating) {
      return res.status(400).send({ error: true, message: "Missing required fields" });
    }

    const newReview = {
      user,
      description,
      rating,
      profilepic,
    };

    recipe.reviews.unshift(newReview);
    await recipe.save();

    console.log("🟢 Recipe after push:", recipe);

    res.send({ error: false, message: "Review added", data: recipe });
  } catch (err) {
    console.error("POST /recipes/:id/reviews error:", err);
    res.status(500).send({ error: true, message: err.message });
  }
});
app.get("/recipes/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const recipe = await Recipes.findById(id);

    if (!recipe) {
      return res.status(404).json({
        data: null,
        error: true,
        message: "Recipe not found",
      });
    }

    console.log("Recipe found:", recipe); 
    console.log("Reviews:", recipe.reviews); 

    res.status(200).json({
      data: recipe,
      error: false,
    });
  } catch (error) {
    console.error("GET /recipes/:id error:", error);
    res.status(500).json({ error: true, message: "Failed to fetch recipe" });
  }
});

//  app.post("/recipes/:id/reviews", async (req, res) => {
//   try {
//      const { id } = req.params;
//     const { user, description,rating,profilepic } = req.body;

//     const recipe = await Recipes.findById(id);
//     if (!recipe) return res.status(404).send({ error: true, message: "Recipe not found" });
//     const newReview = {
//     user,
//     description,
//     rating,
//     profilepic,
//   };
//     if (!user || !description || !rating) {
//       return res.status(400).send({ error: true, message: "Missing required fields" });
//     }

//     recipe.reviews.push(newReview);
//     await recipe.save();
//     console.log("Review added:", newReview);

//     res.send({ error: false, message: "Review added", data: recipe });
//     console.log("recipe",recipe)
//   } catch (err) {
//     res.status(500).send({ error: true, message: err.message });
//   }
// });

// app.get("/reviews", async (req, res) => {
//   const recipes = await Recipes.find();
//   let allReviews = [];
//   recipes.forEach(recipe => {
//     allReviews = allReviews.concat(recipe.reviews);
//   });
//   res.json({ error: false, data: allReviews });
// });





app.listen(PORT, HOST, () => {
  console.log(`Server running at http://${HOST}:${PORT}`);
});
