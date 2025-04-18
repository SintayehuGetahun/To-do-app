const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");  // Import CORS

// Import your routes
const UserRoute = require("./routes/user.router");
const ToDoRoute = require('./routes/todo.routes');

// Initialize your Express app
const app = express();

// Enable CORS to allow cross-origin requests from Flutter
app.use(cors());  // Add this line to enable CORS

// Middleware to parse JSON data in the body of the requests
app.use(bodyParser.json());

// Use routes for User and ToDo functionalities
app.use("/", UserRoute);  // User routes
app.use("/", ToDoRoute);   // ToDo routes

// Export the app
module.exports = app;
