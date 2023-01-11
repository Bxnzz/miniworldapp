import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nontification'),
      ),
      body: const Center(child: Text("OneSignal Pushnotification")),
    );
  }
}
