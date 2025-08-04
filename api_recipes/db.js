const mongoose = require("mongoose");

const connectToDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URL);
    console.log("MongoDB connection established successfully.");

    // Drop the unique index on the email field if it exists
    const userCollection = mongoose.connection.collection("users");

    const indexes = await userCollection.indexes();
    const emailIndex = indexes.find(index => index.key.email === 1 && index.unique);

    if (emailIndex) {
      await userCollection.dropIndex("email_1");
     
     
      console.log("Dropped unique index on email field in users collection.");
    } else {
      console.log("No unique index on email found or already removed.");
    }

  } catch (error) {
    console.error("Failed to connect to MongoDB:", error.message);
    process.exit(1);
  }
};

connectToDatabase();

module.exports = mongoose;
















// const mongoose = require("mongoose");

// let db;

// const connectToDatabase = async () => {
//   try {
//     db = await mongoose.connect(process.env.MONGO_URL, {
//      // useNewUrlParser: true,
//       //useUnifiedTopology: true,
//     });
//     console.log(" MongoDB connection established successfully.");
//   } catch (error) {
//     console.error(" Failed to connect to MongoDB:", error.message);
//     process.exit(1); // Exit the application on failure
//   }
// };

// connectToDatabase();

// module.exports = db;
