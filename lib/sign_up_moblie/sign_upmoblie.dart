import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wibsite/firebasenotifation/masseging.dart';
import 'package:wibsite/home_page/home.dart';
import 'package:wibsite/saving_data/save_data.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';
import 'package:wibsite/sign_inmoblie/signin_moblie.dart';
import 'package:wibsite/sign_up_moblie/textfield_signup.dart';
import 'package:http/http.dart' as http;

class SignUpmoblie extends StatelessWidget {
  const SignUpmoblie({super.key});

  @override
  Widget build(BuildContext context) {
    String? savedString;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController hintPasswordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController hightController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    Future<void> submitData() async {
      
      const url =
          'https://fitnes-bakeend.onrender.com/users'; // Replace with your actual backend URL
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
          'weight': int.tryParse(weightController.text) ?? 0,
          'role': "user",
          'token':"",
          'vedios': [],
        }),
      );

      if (response.statusCode == 201) {
        print('User created successfully');
      } else {
        print('Failed to create user: ${response.body}');
      }

      ///chelsea.app
    }

    void rigester() async {
      final auth = Authservce();

      if (passwordController.text == hintPasswordController.text) {
        try {
          await saveString(emailController.text);

          await auth.sighnup_emailpassword(
            emailController.text,
            passwordController.text,
          );
          submitData();


          // Navigate to another page on success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const signin_mobilState(), // Replace with your target page
            ),
          );
        } catch (e) {
          // Show an error dialog if something goes wrong
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Show a dialog if passwords do not match
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Password Mismatch"),
            content: const Text("The passwords do not match. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }

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
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
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
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffD5FF5F),
                        ),
                      ),
                      const SizedBox(height: 20),
                      textfiled_signupmoblie(
                        icon: Icons.email,
                        controller: emailController,
                        hint: "Email",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.lock,
                        controller: passwordController,
                        hint: "Password",
                        secrt: true,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.lock_outline,
                        controller: hintPasswordController,
                        hint: "Confirm Password",
                        secrt: true,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.person,
                        controller: nameController,
                        hint: "Your Name",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.cake,
                        controller: ageController,
                        hint: "Your Age",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.height,
                        controller: hightController,
                        hint: "Your hight",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      textfiled_signupmoblie(
                        icon: Icons.fitness_center,
                        controller: weightController,
                        hint: "Your weight",
                        secrt: false,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD5FF5F),
                          fixedSize: const Size(300, 50),
                        ),
                        onPressed: () {
                          rigester();
                        },
                        child: const Text(
                          "Creat account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const signin_mobilState()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(color: Color(0xffD5FF5F)),
                        ),
                      ),
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
        ),
      ),
    );
  }
}
