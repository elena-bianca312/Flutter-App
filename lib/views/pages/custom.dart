import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle price = GoogleFonts.inter(
  color: yellow,
  fontSize: 15,
  fontWeight: FontWeight.w700,
);

TextStyle superheader = GoogleFonts.inter(
  color: white,
  fontSize: 26,
  // fontWeight: FontWeight.w700,
);

TextStyle header = GoogleFonts.inter(
  color: white,
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

TextStyle blackheader = GoogleFonts.inter(
  color: black,
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

TextStyle subheader = GoogleFonts.inter(
  color: white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle small = GoogleFonts.inter(
  color: grey,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle p = GoogleFonts.inter(
  color: grey,
  fontSize: 16,
  height: 1.6,
  fontWeight: FontWeight.w400,
);

TextStyle payment = GoogleFonts.inter(
  color: white,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle paymentSelected = GoogleFonts.inter(
  color: black,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

TextStyle labelPrimary = GoogleFonts.inter(
  color: black,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

TextStyle labelSecondary = GoogleFonts.inter(
  color: grey,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(327, 50),
  backgroundColor: kCustomBlue,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    ),
  ),
);