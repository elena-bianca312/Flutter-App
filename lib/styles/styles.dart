import 'package:flutter/material.dart';

const TextStyle kHeading = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle kBodyText = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

const TextStyle kPageText = TextStyle(
  fontSize: 50,
  color: Colors.white,
  fontFamily: 'JosefinSans'
);

Color black = const Color(0xff010518);
Color yellow = const Color(0xffFCAD00);
Color white = const Color(0xffFFFFFF);
Color grey = const Color(0xff8B8FA0);

const Color kCustomBlue = Color.fromARGB(255, 61, 128, 183);

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);