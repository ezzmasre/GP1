// Import required Firebase and Firebase Functions modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize the Firebase Admin SDK
admin.initializeApp();

// Define an HTTP-triggered Firebase Function
exports.sendNotification = functions.https.onRequest(async (req, res) => {
  // Extract the title, body, and token from the request body
  const {title, body, token} = req.body;

  // Create a message object for FCM
  const message = {
    notification: {
      title: title, // No space after '{' or before '}'
      body: body,
    },
    token: token,
  };

  try {
    // Send the notification using the Firebase Admin SDK
    await admin.messaging().send(message);

    // Respond with a success message
    res.status(200).send("Notification sent successfully");
  } catch (error) {
    // Handle errors and respond with an error message
    console.error("Error sending notification:", error);
    res.status(500).send("Failed to send notification");
  }
});
