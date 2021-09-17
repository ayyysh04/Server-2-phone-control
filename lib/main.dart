import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/pages/home_page.dart';
import 'package:whatsapp_to_phonecall/pages/login_page.dart';
import 'package:whatsapp_to_phonecall/pages/signup_page.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';

void main() {
  runApp(MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Vx.gray300,
        textTheme: TextTheme(
          headline4: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.SignupRoute: (context) => SignupPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
