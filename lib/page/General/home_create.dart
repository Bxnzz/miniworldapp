import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/Host/race_edit.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';

class Home_create extends StatefulWidget {
  const Home_create({super.key});

  @override
  State<Home_create> createState() => _Home_createState();
}

class _Home_createState extends State<Home_create> {
  // 1. กำหนดตัวแปร
  List<Race> race = [];
  int idUser = 0;

  late Future<void> loadDataMethod;
  late RaceService raceService;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    idUser = context.read<AppData>().idUser;
    log("id:" + idUser.toString());
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.racesByID(userID: idUser).then((value) {
      log(value.data.first.raceName);
    });

    // 2.2 async method
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaceCreate(),
    );
  }

  RaceCreate() {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: race.map((element) {
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
                            title: Center(
                                child: Text("ชื่อ: ${element.raceName}")),
                            content: SizedBox(
                              height: 95,
                              child: Center(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EditRace()));
                                          context.read<AppData>().idrace =
                                              element.raceId;
                                        },
                                        child: const Text('แก้ไขการแข่งขัน')),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text('ภารกิจ')),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text('ล็อบบี้ผู้สร้าง')),
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('ยกเลิก'),
                              ),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.network(element.raceImage)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ชื่อ: " + element.raceName),
                                  Text("ปิดรับสมัคร: " +
                                      formatter.formatInBuddhistCalendarThai(
                                          element.raceTimeFn)),
                                  Text("สถานที่: " + element.raceLocation),
                                  Text("# " + element.raceId.toString()),
                                ],
                              ),
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
      var a = await raceService.racesByID(userID: idUser);
      race = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}
