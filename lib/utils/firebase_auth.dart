import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contact.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:whatsapp_to_phonecall/widget/snackbar.dart';

class FirebaseAuthData {
  static late FirebaseAuth auth;

  static Future<bool> signInWithEmailAndPassword(
      String email, String pass, BuildContext context) async {
    try {
      UserData.user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      ))
          .user;
      if (UserData.user!.emailVerified) {
        CustomSnackBar(context, Text('${UserData.user!.email} signed in'));
      } else {
        CustomSnackBar(context,
            Text('${UserData.user!.email} not verified.Verify to login'));

        return false;
      }

      return true;
    } on FirebaseAuthException catch (e) {
      UserData.user = null;
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              bg: Vx.red500);
          break;
        case "user-disabled":
          CustomSnackBar(
              context, Text("$email is disibled.Contact administrator"),
              bg: Vx.red500);
          break;
        case "user-not-found":
          CustomSnackBar(context, Text("User not found"), bg: Vx.red500);
          break;
        case 'wrong-password':
          CustomSnackBar(context, Text("Incorrect Password"), bg: Vx.red500);
          break;
        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              bg: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"), bg: Vx.red500);
      }
    }
    return false;
  }

  static Future<void> resetWithEmailAndPassword(
      String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );

      CustomSnackBar(
          context, Text('Reset link sent to ${UserData.user!.email}'));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              bg: Vx.red500);
          break;

        case "user-not-found":
          CustomSnackBar(context, Text("User not found"), bg: Vx.red500);
          break;
        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              bg: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"), bg: Vx.red500);
      }
    }
  }

  static Future<bool> createAccount(
      {required String emailId,
      required String pass,
      required BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailId,
        password: pass,
      );

      CustomSnackBar(context, Text('${UserData.user!.email} account created'));
      return true;
    } on FirebaseAuthException catch (e) {
      UserData.user = null;
      switch (e.code) {
        case 'invalid-email':
          CustomSnackBar(context, Text("Email address is invalid"),
              bg: Vx.red500);
          break;
        case 'email-already-in-use':
          CustomSnackBar(context, Text("Email address is already in use"),
              bg: Vx.red500);
          break;
        case 'weak-password':
          CustomSnackBar(
              context, Text("Password too weak,Choose a strong password"),
              bg: Vx.red500);
          break;

        case "too-many-requests":
          CustomSnackBar(
              context, Text("Too many requests.Please try again later"),
              bg: Vx.red500);
          break;
        default:
          CustomSnackBar(context, Text("Server Error"), bg: Vx.red500);
      }
    }
    return false;
  }
}

class UserData {
  static User? user;
}

class VerifyEmailWidget extends StatelessWidget {
  const VerifyEmailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
