import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/login_screen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPowder,
        backgroundColor: kCream,
        buttonTheme: ButtonThemeData(
          buttonColor: kMikado,
          highlightColor: kMikado.withAlpha(108),
        ),
        accentColor: kMikado,
        cardColor: kCream,
        shadowColor: kCamblue,
        hintColor: kOpal,
        errorColor: kMatte,
        buttonColor: kMikado,
        canvasColor: kCream,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: kOpal,
          selectionColor: kCamblue,
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.robotoMono(
              fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: GoogleFonts.robotoMono(
              fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3:
              GoogleFonts.robotoMono(fontSize: 48, fontWeight: FontWeight.w400),
          headline4: GoogleFonts.robotoMono(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headline5:
              GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.w400),
          headline6: GoogleFonts.robotoMono(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: GoogleFonts.robotoMono(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: GoogleFonts.robotoMono(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: GoogleFonts.montserrat(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: GoogleFonts.montserrat(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          caption: GoogleFonts.montserrat(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: GoogleFonts.montserrat(
              fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
