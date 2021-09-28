// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:whatsapp_to_phonecall/utils/dialog_button.dart';

// dialogWidget(BuildContext context, bool isverifing, bool verified) {
//   showGeneralDialog(
//       context: context,
//       pageBuilder: (BuildContext buildContext, Animation animation,
//           Animation secondaryAnimation) {
//         return StatefulBuilder(
//           builder: (BuildContext context, setStateBuild) {
//             return _buildDialog(context, isverifing, verified);
//           },
//         );
//       });
// }

// _closeButton(context) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
//     child: GestureDetector(
//       onTap: () {},
//       child: Container(
//         alignment: FractionalOffset.topRight,
//         child: GestureDetector(
//           child: Icon(
//             Icons.clear,
//             color: Colors.red,
//             size: 15,
//           ),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     ),
//   );
// }

// _colButtons(
//   context,
//   bool isverifing,
// ) {
//   return [
//     Visibility(
//       visible: !isverifing,
//       child: DialogButton(
//         child: Text(
//           "Verify",
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//         onPressed: () {
//           setStateBuild(() {
//             _isverifing = true;
//           });
//         },
//         color: Color.fromRGBO(0, 179, 134, 1.0),
//       ),
//     ),
//     DialogButton(
//       child: Text(
//         "Cancel",
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//       onPressed: () {},
//       color: Color.fromRGBO(251, 80, 80, 1),
//     )
//   ];
// }

// Widget _buildDialog(context, bool isverifing, bool verified) {
//   return AlertDialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//       ),
//       insetPadding: EdgeInsets.all(8),
//       elevation: 10,
//       titlePadding: const EdgeInsets.all(0.0),
//       title: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _closeButton(context),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.warning_amber_sharp,
//                       size: 48,
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     isverifing
//                         ? Container(
//                             child: CircularProgressIndicator(),
//                             width: 50,
//                             height: 50,
//                           )
//                         : verified
//                             ? Icon(
//                                 Icons.done,
//                                 size: 100,
//                                 color: Colors.green,
//                               )
//                             : Icon(
//                                 Icons.close,
//                                 size: 100,
//                                 color: Vx.red900,
//                               ),
//                     isverifing
//                         ? "Verifying".text.make().py(10)
//                         : verified
//                             ? "You are verifed!\nLogin to continue"
//                                 .text
//                                 .make()
//                                 .py(10)
//                             : "Click verify to continue".text.make().py(10),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "Email verification required !",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       contentPadding: EdgeInsets.all(8),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: _colButtons(context),
//       ));
// }
