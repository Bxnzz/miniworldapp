import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';
import '../../service/race.dart';

class HomeJoinDetail extends StatefulWidget {
  const HomeJoinDetail({super.key});

  @override
  State<HomeJoinDetail> createState() => _HomeJoinDetailState();
}

class _HomeJoinDetailState extends State<HomeJoinDetail> {
  var size, height, width;
  List<Race> races = [];
  List<AttendRace> attends = [];
  late int idUser;
  late int idrace;
  late int idat;
  late int teamid;
  String UrlImg = '';
  String Rname = '';
  String team = '';
  String Rlocation = '';
  String raceTimeST = '';
  String raceTimeFN = '';
  String singUpST = '';
  String singUpFN = '';
  String eventDatetime = '';

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;

  var formatter = DateFormat.yMEd();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idUser = context.read<AppData>().idUser;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    log("id User is :$idUser");
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 250,
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                                child: Text('$team ทีม'),
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
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
                        const Divider(),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                                onPressed: () {
                                  context.read<AppData>().idrace = idrace;
                                  context.read<AppData>().idAt = idat;
                                  context.read<AppData>().idTeam = teamid;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Lobby(),
                                      ));
                                },
                                child: Text('เข้าการแข่งขัน')),
                          ),
                        )
                      ]),
                    ))
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<void> loadData() async {
    try {
      // var r = await raceService.racesByID(userID: idUser);
      var a = await attendService.attendByUserID(userID: idUser);
      attends = a.data;
      idrace = a.data.first.team.raceId;
      idat = a.data.first.atId;
      teamid = a.data.first.teamId;

      Rname = a.data.first.team.race.raceName;
      log(Rname);
      Rlocation = a.data.first.team.race.raceLocation;
      team = a.data.first.team.race.raceLimitteam.toString();
      String formattedDate01 =
          DateFormat.Hm().format(a.data.first.team.race.raceTimeSt);
      raceTimeST = formattedDate01;
      String formattedDate02 =
          DateFormat.Hm().format(a.data.first.team.race.raceTimeSt);
      raceTimeFN = formattedDate02;

      var formatter = DateFormat.yMMMMEEEEd();
      var dateFormat01 = formatter
          .formatInBuddhistCalendarThai(a.data.first.team.race.signUpTimeSt);
      var dateFormat02 = formatter
          .formatInBuddhistCalendarThai(a.data.first.team.race.signUpTimeFn);
      var dateFormat03 = formatter
          .formatInBuddhistCalendarThai(a.data.first.team.race.eventDatetime);
      singUpST = dateFormat01;
      singUpFN = dateFormat02;
      eventDatetime = dateFormat03;

      a.data.first.team.race.raceName;
      UrlImg = a.data.first.team.race.raceImage;

      log(UrlImg);
    } catch (err) {
      log('Error:$err');
    }
  }
}