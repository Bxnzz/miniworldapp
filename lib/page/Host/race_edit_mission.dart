import 'package:flutter/material.dart';

class DetailMission extends StatefulWidget {
  const DetailMission({super.key});

  @override
  State<DetailMission> createState() => _DetailMissionState();
}

class _DetailMissionState extends State<DetailMission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดภารกิจ'),
      ),
    );
  }
}