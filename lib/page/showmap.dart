import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowMapPage extends StatefulWidget {
  const ShowMapPage({super.key});

  @override
  State<ShowMapPage> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends  State<ShowMapPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('ShowMap') ,),
    );
  }
}