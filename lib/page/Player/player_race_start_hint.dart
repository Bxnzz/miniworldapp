import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PlayerRaceStartHint extends StatefulWidget {
  const PlayerRaceStartHint({super.key});

  @override
  State<PlayerRaceStartHint> createState() => _PlayerRaceStartHintState();
}

class _PlayerRaceStartHintState extends State<PlayerRaceStartHint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('ค้นหา'),
        ],
      ),
    );
  }
}
