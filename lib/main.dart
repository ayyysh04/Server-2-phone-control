import 'package:easy_splash_screen/easy_splash_screen.dart';
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

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("assets/images/logo.png"),
      logoSize: 120,
      showLoader: true,
      loadingText: Text("MADE IN INDIA"),
      navigator: LoginPage(),
      durationInSeconds: 3,
    );
  }
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
        "/": (context) => SplashScreen(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.signupRoute: (context) => SignupPage()
      },
      // onGenerateRoute: (RouteSettings settings) {
      //   switch (settings.name) {
      //     case '/login':
      //       return new MyCustomRoute(
      //         builder: (_) => LoginPage(),
      //         settings: settings,
      //       );

      //     case '/home':
      //       return new MyCustomRoute(
      //         builder: (_) => HomePage(),
      //         settings: settings,
      //       );
      //   }
      // },
      debugShowCheckedModeBanner: false,
    );
  }
}
