import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/player_race_start_gps.dart';
import 'package:miniworldapp/page/Player/player_race_start_hint.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.dart';

class PlayerRaceStartMenu extends StatefulWidget {
  const PlayerRaceStartMenu({super.key});

  @override
  State<PlayerRaceStartMenu> createState() => _PlayerRaceStartMenuState();
}

class _PlayerRaceStartMenuState extends State<PlayerRaceStartMenu> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(Get.width, Get.height),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.circleChevronLeft,
                    color: Colors.yellow,
                    size: 35,
                  ),
                ),
                Text(
                  "การแข่งขัน",
                  style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 20),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.listUl,
                size: 20,
              ),
              label: 'ภารกิจ',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.exclamation,
                size: 20,
              ),
              label: 'ค้นหา',
            ),
          ],
          currentIndex: _selectedIndex,
          //selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const PlayerRaceStartMis(),
    const PlayerRaceStartHint(),
  ];
}
