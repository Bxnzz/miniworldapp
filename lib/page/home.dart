

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/page/chat.dart';
import 'package:miniworldapp/page/facebookLogin.dart';
import 'package:miniworldapp/page/fecebook%20share.dart';
import 'package:miniworldapp/page/loginpage.dart';
import 'package:miniworldapp/page/notification.dart';
import 'package:miniworldapp/page/photMap(realTime).dart';
import 'package:miniworldapp/page/shopmap.dart';
import 'package:miniworldapp/page/uploadImage,video.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOMEPAGE'),),
        body: Column(children: [
           ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FacebookLoginPage()));
            },
             child: Text('FacebookLogin')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
             child: Text('Login')),

             ElevatedButton(onPressed: () {
            //  Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => RegisterPage()));
            },
             child: Text('RegisterPage')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FacebookSherePage()));
            },
             child: Text('FacebookShere')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NontificationPage()));
            },
             child: Text('Nontification')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PhotMapPage()));
            },
             child: Text('photMap')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowMapPage()));
            },
             child: Text('ShowMap')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadPage()));
            },
             child: Text('UploadPage')),

             ElevatedButton(onPressed: () {
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatPage()));
            },
             child: Text('ChatPage')),
            
        ]),
        
    );
  }
}