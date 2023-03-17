import 'package:flutter/material.dart';

class History_create extends StatefulWidget {
  const History_create({super.key});

  @override
  State<History_create> createState() => _History_createState();
}

class _History_createState extends State<History_create> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(
    title: const Text('History'),
    ),
    );
  }
}