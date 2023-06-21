import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HostRaceStart extends StatefulWidget {
  const HostRaceStart({super.key});

  @override
  State<HostRaceStart> createState() => _HostRaceStartState();
}

class _HostRaceStartState extends State<HostRaceStart> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height.sign;
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;
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
              "การแข่งขันกำลังดำเนินการ",
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
