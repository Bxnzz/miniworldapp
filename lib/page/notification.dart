import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NontificationPage extends StatefulWidget {
  const NontificationPage({super.key});

  @override
  State<NontificationPage> createState() => _NontificationPageState();
}

class _NontificationPageState extends State<NontificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  }

  void _handleSendNotification() async {
    var deviceState = await OneSignal.shared.getDeviceState();

    //if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState?.userId;

    var imUrlString =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNoy-7N8x4HgYJQuQC3i7SW8nj9EaWzrvhRw&usqp=CAU";

    var notification1 = OSCreateNotification(
        //playerID

        playerIds: [
          'b8742e68-2547-4cca-90a0-d1561a5654cc', //a11
          '65290994-aa27-494c-9622-7ce079857885', //j7
          '037f084d-7ed0-466f-9f5d-012f60789829', //a9
          '2e395e43-98f9-45fb-82d4-dfc3cd90434d', //s13
        ],
        content: "โหลๆๆ",
        heading: "Test Notification❤ :)",
        iosAttachments: {"id1": imUrlString},
        bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);

    var response1 = await OneSignal.shared.postNotification(notification1);
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nontification'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              child: const Text("Send noti"),
              onPressed: () => _handleSendNotification()),
        ],
      ),
    );
  }
}
