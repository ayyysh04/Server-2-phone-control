import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/pages/home_page.dart';
import 'package:whatsapp_to_phonecall/pages/login_page.dart';
import 'package:whatsapp_to_phonecall/pages/signup_page.dart';
import 'package:whatsapp_to_phonecall/utils/firebase_auth.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splashIconSize: MediaQuery.of(context).size.width / 1.2,
      splash: Image(
        image: AssetImage("assets/images/logo.png"),
      ),
      nextScreen: LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        "assets/images/logo.png",
      ),
      logoSize: 120,
      showLoader: true,
      loadingText: Text("MADE IN INDIA"),
      futureNavigator: _futureNav(context),
    );
  }

  Future<Object>? _futureNav(context) async {
    await Firebase.initializeApp();
    FirebaseAuthData.auth = FirebaseAuth.instance;
    await Future.delayed(Duration(seconds: 3));
    return Future.value(new LoginPage());
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
