import 'package:flutter/material.dart';

import 'package:miniworldapp/page/facebookLogin.dart';

import 'package:miniworldapp/page/loginpage.dart';
import 'package:miniworldapp/page/notification.dart';

import 'package:miniworldapp/page/register.dart';
import 'package:miniworldapp/page/showmap.dart';
import 'package:miniworldapp/page/uploadImage,video.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';

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
        title: const Text('PAGE'),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FacebookLoginPage()));
            },
            child: const Text('FacebookLogin')),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('Login')),
        ElevatedButton(
            onPressed: () {
              Map<String, dynamic> userData = {
                "name": "",
              };
              context.read<AppData>().userFacebook = userData;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()));
            },
            child: const Text('RegisterPage')),
       
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NontificationPage()));
            },
            child: const Text('Nontification')),
       
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ShowMapPage()));
            },
            child: const Text('ShowMap')),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UploadPage()));
            },
            child: const Text('UploadPage')),
        
      ]),
    );
  }
}
