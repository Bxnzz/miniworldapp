import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NontificationPage extends StatefulWidget {
  const NontificationPage({super.key});

  @override
  State<NontificationPage> createState() => _NontificationPageState();
}

class _NontificationPageState extends  State<NontificationPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Nontification') ,),
    );
  }
}