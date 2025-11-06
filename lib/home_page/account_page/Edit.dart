import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wibsite/saving_data/save_data.dart';
import 'package:wibsite/sign_up_moblie/textfield_signup.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String? savedString;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hintPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  void initState() {
    super.initState();
    loadString();
    // print("hello $savedString "); // Load the saved string when the page loads
  }

  Future<void> loadString() async {
    String? data = await getString(); // Get the string from SharedPreferences
    setState(() {
      savedString = data;
      // Update the UI with the retrieved data
    });
  }

  void updateProfile() async {
    // Collect the data from the controllers
    String email = emailController.text;
    String password = passwordController.text;
    String hintPassword = hintPasswordController.text;
    String name = nameController.text;
    String age = ageController.text;
    String weight = weightController.text;

    // Validate if all fields are filled
    if (password.isEmpty ||
        hintPassword.isEmpty ||
        name.isEmpty ||
        age.isEmpty ||
        weight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    // Check if passwords match
    if (password != hintPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    // Prepare the body for the request
    final Map<String, String> updatedData = {
      'password': password,
      'name': name,
      'age': age,
      'weight': weight,
    };

    try {
      // Send the HTTP PUT request
      final response = await http.put(
        Uri.parse('https://fitnes-bakeend.onrender.com/profile/$savedString'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // If the HTTP request is successful, proceed to update Firebase password
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not logged in.")),
          );
          return;
        }

        // Update the Firebase password
        await currentUser.updatePassword(password);

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully.")),
        );
        Navigator.pop(context);

        print('Profile updated successfully');
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: ${response.body}")),
        );
        print('Error updating profile: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffD5FF5F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B1B1B), Color(0xFF3A3A3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Edit Your Profile",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffD5FF5F),
                    ),
                  ),
                  const SizedBox(height: 30),
                  textfiled_signupmoblie(
                    icon: Icons.person,
                    controller: nameController,
                    hint: "Edit Your Name",
                    secrt: false,
                  ),
                  const SizedBox(height: 15),
                  textfiled_signupmoblie(
                    icon: Icons.cake,
                    controller: ageController,
                    hint: "Edit Your Age",
                    secrt: false,
                  ),
                  const SizedBox(height: 15),
                  textfiled_signupmoblie(
                    icon: Icons.fitness_center,
                    controller: weightController,
                    hint: "Edit Your Weight",
                    secrt: false,
                  ),
                  const SizedBox(height: 15),
                  textfiled_signupmoblie(
                    icon: Icons.lock,
                    controller: passwordController,
                    hint: "New Password",
                    secrt: true,
                  ),
                  const SizedBox(height: 15),
                  textfiled_signupmoblie(
                    icon: Icons.lock_outline,
                    controller: hintPasswordController,
                    hint: "Confirm Password",
                    secrt: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD5FF5F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      fixedSize: const Size(300, 50),
                    ),
                    onPressed: updateProfile,
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Visibility(
                    visible: false,
                    child: Text(
                      "Please fill in all fields.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
