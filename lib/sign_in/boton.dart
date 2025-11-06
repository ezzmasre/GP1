import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:log/palet.dart';
import 'package:wibsite/sign_in/palet.dart';

// ignore: camel_case_types
class boton extends StatelessWidget {
  final String text;
  final String path;

  const boton({super.key, required this.path, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(
        path,
        width: 25,
        color: Pallete.whiteColor,
      ),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Pallete.borderColor, width: 4),
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 90)),
    );
  }
}
