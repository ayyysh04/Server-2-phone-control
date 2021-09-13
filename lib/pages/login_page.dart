import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/pages/home_page.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _uidController = TextEditingController();
  String? uid;
  final _loginInFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Form(
          key: _loginInFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 24.0,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: "User id",
                        hintText: "Enter the User id",
                      ),
                      controller: _uidController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      onChanged: (value) {
                        uid = value;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Container(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Vx.orange400),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_loginInFormKey.currentState!.validate()) {
                        Database.userUid = _uidController.text;

                        Navigator.of(context)
                            .pushReplacementNamed(MyRoutes.homeRoute);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
