import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends  State<FacebookLoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('FacebookLogin') ,),
    );
  }
}