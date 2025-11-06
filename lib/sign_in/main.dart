// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wibsite/home_page/home.dart';
import 'package:wibsite/sign_in/palet.dart';
import 'package:wibsite/sign_in/singboton.dart';
import 'package:wibsite/sign_in/textfiled.dart';
import 'package:wibsite/sign_up/sign_up.dart';
//import 'package:wibsite/the_main_page/the_mainpage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isVisible = false;
  // sending email
  Future<void> sendEmail(String to, String subject, String text) async {
    const url = 'http://192.168.1.11:3000/send-email';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': to,
        'subject': subject,
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent!');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }
//////

  void searchById(String id) async {
    final url = Uri.parse('http://192.168.1.11:3000/pro/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data != null) {
          String password = data['password'];
          String email = data['email'];
          if (password == passwordController.text &&
              email == emailController.text) {
            sendEmail(emailController.text, 'hey', 'love u body');
            print("ezz is chelsea");
            setState(() {
              _isVisible = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Page()),
              );
            });
          } else {
            setState(() {
              passwordController.clear();
              _isVisible = true;
            });
          }
        }
        if (data == null) {
          setState(() {
            passwordController.clear();
            _isVisible = true;
          });
        }
      } else {
        print('Product not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void signInPress() {
    String email = emailController.text;
    String password = passwordController.text;
    searchById(email);

    print('Email: $email');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
      ),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Make the AppBar transparent
          elevation: 0, // Remove the AppBar shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 25, 159, 248)), // Back arrow button
            onPressed: () {
              Navigator.pop(context); // Go back to the previous page
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sign_in/in.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            // Center the content
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black54
                    .withOpacity(0.7), // Background color with opacity
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To fit content
                  children: [
                    Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: const <Color>[
                              Color(0xff43011D),
                              Color.fromARGB(255, 25, 159, 248),
                            ],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    SizedBox(height: 70),
                    textfeld(
                      icon: Icons.email,
                      secrt: false,
                      controller: emailController,
                      hint: "Email",
                    ),
                    SizedBox(height: 20),
                    textfeld(
                      icon: Icons.lock,
                      controller: passwordController,
                      hint: "Password",
                      secrt: true,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                            color: Colors.white), // Style for the regular text
                        children: [
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                                color: Colors
                                    .blue), // Style for the clickable text
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to another page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUp()), // Replace with your page
                                );
                              },
                          ),
                        ],
                      ),
                    ),

                    // Text("Rigister"),
                    Visibility(
                      visible: _isVisible,
                      // ignore: duplicate_ignore
                      // ignore: prefer_const_constructors
                      child: Text(
                        "Wrong password or email",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    singboton(
                      onPressed: signInPress,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
