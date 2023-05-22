import 'dart:convert';
import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/Host/race_create.dart';

import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../Player/createTeam.dart';
import 'home_create.dart';

class HomeAll extends StatefulWidget {
  const HomeAll({super.key});

  @override
  State<HomeAll> createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAll> {
  String Username = '';
  @override
  void initState() {
    super.initState();

    Username = context.read<AppData>().Username;
    log(Username);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('หน้าHome'),
        //  actions: <Widget>[Text(Username)],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('ทั้งหมด'),
              ),
              Tab(
                child: Text('ที่สร้าง'),
              ),
              Tab(
                child: Text('ที่เข้าร่วม'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(child: RaceAll()),
            Center(
              child: Home_create(),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RaceCreatePage()));
            },
            child: const Text("สร้างการแข่งขัน"),
          ),
        ),
        drawer: SizedBox(
          width: 200,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                       Username,
                       // style: TextStyle(color: Colors.grey),
                      )
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  const Login(),
                         
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RaceAll extends StatefulWidget {
  const RaceAll({super.key});

  @override
  State<RaceAll> createState() => _RaceAllState();
}

class _RaceAllState extends State<RaceAll> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];

  late Future<void> loadDataMethod;
  late RaceService raceService;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.getRaces().then((value) {
      log(value.data.first.raceName);
    });
    // 2.2 async method
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: races.map((element) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("ชื่อ: ${element.raceName}"),
                            content: SizedBox(
                              height: 95,
                              child: Column(
                                children: [
                                  Text(
                                      'จำนวนทีม: ${element.raceLimitteam.toString()}'),
                                  Text(
                                      'เปิดรับสมัคร: ${formatter.formatInBuddhistCalendarThai(element.raceTimeSt)}'),
                                  Text(
                                      'ปิดรับสมัคร:${formatter.formatInBuddhistCalendarThai(element.raceTimeFn)} '),
                                  Text(
                                      'ปิดรับสมัคร:${formatter.formatInBuddhistCalendarThai(element.eventDatetime)} '),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('ยกเลิก'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CeateTeam()));
                                  context.read<AppData>().idrace =
                                      element.raceId;
                                },
                                child: const Text('ลงทะเบียน'),
                              ),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("ชื่อ: " + element.raceName),
                              Text("ปิดรับสมัคร: " +
                                  formatter.formatInBuddhistCalendarThai(
                                      element.raceTimeFn)),
                              Text("สถานที่: " + element.raceLocation),
                              Text("# " + element.raceId.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> loadData() async {
    try {
      var a = await raceService.getRaces();
      races = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}
