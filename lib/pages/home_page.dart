import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/model/data_model.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';

class HomePage extends StatelessWidget {
  Database firebaseData = Database();
  HomePage({Key? key}) : super(key: key);
  String? phNumber;
  final _formKey = GlobalKey<FormState>();
  FocusNode _phoneNoNode = FocusNode();
  TextEditingController _phoneNoController = TextEditingController();
  _callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != null && res == true) {
      print("done");
    } else
      print("Not done");
  }

  @override
  Widget build(BuildContext context) {
    // Database.addItem(title: "First commit", description: "Yo Yo fam");
    // Database.deleteItem(docId: "KXYQNqLJo8x285mEVpn8");

    return SafeArea(
      child: Material(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    "Whatsapp to direct call"
                        .text
                        .xl3
                        .fontFamily(GoogleFonts.poppins().fontFamily!)
                        .bold
                        .make(),
                  ],
                ),
                20.heightBox,
                // Visibility(
                //   child: Container(
                //     child: TextFormField(
                //       focusNode: _phoneNoNode,
                //       decoration: InputDecoration(
                //         prefixIcon: Icon(Icons.phone_iphone_sharp),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40.0),
                //         ),
                //         hintText: "Enter Phone number",
                //         labelText: "Phone number",
                //         contentPadding: EdgeInsets.symmetric(vertical: 5),
                //       ),
                //       controller: _phoneNoController,
                //       keyboardType: TextInputType.number,
                //       textInputAction: TextInputAction.go,
                //       onFieldSubmitted: (value) {
                //         _phoneNoNode.unfocus();
                //       },
                //       onChanged: (value) {
                //         phNumber = value;
                //       },
                //     ),
                //   ).wh(220, 50),
                // ),
                // 20.heightBox,
                // Row(
                //   children: [
                //     ElevatedButton(
                //         onPressed: () {
                //           _callNumber(phNumber!);
                //         },
                //         child: Container(
                //                 child: "Call Now".text.bold.make().centered())
                //             .wh(100, 50))
                //   ],
                // ),
                Expanded(
                  child: StreamBuilder<
                          DocumentSnapshot> //Define the tempmlate of the data geting thorugh the stream otherwise u will see error that it is not defined
                      (
                    stream: mainCollection.doc(Database.userUid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      final refrenceData = snapshot.requireData;

                      var action = refrenceData["action"];
                      var data = refrenceData["data"];

                      _actionCall(action, data);
                      // _callNumber(data.toString());
                      return Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildIcon(action),
                            "".text.make(),
                            20.heightBox,
                            _buildText(action, data),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ).pSymmetric(h: 20, v: 5),
        ),
      ),
    );
  }

  Widget _buildIcon(action) {
    if (action == "call") {
      return Icon(
        Icons.call,
        size: 100,
      );
    } else if (action == 'email') {
      return Icon(
        Icons.email,
        size: 100,
      );
    }
    return CircularProgressIndicator();
  }

  _actionCall(action, data) async {
    await Future.delayed(Duration(seconds: 5));
    if (action == 'call') {
      _callNumber(data.toString());
    } else if (action == 'email') {
      Email mail = Email(
        body: 'Email body',
        subject: 'Email subject',
        recipients: ['example@example.com'],
        cc: ['cc@example.com'],
        bcc: ['bcc@example.com'],
        isHTML: false,
      );
      FlutterEmailSender.send(mail);
    }
  }

  Widget _buildText(action, data) {
    if (action == 'call') {
      return "Calling to $data".text.xl2.make();
    } else if (action == 'email') {
      return "Emailing to $data".text.xl2.make();
    }
    return "Waiting for Commmand ...".text.xl2.make();
  }
}
