import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotMapPage extends StatefulWidget {
  const PhotMapPage({super.key});

  @override
  State<PhotMapPage> createState() => _PhotMapPageState();
}

class _PhotMapPageState extends  State<PhotMapPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('PhotMap') ,),
    );
  }
}