import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/firebase_auth.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:whatsapp_to_phonecall/widget/snackbar.dart';
import 'package:whatsapp_to_phonecall/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  // late final FirebaseAuth _auth;
  late AnimationController _signUpButtonController;
  late AnimationController _signUpButtonZoomController;
  late Animation<double> _buttonSqueezeAnimation;
  late Animation<double> _buttonZoomout;
  late FocusNode _emailNode;
  late final TextEditingController _emailController;
  late FocusNode _passNode;
  late final TextEditingController _passController;

  bool _isSigningUp = false;
  late final _signUpFormKey;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    // _auth = FirebaseAuth.instance;

    _emailNode = FocusNode();
    _emailController = TextEditingController();

    _passNode = FocusNode();
    _passController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _signUpFormKey = GlobalKey<FormState>();

    _signUpButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        setState(() {
          if (_signUpButtonController.isCompleted) {}
        });
      });
    _signUpButtonZoomController = AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        setState(() {
          if (_signUpButtonZoomController.isCompleted) {
            Navigator.pop(context);
          }
        });
      });
    _buttonZoomout = new Tween(
      begin: 70.0,
      end: 1000.0,
    ).animate(CurvedAnimation(
      parent: _signUpButtonZoomController,
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
        parent: _signUpButtonController, curve: new Interval(0.0, 0.250)));
    super.initState();
  }

  @override
  void dispose() {
    _signUpButtonZoomController.dispose();
    _emailController.dispose();
    _signUpButtonController.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  bool _isobscureText = true;
  String? _pass;
  String? _emailId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            _passNode.unfocus();

            _emailNode.unfocus();
          },
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _signUpFormKey,
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 40,
                      left: 0,
                      child: "Signup to Server"
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
                                    MediaQuery.of(context).viewInsets.bottom !=
                                        0)
                                ? false
                                : true,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    Validator.validateEmail(email: value!),
                                focusNode: _emailNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    size: 30,
                                  ).p(0),
                                  labelText: "Email id",
                                  hintText: "Enter your Email id",
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
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  _emailId = value;
                                },
                                onFieldSubmitted: (value) {
                                  _emailNode.unfocus();
                                  _passNode.requestFocus();
                                },
                              ).pOnly(left: 20, right: 20),
                            ),
                          ),
                          5.heightBox,
                          Visibility(
                            visible: (_emailNode.hasFocus &&
                                    MediaQuery.of(context).viewInsets.bottom !=
                                        0)
                                ? false
                                : true,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                focusNode: _passNode,
                                obscureText: _isobscureText,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 17.0, horizontal: 10.0),
                                  suffix: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isobscureText =
                                            _isobscureText.toggle();
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
                                  hintText: "Create a Password ",
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
                                    Validator.validatePassword(
                                        password: value!),
                              ).pOnly(left: 20, right: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.90,
                      child: Container(
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Already have an account? Sign in',
                            style: TextStyle(
                              // color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ).centered(),
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
                            onTap: _isSigningUp
                                ? null
                                : () async {
                                    print("opop");
                                    setState(() {
                                      _isSigningUp = true;
                                    });

                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Terms and Condition'),
                                            content: Text(
                                                'By pressing “submit” you agree to our terms & condition'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Deny'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Accept'),
                                                onPressed: () async {
                                                  Navigator.of(_scaffoldKey
                                                          .currentContext!)
                                                      .pop();
                                                  await _signUpButtonController
                                                      .forward();
                                                  if (_signUpFormKey
                                                          .currentState!
                                                          .validate() &&
                                                      await FirebaseAuthData
                                                          .createAccount(
                                                              emailId:
                                                                  _emailId!,
                                                              pass: _pass!,
                                                              context: _scaffoldKey
                                                                  .currentContext!)) {
                                                    await _signUpButtonZoomController
                                                        .forward();
                                                    await _signUpButtonZoomController
                                                        .reverse();
                                                  }
                                                  await _signUpButtonController
                                                      .reverse();
                                                  _passController.clear();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    setState(() {
                                      _isSigningUp = false;
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
                                child: _buttonSqueezeAnimation.value > 200.0
                                    ? new Text(
                                        "Create account",
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
      ),
    );
  }
}
