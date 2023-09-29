import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class testpage extends StatefulWidget {
  const testpage({super.key});

  @override
  State<testpage> createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: ListView(
          reverse: true,
          children: [
            Stack(children: [
              Column(
                children: [
                  TextFormField(),
                ],
              )
            ])
          ],
        ));
  }
}
