import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/firebase_auth.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:whatsapp_to_phonecall/widget/permission_widget.dart';
import 'package:whatsapp_to_phonecall/widget/snackbar.dart';
import 'package:whatsapp_to_phonecall/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuthData.auth;
  late AnimationController _loginButtonController;
  late AnimationController _loginButtonZoomController;
  late Animation<double> _buttonSqueezeAnimation;
  late Animation<double> _buttonZoomout;
  late FocusNode _emailNode;
  late final TextEditingController _emailController;
  late FocusNode _passNode;
  late final TextEditingController _passController;
  bool _granted = false;
  bool _isSigningIn = false;
  late final _loginInFormKey;
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _auth
        .userChanges()
        .listen((event) => setState(() => UserData.user = event));
    _emailNode = FocusNode();
    _emailController = TextEditingController();

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
  }

  @override
  void dispose() {
    _loginButtonZoomController.dispose();
    _emailController.dispose();
    _loginButtonController.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  bool _isobscureText = true;
  String? _pass;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            _passNode.unfocus();

            _emailNode.unfocus();
          },
          child: Material(
            color: Colors.transparent,
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
                          ? MediaQuery.of(context).size.height * 0.25
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
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  _email = value;
                                },
                                onFieldSubmitted: (value) {
                                  _emailNode.unfocus();
                                  _passNode.requestFocus();
                                },
                              ).pOnly(left: 20, right: 20),
                            ),
                          ),
                          Visibility(
                              visible:
                                  MediaQuery.of(context).viewInsets.bottom == 0
                                      ? true
                                      : false,
                              child: 10.heightBox),
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
                                    Validator.validatePassword(
                                        password: value!),
                              ).pOnly(left: 20, right: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.75,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            if (_email != null) {
                              String? _isvalid =
                                  Validator.validateEmail(email: _email!);

                              if (_isvalid == null) {
                                FirebaseAuthData.resetWithEmailAndPassword(
                                    _email!, context);
                              } else
                                CustomSnackBar(context, _isvalid.text.make());
                            } else
                              CustomSnackBar(context,
                                  "Enter a valid email address".text.make());
                          },
                          child: Container(
                              height: 40,
                              child: "Forgot Password?".text.make().centered()),
                        ).pOnly(right: 20)),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.90,
                      child: Container(
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(MyRoutes.signupRoute);
                          },
                          child: Text(
                            'Don\'t have an account? Sign up',
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
                              onTap: _isSigningIn
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isSigningIn = true;
                                      });
                                      _emailNode.unfocus();
                                      _passNode.unfocus();
                                      _granted =
                                          await permissionWidget(context);
                                      await _loginButtonController.forward();
                                      if (_loginInFormKey.currentState!
                                              .validate() &&
                                          _granted &&
                                          await FirebaseAuthData
                                              .signInWithEmailAndPassword(
                                                  _email!, _pass!, context)) {
                                        Database.userUid = UserData.user!.uid;
                                        //or
                                        //  Database.userUid =_uidController.text;
                                        // await _playAnimation();
                                        final User? user = _auth.currentUser;

                                        if (user != null) {
                                          await _loginButtonZoomController
                                              .forward();
                                          await _loginButtonZoomController
                                              .reverse();
                                        }
                                      }
                                      if (UserData.user != null &&
                                          !UserData.user!.emailVerified) {
                                        bool _isverifing = false;
                                        bool _verified = false;
                                        await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (context, setStateBuild) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Email verification required'),
                                                  content: Container(
                                                    height: 150,
                                                    width: 200,
                                                    child: SizedBox.expand(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          _isverifing
                                                              ? Container(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                  width: 50,
                                                                  height: 50,
                                                                )
                                                              : _verified
                                                                  ? Icon(
                                                                      Icons
                                                                          .done,
                                                                      size: 100,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 100,
                                                                      color: Vx
                                                                          .red900,
                                                                    ),
                                                          _isverifing
                                                              ? "Verifying"
                                                                  .text
                                                                  .make()
                                                                  .py(10)
                                                              : _verified
                                                                  ? "You are verifed!\nLogin to continue"
                                                                      .text
                                                                      .make()
                                                                      .py(10)
                                                                  : "Click verify to continue"
                                                                      .text
                                                                      .make()
                                                                      .py(10),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Close')
                                                          .pSymmetric(
                                                              h: 10, v: 5),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    Visibility(
                                                      visible: !_isverifing,
                                                      child: TextButton(
                                                        child: Text('Verify')
                                                            .pSymmetric(
                                                                h: 10, v: 5),
                                                        onPressed: () async {
                                                          setStateBuild(() {
                                                            _isverifing = true;
                                                          });
                                                          try {
                                                            await UserData.user!
                                                                .sendEmailVerification();
                                                          } on FirebaseAuthException catch (e) {
                                                            print(e
                                                                .code); //only for debugging
                                                          }

                                                          _timer =
                                                              Timer.periodic(
                                                                  Duration(
                                                                      seconds:
                                                                          5),
                                                                  (timer) {
                                                            UserData.user!
                                                                .reload();
                                                            if (UserData.user!
                                                                    .emailVerified ==
                                                                true) {
                                                              setStateBuild(() {
                                                                _isverifing =
                                                                    false;
                                                                _verified =
                                                                    true;

                                                                timer.cancel();
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                            });
                                      }
                                      await _loginButtonController.reverse();
                                      if (!_granted) {
                                        CustomSnackBar(context,
                                            "App needs permission".text.make(),
                                            bg: Vx.red400);
                                      }

                                      _timer?.cancel();
                                      _emailController.clear();
                                      _passController.clear();
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
                                          : null))),
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
