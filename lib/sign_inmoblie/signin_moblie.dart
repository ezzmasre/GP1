import 'package:flutter/material.dart';
import 'package:wibsite/firebasenotifation/masseging.dart';
import 'package:wibsite/home_page/home.dart';
import 'package:wibsite/saving_data/save_data.dart';
import 'package:wibsite/sign_inmoblie/auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:wibsite/sign_up_moblie/sign_upmoblie.dart';
import 'package:wibsite/sign_up_moblie/textfield_signup.dart';

class signin_mobilState extends StatefulWidget {
  const signin_mobilState({super.key});

  @override
  State<signin_mobilState> createState() => __signin_mobilStateState();
}

class __signin_mobilStateState extends State<signin_mobilState> {
  @override
  String? savedString;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController hintPasswordController =
        TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
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
                        "Sign in",
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD5FF5F),
                          fixedSize: const Size(300, 50),
                        ),
                        onPressed: () async {
                          final authservice = Authservce();

                          try {
                            await saveString(emailController.text);

                            await authservice.sighinwith_eamil(
                              emailController.text,
                              passwordController.text,
                            );
                            savetoken(emailController.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Home_Page(), // Replace with your target page
                              ),
                            );
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                    title: Text("invalid email or password")));
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => Home_Page()),
                          // );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpmoblie()),
                          );
                        },
                        child: const Text(
                          "you dont have account? Sign up",
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
  
  Future<void> savetoken(String email ) async {

       final token= await firebaseapi().initNotifications();
       print(token);
       if (token != null) {
    final url = Uri.parse("https://fitnes-bakeend.onrender.com/pro_users/token/$email"); // Replace with your API URL
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"token": token}),
      );

      if (response.statusCode == 200) {
        print("Token saved successfully: ${response.body}");
      } else {
        print("Failed to save token: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Error while saving token: $error");
    }
  } else {
    print("FCM token is null, skipping API call.");
  }


  }
}
