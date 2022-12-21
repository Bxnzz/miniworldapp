import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacebookSherePage extends StatefulWidget {
  const FacebookSherePage({super.key});

  @override
  State<FacebookSherePage> createState() => _FacebookSherePageState();
}

class _FacebookSherePageState extends  State<FacebookSherePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('FacebookShere') ,),
    );
  }
}