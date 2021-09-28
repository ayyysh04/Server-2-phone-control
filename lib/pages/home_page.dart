import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_contact/contacts.dart';
// import 'package:flutter_contact/flutter_contact.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp_to_phonecall/utils/database.dart';
import 'package:whatsapp_to_phonecall/utils/firebase_auth.dart';
import 'package:whatsapp_to_phonecall/utils/routes.dart';
import 'package:whatsapp_to_phonecall/widget/snackbar.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker _picker;
  XFile? ximage;
  String? imagelink;
  File? image;
  Database firebaseData = Database();
  late PageController _pageController;
  String? phNumber;
  late TextEditingController _userNameController;
  late FocusNode _userNameNode;

  @override
  void initState() {
    _userNameController = TextEditingController(text: UserData.displayName);
    _getUserProfileData();
    _picker = ImagePicker();
    _pageController = PageController(initialPage: 0, keepPage: true);

    _userNameNode = FocusNode();
    super.initState();
  }

  _getUserProfileData() async {
    DocumentSnapshot userDataSnapshot =
        await mainCollection.doc(UserData.user!.uid).get();
    if (userDataSnapshot["DisplayName"] != null) {
      print(userDataSnapshot["DisplayName"]);

      UserData.displayName = userDataSnapshot["DisplayName"];
    }
    UserData.displayPhotoLink = userDataSnapshot["DisplayPhotoLink"];

    //downloading file
    if (UserData.displayPhotoLink != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File downloadToFile = File('${appDocDir.path}/profilePhoto.png');

      try {
        await FirebaseStorage.instance
            .ref(UserData.displayPhotoLink)
            .writeToFile(downloadToFile);
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _userNameController.dispose();
    _userNameNode.dispose();
    super.dispose();
  }

  _callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != null && res == true) {
      print("done");
    } else
      print("Not done");
  }

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _showExitPopup(context),
        child: GestureDetector(
          onTap: () {
            _userNameNode.unfocus();
          },
          child: Scaffold(
              backgroundColor: Vx.white,
              body: PageView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPageIndex = value;
                  });
                },
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "ServeRemote"
                                    .text
                                    .xl5
                                    .fontFamily(
                                        GoogleFonts.poppins().fontFamily!)
                                    .bold
                                    .make(),
                                "Control phone with server"
                                    .text
                                    .xl
                                    .fontFamily(
                                        GoogleFonts.poppins().fontFamily!)
                                    .bold
                                    .make()
                              ],
                            )
                          ],
                        ),
                        20.heightBox,
                        Expanded(
                          child: StreamBuilder<
                                  DocumentSnapshot> //Define the tempmlate of the data geting thorugh the stream otherwise u will see error that it is not defined
                              (
                            stream: mainCollection
                                .doc(Database.userUid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return "Loading....".text.xl3.make().centered();
                              }

                              final refrenceData = snapshot.requireData;

                              var action = refrenceData["action"];
                              var data = refrenceData["data"];
                              var sumbit = refrenceData["sumbit"];
                              _actionResponse(action, data);

                              _actionCall(action, data, context, sumbit);

                              return Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildIcon(action),
                                    20.heightBox,
                                    _buildText(action, data, sumbit),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ).pSymmetric(h: 20, v: 5),
                  _profilePage(context)
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentPageIndex,
                selectedItemColor: Colors.amber[800],
                onTap: (val) {
                  setState(() {
                    _currentPageIndex = val;
                    _pageController.animateToPage(val,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.home, size: 30),
                      icon: Icon(Icons.home_outlined, size: 30),
                      label: "Home",
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                    activeIcon: Icon(FontAwesomeIcons.userAlt, size: 30),
                    icon: Icon(
                      FontAwesomeIcons.user,
                      size: 30,
                    ),
                    label: "User profile",
                  ),
                ],
              )),
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
    } else if (action == 'new contact') {
      return Icon(
        Icons.contact_phone,
        size: 100,
      );
    } else if (action == 'view contacts') {
      return Icon(
        CupertinoIcons.eye,
        size: 100,
      );
    } else if (action == 'show location') {
      return Icon(
        CupertinoIcons.location,
        size: 100,
      );
    } else if (action == 'battery status') {
      return Icon(
        CupertinoIcons.battery_charging,
        size: 100,
      );
    }
    return CircularProgressIndicator();
  }

  _actionCall(action, data, context, sumbit) async {
    await Future.delayed(Duration(seconds: 3));
    if (action == 'call' && data != null && sumbit == true) {
      _callNumber(data.toString());
      CustomSnackBar(context, "Successfully called $data".text.make());
    } else if (action == 'email' && data != null && sumbit == true) {
      String body = data["body"];
      String subject = data["subject"];
      List<String> recipients = data["recipients"]
          .cast<String>(); //converts dynamic list to string list
      List<String> cc = data["cc"].cast<String>();

      List<String> bcc = data["bcc"].cast<String>();
      Email mail = Email(
        body: body,
        subject: subject,
        recipients: recipients,
        cc: cc,
        bcc: bcc,
        isHTML: false,
      );
      CustomSnackBar(context, "Email has been sent".text.make());
      await FlutterEmailSender.send(mail);
    } else if (action == 'new contact' && sumbit == true) {
      String firstName = data["First name"];
      String lastName = data["Last name"];
      String number = data["Number"];
      Contact newContact = Contact(
          givenName: firstName,
          familyName: lastName,
          phones: [Item(label: 'mobile', value: number)]);
      await ContactsService.addContact(newContact);
      CustomSnackBar(context, "New contact has been created".text.make());
    } else if (action == "view contacts" && data != null && sumbit == true) {
      Iterable<Contact> iterContact = await ContactsService.getContacts(
        query: data["search"],
        withThumbnails: false,
      );
      List<Contact> listContact = iterContact.toList();
      List<Map> mapContact = [];
      for (var contact in listContact) {
        mapContact.add(contact.toMapMod(contact));
      }
      await Database.update(data: {"result": mapContact});
      //
    } else if (action == "show location" && data != null) {
      Location gpsLoc = Location();

      LocationData gpsData = await gpsLoc.getLocation();
      Map gpsMap = {
        'latitude': gpsData.latitude,
        'longitude': gpsData.longitude,
        'accuracy': gpsData.accuracy,
        'verticalAccuracy': gpsData.verticalAccuracy,
        'altitude': gpsData.altitude,
        'speed': gpsData.speed,
        'speedAccuracy': gpsData.speedAccuracy,
        'heading': gpsData.heading,
        'time': gpsData.time,
        'isMock': gpsData.isMock,
        'headingAccuracy': gpsData.headingAccuracy,
        'elapsedRealtimeNanos': gpsData.elapsedRealtimeNanos,
        'elapsedRealtimeUncertaintyNanos':
            gpsData.elapsedRealtimeUncertaintyNanos,
        'satelliteNumber': gpsData.satelliteNumber,
        'provider': gpsData.provider,
      };

      await Database.update(data: {
        "data": gpsMap,
      });
    } else if (action == 'battery status') {
      var battery = Battery();
      int batteryStatus = await battery.batteryLevel;
      await Database.update(data: {
        "data": {"battery %": batteryStatus}
      });
    }
    if (sumbit == true) {
      await FirebaseFirestore.instance.waitForPendingWrites();
      await Database.update(data: {
        "action": null,
        "data": null,
        "sumbit": false
      }); //resets ths data after execution
    }
  }

  Widget _buildText(action, data, sumbit) {
    List<Widget> widgetData = [];

    if (action != null) {
      if (action == 'call' && data != null) {
        if (sumbit == false)
          widgetData.add("Enter phone num data in server".text.xl2.make());
        else
          widgetData.add("Calling to $data".text.xl2.make());
      } else if (action == 'email' && data != null) {
        if (sumbit == false)
          widgetData.add("Enter Email data in server".text.xl2.make());
        else {
          List<String> recipients = data["recipients"].cast<String>();
          String recipientsString =
              recipients.reduce((value, element) => value + "\n" + element);
          widgetData
              .add("Sending Email to : \n $recipientsString ".text.xl2.make());
        }
      } else if (action == 'new contact' && data != null) {
        String number = data["Number"];
        widgetData.add("Creating $number in contacts ".text.xl2.make());
      } else if (action == 'view contacts' && data != null) {
        if (sumbit == false)
          widgetData.add("Sumbit to fetch contact data".text.xl2.make());
        else
          widgetData.add("Sending contacts to server".text.xl2.make());
      } else if (action == "show location" && data != null) {
        if (sumbit == false)
          widgetData.add("Streaming live location to server".text.xl2.make());
        else
          widgetData
              .add("Sumbit to stop streaming the GPS data".text.xl2.make());
      } else if (action == "battery status" && data != null) {
        widgetData.add("Battery status opened".text.xl2.make());
      }

      if (sumbit == false)
        widgetData.addAll([10.heightBox, LinearProgressIndicator()]);
    } else
      widgetData.add("Waiting for Commmand ...".text.xl2.make());

    return Column(
      children: widgetData,
    );
  }

  Future<void> _actionResponse(action, data) async {
    if (data == null) {
      if (action == "call") {
        Database.update(data: {
          "data": "Enter the No. to dial"
        }); //make a call to create a Enter a phone detail
      } else if (action == "email") {
        await Database.update(data: {
          "data": {
            "body": "Enter body",
            "subject": 'Enter Subject',
            "recipients": ["Enter senders/recipients address"],
            "cc": ['Enter cc'],
            "bcc": ['Enter bcc'],
          }
        });
      } else if (action == "new contact") {
        await Database.update(data: {
          "data": {
            "First name": "Enter first name",
            "Last name": 'Enter Last name',
            "Number": "Enter number",
          }
        });
      } else if (action == 'view contacts') {
        await Database.update(data: {
          "data": {"search": "fetching data"}
        });
      } else if (action == 'show location') {
        await Database.update(data: {
          "data": "getting  data",
        });
      } else if (action == 'battery status') {
        await Database.update(data: {
          "data": "getting  batter status",
        });
      }
    }
  }

  Future<bool> _showExitPopup(context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App ?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 13)),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 13)),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _profilePage(BuildContext context) {
    var profileInfo = Expanded(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(top: 30),
            child: Stack(
              children: <Widget>[
                image == null
                    ? Container(
                        clipBehavior: Clip.antiAlias,
                        child: Icon(
                          LineAwesomeIcons.user_plus,
                          size: 50,
                        ).centered(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF3F7FB),
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image!),
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Vx.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      // heightFactor: 10 * 1.5,
                      // widthFactor: 10 * 1.5,
                      child: GestureDetector(
                        onTap: () async {
                          ximage = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (ximage != null) {
                            image = File(ximage!.path);

                            FirebaseStorage _storage = FirebaseStorage.instance;
                            String profileLink =
                                '${UserData.user!.uid}/profileImage.jpg';
                            Reference _storageRef =
                                _storage.ref().child(profileLink);
                            final UploadTask task = _storageRef.putFile(image!);
                            Database.update(
                                data: {"DisplayPhotoLink": profileLink});
                            setState(() {});
                          }
                        },
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: Vx.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          TextField(
            focusNode: _userNameNode,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            controller: _userNameController,
            onSubmitted: (value) {
              Database.update(data: {"DisplayName": value});
            },
          ),
          // Text(
          //   UserData.displayName,
          //   style: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // SizedBox(height: 5),
          Text(
            UserData.user!.email!,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        Icon(
          LineAwesomeIcons.arrow_left,
          size: 30,
        ),
        profileInfo,
        SizedBox(width: 50),
      ],
    );

    return Scaffold(
      backgroundColor: Vx.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 40),
          header,
          Expanded(
            child: ListView(
              children: <Widget>[
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.user_shield,
                    title: 'Privacy',
                    disible: true),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.question_circle,
                    title: 'Help & Support',
                    disible: true),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.cog,
                    title: 'Settings',
                    disible: true),
                _profileListItems(
                    context: context,
                    icon: LineAwesomeIcons.user_shield,
                    title: 'Privacy',
                    disible: true),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuthData.logOut();

                    Navigator.pushReplacementNamed(
                        context, MyRoutes.loginRoute);
                  },
                  child: _profileListItems(
                      context: context,
                      icon: LineAwesomeIcons.alternate_sign_out,
                      title: 'Logout',
                      disible: false),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _profileListItems(
      {required BuildContext context,
      required String title,
      required IconData icon,
      required bool disible}) {
    return Container(
      height: 65,
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFFF3F7FB),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (disible == false)
            Icon(
              LineAwesomeIcons.angle_right,
              size: 25,
            ),
        ],
      ),
    );
  }
}
