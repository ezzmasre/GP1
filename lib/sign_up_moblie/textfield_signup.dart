import 'package:flutter/material.dart';

class textfiled_signupmoblie extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool secrt;
  final IconData icon;
  const textfiled_signupmoblie(
      {super.key,
      required this.icon,
      required this.controller,
      required this.hint,
      required this.secrt});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 55),
      child: TextFormField(
        obscureText: secrt,
        controller: controller,
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.blueGrey,
            ),
            // icon: SvgPicture.asset(
            //   'assets/svgs/g_logo.svg',
            //   width: 20,
            //   color: Colors.white,
            // ),
            hintText: hint,
            // labelStyle: TextStyle(color: Colors.white),
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w100,
                color: Color.fromARGB(255, 195, 204, 170)),
            contentPadding: const EdgeInsets.all(25),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffD5FF5F), width: 3),
                borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 193, 198, 204), width: 1),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
