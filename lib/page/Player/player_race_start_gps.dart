import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PlayerRaceStartGPS extends StatefulWidget {
  const PlayerRaceStartGPS({super.key});

  @override
  State<PlayerRaceStartGPS> createState() => _PlayerRaceStartGPSState();
}

class _PlayerRaceStartGPSState extends State<PlayerRaceStartGPS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ตำแหน่ง'),
        ],
      ),
    );
  }
}
