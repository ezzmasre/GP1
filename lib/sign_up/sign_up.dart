import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wibsite/sign_up/textfield_signup.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hintPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool visible = false;
  Future<void> submitData() async {
    const url =
        'http://192.168.1.11:3000/users'; // Replace with your actual backend URL
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'age': int.tryParse(ageController.text) ?? 0,
      }),
    );

    if (response.statusCode == 201) {
      print('User created successfully');
    } else {
      print('Failed to create user: ${response.body}');
    }
  }

  void onPressed() {
    if (emailController.text.isEmpty &&
        passwordController.text.isEmpty &&
        hintPasswordController.text.isEmpty &&
        nameController.text.isEmpty &&
        ageController.text.isEmpty) {
      setState(() {
        visible = true; // Update visibility to show an error or message
      });
    } else {
      // Proceed with sign-up logic here

      setState(() {
        visible = false; // Hide the message if inputs are filled
      });
      submitData();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sign_up/ff.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 84, 189),
                        ),
                      ),
                      const SizedBox(height: 20),
                      textfiled_signup(
                        icon: Icons.email,
                        controller: emailController,
                        hint: "Email",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signup(
                        icon: Icons.lock,
                        controller: passwordController,
                        hint: "Password",
                        secrt: true,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signup(
                        icon: Icons.lock_outline,
                        controller: hintPasswordController,
                        hint: "Confirm Password",
                        secrt: true,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signup(
                        icon: Icons.person,
                        controller: nameController,
                        hint: "Your Name",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signup(
                        icon: Icons.cake,
                        controller: ageController,
                        hint: "Your Age",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 5, 176, 238),
                              Color.fromARGB(255, 20, 0, 122),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            fixedSize: const Size(300, 50),
                          ),
                          onPressed: onPressed,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: const Text(
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
        ),
      ),
    );
  }
}
