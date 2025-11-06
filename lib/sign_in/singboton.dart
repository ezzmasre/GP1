import 'package:flutter/material.dart';
// import 'package:log/palet.dart';

class singboton extends StatelessWidget {
  final void Function()? onPressed;

  // Constructor to accept the onPressed function
  const singboton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color(0xff43011D),
            // Color.fromARGB(255, 237, 227, 240),
            Color.fromARGB(255, 168, 12, 77),

            // Color.fromARGB(255, 206, 82, 82),
            // Color.fromARGB(255, 248, 0, 0),
            Color(0xff002C49),
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Transparent background for gradient effect
          fixedSize: const Size(390, 50),
        ),
        onPressed: onPressed, // Using the onPressed callback passed from parent
        child: const Text(
          "Sign in",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
