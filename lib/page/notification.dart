import 'dart:developer';


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
   // OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  }

  void _handleSendNotification() async {
   OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");

    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imUrlString =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNoy-7N8x4HgYJQuQC3i7SW8nj9EaWzrvhRw&usqp=CAU";

    var notification1 = OSCreateNotification(
        //playerID

        playerIds: [   
        //playerId,
        '9556bafc-c68e-4ef2-a469-2a4b61d09168',
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
