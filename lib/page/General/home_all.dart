import 'dart:convert';
import 'dart:developer';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          actions: <Widget>[Text(Username)],
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
            onPressed: () {},
            child: Text("สร้างการแข่งขัน"),
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
    return Container();
  }
}
