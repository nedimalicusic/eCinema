import 'package:flutter/material.dart';

//const apiUrl = String.fromEnvironment('baseUrl', defaultValue: 'https://localhost:7019/api'); //USE LOCALHOST
const apiUrl = String.fromEnvironment('baseUrl', defaultValue: 'http://localhost:5100/api'); //USE DOCKER

const primaryColor = Colors.teal;
const secondaryColor = Color.fromARGB(255, 17, 18, 28);
const bgColor = Color.fromARGB(186, 37, 46, 83);
const myWhite = Color.fromARGB(185, 255, 255, 255);
const white = Colors.white;
const green = Color.fromRGBO(36, 228, 19, 1);
const darkGreen = Color.fromRGBO(27, 158, 15, 1);

const defaultPadding = 16.0;

Color myButtonColor = const Color.fromRGBO(21, 144, 15, 1);
Color myButtonDeleteColor = const Color.fromARGB(255, 241, 0, 0);

class PrimaryText extends StatelessWidget {
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final String? text;
  final double? height;

  const PrimaryText({
    super.key,
    this.text,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.white,
    this.size = 30,
    this.height = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: color,
        height: height,
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
