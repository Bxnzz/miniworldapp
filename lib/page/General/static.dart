import 'package:flutter/material.dart';
import 'package:miniworldapp/page/General/static_create.dart';
import 'package:miniworldapp/page/General/static_join.dart';


class Static extends StatefulWidget {
  const Static({super.key});

  @override
  State<Static> createState() => _StaticState();
}

class _StaticState extends State<Static> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(appBar: AppBar
      (title: const Text('สถิติการแข่งขัน'),
      bottom: const TabBar(
      tabs: <Widget>[
       Tab(
        text:  "ที่สร้าง"
      ),
      Tab(
        text: 'ที่เข้าร่วม',
      )
      ]),
      ),
      body: const TabBarView(children: <Widget>[
        Center(
          child: Static_create(),
        ),
        Center(
          child: Static_join(),
        )
      ]),
      ));
      
      
  }
}
