import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../page/General/login.dart';


class Darweruser extends StatelessWidget {
  const Darweruser({super.key});
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: SizedBox(
          width: 250,
          child: Drawer(
            backgroundColor: Get.theme.colorScheme.onPrimary,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      // Text(
                      //   Username,
                      //   // style: TextStyle(color: Colors.grey),
                      // )
                    ],
                  ),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.house),
                  title: const Text('หน้าหลัก'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.chartLine),
                  title: const Text('สถิติการแข่งขัน'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.user),
                  title: const Text('แก้ไขโปรไฟล์'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.rightFromBracket),
                  title: const Text('ออกจากระบบ'),
                  onTap: () {
                    Get.to(Login());
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}