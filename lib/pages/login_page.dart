import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:whatsapp_to_phonecall/utils/snackbar.dart';
import 'package:whatsapp_to_phonecall/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  User? user;
  late final FirebaseAuth _auth;
  late AnimationController _loginButtonController;
  late AnimationController _loginButtonZoomController;
  late Animation<double> _buttonSqueezeAnimation;
  late Animation<double> _buttonZoomout;
  late FocusNode _uidNode;
  late final TextEditingController _uidController;
  late FocusNode _passNode;
  late final TextEditingController _passController;
  bool _granted = false;
  bool _isSigningIn = false;
  late final _loginInFormKey;
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _auth.userChanges().listen((event) => setState(() => user = event));
    _uidNode = FocusNode();
    _uidController = TextEditingController();

    _passNode = FocusNode();
    _passController = TextEditingController();

    _loginInFormKey = GlobalKey<FormState>();

    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        setState(() {
          if (_loginButtonController.isCompleted) {}
        });
      });
    _loginButtonZoomController = AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        setState(() {
          if (_loginButtonZoomController.isCompleted) {
            Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
          }
        });
      });
    _buttonZoomout = new Tween(
      begin: 70.0,
      end: 1000.0,
    ).animate(CurvedAnimation(
      parent: _loginButtonZoomController,
      curve: new Interval(
        0.550,
        0.900,
        curve: Curves.bounceOut,
      ),
    ));

    _buttonSqueezeAnimation = new Tween(
      begin: 352.7,
      end: 70.0,
    ).animate(new CurvedAnimation(
        parent: _loginButtonController, curve: new Interval(0.0, 0.250)));
    super.initState();
  }

  @override
  void dispose() {
    _loginButtonZoomController.dispose();
    _uidController.dispose();
    _loginButtonController.dispose();
    _uidNode.dispose();
    super.dispose();
  }

  bool _isobscureText = false;
  String? _pass;
  String? _uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _passNode.unfocus();

          _uidNode.unfocus();
        },
        child: Material(
          child: Form(
            key: _loginInFormKey,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 40,
                    left: 0,
                    child: "Login to Server"
                        .text
                        .xl5
                        // .bold
                        .fontFamily(GoogleFonts.baloo().fontFamily!)
                        .color(Color.fromRGBO(247, 64, 106, 1.0))
                        .make()
                        .pOnly(left: 20),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom == 0
                        ? MediaQuery.of(context).size.height * 0.22
                        : 10,
                    child: Column(
                      children: [
                        Visibility(
                          visible: (_passNode.hasFocus &&
                                  MediaQuery.of(context).viewInsets.bottom != 0)
                              ? false
                              : true,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              validator: (value) =>
                                  Validator.validateEmail(email: value!),
                              focusNode: _uidNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                ).p(0),
                                labelText: "User id",
                                hintText: "Enter the User id",
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(247, 64, 106, 1.0),
                                    width: 3.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Vx.blue600,
                                    width: 3.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    width: 3.0,
                                    color: Vx.blue600,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(247, 64, 106, 1.0),
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              controller: _uidController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _uid = value;
                              },
                              onFieldSubmitted: (value) {
                                _uidNode.unfocus();
                                _passNode.requestFocus();
                              },
                            ).pOnly(left: 20, right: 20),
                          ),
                        ),
                        5.heightBox,
                        Visibility(
                          visible: (_uidNode.hasFocus &&
                                  MediaQuery.of(context).viewInsets.bottom != 0)
                              ? false
                              : true,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              focusNode: _passNode,
                              obscureText: _isobscureText,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 17.0, horizontal: 10.0),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isobscureText = _isobscureText.toggle();
                                    });
                                  },
                                  child: Icon(
                                    _isobscureText
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  size: 30,
                                ).p(0),
                                labelText: "Password",
                                hintText: "Enter the Password id",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    width: 3.0,
                                    color: Vx.blue600,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(247, 64, 106, 1.0),
                                    width: 3.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(247, 64, 106, 1.0),
                                    width: 3.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Vx.blue600,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              controller: _passController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              onChanged: (value) {
                                _pass = value;
                              },
                              validator: (value) =>
                                  Validator.validatePassword(password: value!),
                            ).pOnly(left: 20, right: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.90,
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(MyRoutes.signupRoute);
                        },
                        child: Text(
                          'Don\'t have an account? Sign up',
                          style: TextStyle(
                            // color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: _buttonZoomout.value < 300.0
                        ? MediaQuery.of(context).size.height * 0.8
                        : null,
                    child: Padding(
                      padding: _buttonZoomout.value == 70
                          ? const EdgeInsets.only(
                              bottom: 50.0,
                            )
                          : EdgeInsets.only(top: 0.0, bottom: 0.0),
                      child: InkWell(
                          onTap: _isSigningIn
                              ? null
                              : () async {
                                  await _permissionWidget(context);
                                  if (_loginInFormKey.currentState!
                                          .validate() &&
                                      _granted &&
                                      await _signInWithEmailAndPassword()) {
                                    Database.userUid = _uid;
                                    //or
                                    //  Database.userUid =_uidController.text;
                                    // await _playAnimation();
                                    setState(() {
                                      _isSigningIn = true;
                                    });

                                    final User? user = _auth.currentUser;

                                    if (user != null) {
                                      await _loginButtonController.forward();

                                      await _loginButtonZoomController
                                          .forward();
                                      await _loginButtonZoomController
                                          .reverse();
                                      await _loginButtonController.reverse();
                                    }
                                  }

                                  if (!_granted) {
                                    CustomSnackBar(context,
                                        "App needs permission".text.make(),
                                        bg: Vx.red400);
                                  }
                                  setState(() {
                                    _isSigningIn = false;
                                  });
                                },
                          child: Container(
                              width: _buttonZoomout.value == 70
                                  ? _buttonSqueezeAnimation.value
                                  : _buttonZoomout.value,
                              height: _buttonZoomout.value == 70
                                  ? 60.0
                                  : _buttonZoomout.value,
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                color: _buttonZoomout.value == 70
                                    ? Color.fromRGBO(247, 64, 106, 1.0)
                                    : Color.fromRGBO(247, 64, 106, 1.0),
                                borderRadius: _buttonZoomout.value < 400
                                    ? new BorderRadius.all(
                                        const Radius.circular(30.0))
                                    : new BorderRadius.all(
                                        const Radius.circular(0.0)),
                              ),
                              child: _buttonSqueezeAnimation.value > 75.0
                                  ? new Text(
                                      "Sign In",
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.3,
                                      ),
                                    )
                                  : _buttonZoomout.value < 300.0
                                      ? new CircularProgressIndicator(
                                          value: null,
                                          strokeWidth: 1.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )
                                      : null)),
                    ),
                  ),
                ],
              ),
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

  Future<bool> _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _uid!,
        password: _pass!,
      ))
          .user;
      CustomSnackBar(context, Text('${user!.email} signed in'));
      return true;
    } catch (e) {
      CustomSnackBar(context, Text('Failed to sign in with Email & Password'));
    }
    return false;
  }
}
