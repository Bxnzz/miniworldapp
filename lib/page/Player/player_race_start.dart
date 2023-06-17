import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerRaceStart extends StatefulWidget {
  const PlayerRaceStart({super.key});

  @override
  State<PlayerRaceStart> createState() => _PlayerRaceStartState();
}

class _PlayerRaceStartState extends State<PlayerRaceStart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(context);
                });
              },
              icon: FaIcon(
                FontAwesomeIcons.circleChevronLeft,
                color: Colors.yellow,
                size: 35,
              ),
            ),
            Text(
              "ภารกิจ",
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
