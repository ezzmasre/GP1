// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wibsite/sign_in/main.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcom.jpg'),
            fit: BoxFit.fill, // Ensures the image covers the entire container
          ),
        ),

        //padding: EdgeInsets.all(20),
        //decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: bot(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bot(BuildContext context) {
    // Accept context here
    return Container(
      //color: Colors.black,
      padding: EdgeInsets.all(19),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(40)),
          color: Color(0xff1E2021)),
      width: MediaQuery.of(context).size.width, // Access the width from size
      //  height: 200, // Add height or any other dimension as needed
      child: Center(
        child: Column(
          children: [
            Text(
              'Increase your target to \nbe healthier\nto continue exercising',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "This application can improve yourself\nto have a healthy lifestyle by exercising",
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color.fromARGB(255, 172, 166, 166)),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffD5FF5F)),
                onPressed: () {},
                child: Text(
                  "get started",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white, // Default text color
                  fontSize: 16,
                ),
                children: [
                  TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: Color(0xffD5FF5F), // Color for the clickable text
                      fontWeight: FontWeight.bold, // Bold text for emphasis
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to the RegisterPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
