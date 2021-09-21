import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> permissionWidget(context) async {
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
                content: Text('This app needs gps access to locate your phone'),
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
      return true;
    }
  }
  return false;
}
