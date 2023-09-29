import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/home_join.dart';
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/player_race_start_gps.dart';
import 'package:miniworldapp/page/Player/player_race_start_hint.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PlayerRaceStartMenu extends StatefulWidget {
  const PlayerRaceStartMenu({super.key});

  @override
  State<PlayerRaceStartMenu> createState() => _PlayerRaceStartMenuState();
}

class _PlayerRaceStartMenuState extends State<PlayerRaceStartMenu> {
  int _selectedIndex = 0;
  late PersistentTabController _controller;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int index = 0;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 1);

    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      PlayerRaceStartMis(controller: _controller),
      PlayerRaceStartHint(controller: _controller),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.list_bullet),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.question_circle),
        title: "Settings",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _controller.index = index;
    // });

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    if (_controller.index == 0) {
      setState(() {
        _buildScreens;
      });
    }
    if (_controller.index == 1) {
      setState(() {
        _buildScreens;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        Get.off(() => HomeJoinDetail());
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
                    try {
                      context
                          .read<AppData>()
                          .updateLocationTimerPlayer
                          .cancel();

                      log('Timer Stopped1...');
                    } catch (e) {
                      log('ERRx ' + e.toString());
                    }

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

        body: PersistentTabView(
          onItemSelected: (value) {
            if (value == 0) {
              log("value" + value.toString());
              setState(() {});
            }
            if (value == 1) {
              log("value" + value.toString());
              setState(() {
                _buildScreens();
              });
            }
          },
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 100),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style13, // Choose the nav bar style with this property.
        ),

        // Column(
        //   children: [
        //     // Expanded(
        //     //   child: Center(
        //     //     child: _widgetOptions.elementAt(_selectedIndex),
        //     //   ),
        //     // ),
        //   ],
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.listUl,
        //         size: 20,
        //       ),
        //       label: 'ภารกิจ',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.exclamation,
        //         size: 20,
        //       ),
        //       label: 'ค้นหา',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   //selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }

  // final List<Widget> _widgetOptions = <Widget>[
  //   PlayerRaceStartMis(),
  //   const PlayerRaceStartHint(),
  // ];
}
