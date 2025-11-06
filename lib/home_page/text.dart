// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wibsite/sign_in/main.dart';
import 'package:wibsite/sign_up/sign_up.dart';

class para extends StatelessWidget {
  const para({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to our \nFitness Journey",
            style: TextStyle(
              color: Color(0xff04101A),
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),

          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignIn()), // Navigate to SecondPage
              );
            },
            child: Container(
              width: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 215, 236, 213), // First color
                      Color.fromARGB(255, 153, 209, 235), // Second color
                      Color.fromARGB(255, 25, 17, 137), // Third color
                    ],
                    begin: Alignment.topLeft, // Gradient start
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.green),
              child: Text("log in",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUp()), // Navigate to SecondPage
              );
            },
            child: Container(
              width: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 215, 236, 213), // First color
                      Color.fromARGB(255, 153, 209, 235), // Second color
                      Color.fromARGB(255, 25, 17, 137), // Third color
                    ],
                    begin: Alignment.topLeft, // Gradient start
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.green),
              child: Text("Sign up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
