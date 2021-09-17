import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:whatsapp_to_phonecall/utils/snackbar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  FocusNode _uidNode = FocusNode();

  bool _granted = false;

  final TextEditingController _uidController = TextEditingController();

  String? uid;

  final _loginInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _uidNode.unfocus();
        },
        child: SafeArea(
          child: Material(
            child: Form(
              key: _loginInFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Login to Server"
                      .text
                      .xl5
                      // .bold
                      .fontFamily(GoogleFonts.baloo().fontFamily!)
                      .color(Vx.blue900)
                      .make(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  // 20.heightBox,
                  Column(
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            focusNode: _uidNode,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_circle,
                                size: 30,
                              ).p(0),
                              labelText: "User id",
                              hintText: "Enter the User id",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            controller: _uidController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            onChanged: (value) {
                              uid = value;
                            },
                          ),
                          20.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Vx.blue400),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await _permissionWidget(context);
                                    if (_loginInFormKey.currentState!
                                            .validate() &&
                                        _granted) {
                                      Database.userUid = uid;
                                      //or
                                      //  Database.userUid =_uidController.text;

                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              MyRoutes.homeRoute);
                                    }

                                    if (!_granted) {
                                      CustomSnackBar(context,
                                          "App needs permission".text.make(),
                                          bg: Vx.red400);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ).pSymmetric(h: 20, v: 20),
            ),
          ),
        ),
      ),
    );
  }

  _permissionWidget(context) async {
    if (Platform.isAndroid) {
      // var status = await Permission.location.status;
      var optimizeStatus = await Permission.ignoreBatteryOptimizations.status;
      var phoneStatus = await Permission.phone.status;
      var contactStatus = await Permission.contacts.status;
      var gpsStatus = await Permission.location.status;
      var backgoundGpsStatus = await Permission.locationAlways.status;
      if (phoneStatus.isDenied) {
        if (await Permission.phone.request().isGranted) {
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Phone Permission'),
                  content:
                      Text('This app needs call access to call using dialer'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Deny'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Settings'),
                      onPressed: () async {
                        await openAppSettings();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
      if (contactStatus.isDenied) {
        if (await Permission.contacts.request().isGranted) {
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('contact Permission'),
                  content: Text(
                      'This app needs contact access to retrive/create new contacts'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Deny'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Settings'),
                      onPressed: () async {
                        await openAppSettings();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
      if (gpsStatus.isDenied) {
        if (await Permission.location.request().isGranted) {
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Gps Permission'),
                  content:
                      Text('This app needs gps access to locate your phone'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Deny'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Settings'),
                      onPressed: () async {
                        await openAppSettings();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
      if (backgoundGpsStatus.isDenied) {
        if (await Permission.locationAlways.request().isGranted) {
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Background Gps Permission'),
                  content: Text(
                      'This app needs background gps access to locate your phone while running in background\nAllow if you want to get locaton of your phone all time'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Deny'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Settings'),
                      onPressed: () async {
                        await openAppSettings();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
      if (optimizeStatus.isDenied) {
        if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Ignore Battery Optimizations Permission'),
                  content: Text('This app needs to be running in background'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Deny'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Settings'),
                      onPressed: () async {
                        await openAppSettings();

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      }
      if (phoneStatus.isGranted &&
          contactStatus.isGranted &&
          gpsStatus.isGranted & optimizeStatus.isGranted) {
        _granted = true;
      }
    }
  }
}
