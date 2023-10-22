import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:miniworldapp/widget/loadData.dart';

import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../Player/createTeam.dart';

class DetailRace extends StatefulWidget {
  const DetailRace({super.key});

  @override
  State<DetailRace> createState() => _DetailRaceState();
}

class _DetailRaceState extends State<DetailRace> {
  // 1. กำหนดตัวแปร
  var size, height, width;
  List<Race> races = [];
  List<AttendRace> attends = [];
  List<Team> teams = [];
  int idUser = 0;
  int idrace = 0;
  int limitTeam = 0;
  String UrlImg = '';
  String Rname = '';
  int team = 0;
  String Rlocation = '';
  String raceTimeST = '';
  String raceTimeFN = '';
  String singUpST = '';
  String singUpFN = '';
  String eventDatetime = '';
  bool chkLimitTeam = false;

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;
  late TeamService teamService;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);

  @override
  void initState() {
    super.initState();
    idrace = context.read<AppData>().idrace;
    log(idrace.toString());
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.racesByraceID(raceID: idrace).then((value) {
      log(value.data.first.raceName);
    });
    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    try {
      var a = await raceService.racesByraceID(raceID: idrace);
      races = a.data;
      Rname = a.data.first.raceName;
      log(Rname);
      Rlocation = a.data.first.raceLocation;
      team = a.data.first.raceLimitteam;
      String formattedDate01 = DateFormat.Hm().format(a.data.first.raceTimeSt);
      raceTimeST = formattedDate01;
      String formattedDate02 = DateFormat.Hm().format(a.data.first.raceTimeFn);
      raceTimeFN = formattedDate02;
      var formatter = DateFormat.yMMMMEEEEd();
      var dateFormat01 =
          formatter.formatInBuddhistCalendarThai(a.data.first.signUpTimeSt);
      var dateFormat02 =
          formatter.formatInBuddhistCalendarThai(a.data.first.signUpTimeFn);
      var dateFormat03 =
          formatter.formatInBuddhistCalendarThai(a.data.first.eventDatetime);
      singUpST = dateFormat01;
      singUpFN = dateFormat02;
      eventDatetime = dateFormat03;
      log(UrlImg);

      a.data.first.raceName;
      UrlImg = a.data.first.raceImage;

      var b = await teamService.teambyRaceID(raceID: idrace);
      teams = b.data;
      limitTeam = teams.length;
      limitTeam = limitTeam;
      log("limitTeam $limitTeam/$team");

      if (limitTeam >= team) {
        log("race Full");
        chkLimitTeam = true;
      } else {
        log("race Not Full");
        chkLimitTeam = false;
      }
    } catch (err) {
      log('Error:$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 300,
                        child: Image.network(
                          UrlImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 10,
                      right: 5,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.circleChevronLeft,
                                color: Colors.yellow,
                                size: 35,
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            // borderRadius: BorderRadius.circular(100)
                            //   ),
                            //   child: FaIcon(FontAwesomeIcons.arrowLeft),
                            // )
                          ]),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: height / 3.25,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: height / 42.2,
                              right: height / 42.2,
                              //  bottom: 600,
                              top: 0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35)),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Rname,
                                  style: textTheme.bodyText1?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 17),
                                    child: Text(Rlocation),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.peopleGroup,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text('$limitTeam/$team ทีม'),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.solidCalendarPlus,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text(singUpST),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.solidCalendarXmark,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text(singUpFN),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.solidClock,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text(raceTimeST),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCircleXmark,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text(raceTimeFN),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCalendarCheck,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Text(eventDatetime),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: const Divider(),
                            ),
                            chkLimitTeam == false
                                ? Center(
                                    child: SizedBox(
                                    width: 250,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: FilledButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CeateTeam()));
                                                context.read<AppData>().idrace =
                                                    idrace;
                                              },
                                              child: Text('ลงทะเบียน')),
                                        ),
                                        // ElevatedButton(
                                        // onPressed: () {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) => Home()));
                                        //   context.read<AppData>().idrace = idrace;
                                        // },
                                        // child: Text('test')),
                                      ],
                                    ),
                                  ))
                                : SizedBox(
                                  width: 250,
                                  child: FilledButton(
                                      onPressed: null,
                                      child: Text("มีจำนวนทีมเต็มแล้ว")),
                                )
                          ]),
                        ))
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
