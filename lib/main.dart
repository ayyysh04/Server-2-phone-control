import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:whatsapp_to_phonecall/pages/home_page.dart';
import 'package:whatsapp_to_phonecall/pages/login_page.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';

void main() {
  runApp(MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        MyRoutes.loginRoute: (context) => LoginPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// class LoginPage extends StatelessWidget {
//   _checkStatus() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.wifi ||
//         connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   LoginPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: Column(
//           children: [
//             FutureBuilder(
//                 future: _checkStatus(),
//                 builder: (context, snapshot) {
//                   if (snapshot.data == false) {
//                     return CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Vx.orange400),
//                     );
//                   }
//                   return LoginPage();
//                 })
//           ],
//         ),
//       ),
//     ));
//   }
// }
