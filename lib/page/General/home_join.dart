import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';

class Home_join extends StatefulWidget {
  const Home_join({super.key});

  @override
  State<Home_join> createState() => _Home_joinState();
}

class _Home_joinState extends State<Home_join> {
  //variable etc.
  late int idUser;
  List<AttendRace> attends = [];
  final f = new DateFormat('Hm');
  late AttendService attendService;
  late RaceService raceService;

  late Future<void> loadDataMethod;

  var formatter = DateFormat.yMEd();
  @override
  void initState() {
    super.initState();
    idUser = context.read<AppData>().idUser;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    log("id:$idUser");
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
                children: attends.map((e) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          splashColor: Colors.blue.withAlpha(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Image.network(e.team.race.raceImage)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("ชื่อ: " + e.team.race.raceName),
                                      Text(
                                          'สถานที่ : ${e.team.race.raceLocation}'),
                                      Text("วันจัดการแข่งขัน: " +
                                          formatter
                                              .formatInBuddhistCalendarThai(
                                                  e.team.race.eventDatetime)),
                                      // Text("สถานที่: " + e.raceLocation),
                                      Text("# " + e.team.raceId.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            showDetailDialog(context, e);
                          }),
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

  void showDetailDialog(BuildContext context, AttendRace e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('รายละเอียด'),
            content: SizedBox(
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ชื่อ        ${e.team.race.raceName}',
                  ),
                  Text(
                    'เริ่ม       ${'${f.format(e.team.race.raceTimeSt)}  ${formatter.formatInBuddhistCalendarThai(e.team.race.raceTimeSt)}'}',
                  ),
                  Text(
                      'สิ้นสุด   ${'${f.format(e.team.race.raceTimeFn)}  ${formatter.formatInBuddhistCalendarThai(e.team.race.raceTimeFn)}'}'),
                  Text('สถานที่ ${e.team.race.raceLocation}'),
                  const Gap(25),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Lobby(),
                            ));
                      },
                      child: const Text('เข้าการแข่งขัน',
                          style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
          );
        });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Row(
          children: [],
        );
      },
    );
  }

  Future<void> loadData() async {
    try {
      // var r = await raceService.racesByID(userID: idUser);
      var a = await attendService.attendByUserID(userID: idUser);
      attends = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}
