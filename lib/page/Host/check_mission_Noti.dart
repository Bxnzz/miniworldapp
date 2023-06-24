import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class CheckMisNoti extends StatefulWidget {
  const CheckMisNoti({super.key});

  @override
  State<CheckMisNoti> createState() => _CheckMisNotiState();
}

class _CheckMisNotiState extends State<CheckMisNoti> {
  String McID = '';
  @override
  void initState() {
    super.initState();
 
    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   log('re ${result.notification.additionalData}');
    //   McID =  result.notification.additionalData.toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
    return Scaffold(
      body: Text('mc'+McID),
    );
  }
}
