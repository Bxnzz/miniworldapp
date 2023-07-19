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
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/widget/loadData.dart';
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
                  final theme = Theme.of(context);
                  final textTheme = theme.textTheme;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeJoinDetail()));
                              context.read<AppData>().idUser = e.userId;
                              context.read<AppData>().idTeam = e.teamId;
                              context.read<AppData>().idrace = e.team.raceId;
                              context.read<AppData>().idAt = e.atId;
                              //showDetailDialog(context, e);
                            },
                            child: Column(
                              children: <Widget>[
                                Image.network(e.team.race.raceImage,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ชื่อ: " + e.team.race.raceName,
                                            style: textTheme.displayMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.purple,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "# ${e.team.race.raceId}",
                                            style: textTheme.displayMedium
                                                ?.copyWith(
                                              color: Colors.purple,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "สถานที่: " + e.team.race.raceLocation,
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: Color.fromARGB(
                                              255, 122, 122, 122),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "วันจัดการแข่งขัน: " +
                                            formatter
                                                .formatInBuddhistCalendarThai(
                                              e.team.race.eventDatetime,
                                            ),
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: Color.fromARGB(
                                              255, 122, 122, 122),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Gap(25)
                                      // Text("สถานที่: " + e.raceLocation),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              return Container();
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
              height: 180,
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
                  Text('ชื่อทีม ${e.team.teamName}'),
                  const Gap(25),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent),
                      onPressed: () {
                        context.read<AppData>().idrace = e.team.raceId;
                        context.read<AppData>().idAt = e.atId;
                        context.read<AppData>().idTeam = e.teamId;
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
    startLoading(context);
    try {
      // var r = await raceService.racesByID(userID: idUser);
      var a = await attendService.attendByUserID(userID: idUser);
      attends = a.data;
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }
}
