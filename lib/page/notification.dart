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

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId;

    var imUrlString =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNoy-7N8x4HgYJQuQC3i7SW8nj9EaWzrvhRw&usqp=CAU";
    // var notification = OSCreateNotification(
    //     //playerID
    //     //A9
    //     playerIds: ['037f084d-7ed0-466f-9f5d-012f60789829'],
    //     content: "Miniworld race nofi",
    //     heading: "Test Notification :)",
    //     iosAttachments: {"id1": imUrlString},
    //     bigPicture: imUrlString,
    //     buttons: [
    //       OSActionButton(text: "test1", id: "id1"),
    //       OSActionButton(text: "test2", id: "id2")
    //     ]);

    var notification1 = OSCreateNotification(
        //playerID
        //A51
        playerIds: [playerId.toString()], //(SelectPlayerID Ondevice connect)
        // playerIds: [
        //   'b8742e68-2547-4cca-90a0-d1561a5654cc',
        //   '037f084d-7ed0-466f-9f5d-012f60789829'
        // ],
        content: "Test Notify Mn-race",
        heading: "Test Notification❤ :)",
        iosAttachments: {"id1": imUrlString},
        bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);
    // var notification2 = OSCreateNotification(
    //     //playerID
    //     //oppo
    //     playerIds: ['10a93fb7-f7e2-4a43-bdde-2ed3f752799e'],
    //     content: "ได้เวลาสนุกแล้วสิ321 :) ",
    //     heading: "Test Notification :)",
    //     iosAttachments: {"id1": imUrlString},
    //     bigPicture: imUrlString,
    //     buttons: [
    //       OSActionButton(text: "ตกลง", id: "id1"),
    //       OSActionButton(text: "ยกเลิก", id: "id2")
    //     ]);

    //var response = await OneSignal.shared.postNotification(notification);
    var response1 = await OneSignal.shared.postNotification(notification1);
    //var response2 = await OneSignal.shared.postNotification(notification2);
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");

    return Scaffold(
      appBar: AppBar(
        title: Text('Nontification'),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
                child: Text("Send noti"),
                onPressed: () => _handleSendNotification()),
          ],
        ),
      ),
    );
  }
}
