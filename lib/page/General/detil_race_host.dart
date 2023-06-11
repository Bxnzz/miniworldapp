import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../Host/detil_mission.dart';
import '../Player/createTeam.dart';

class DetailHost extends StatefulWidget {
  const DetailHost({super.key});

  @override
  State<DetailHost> createState() => _DetailHostState();
}

class _DetailHostState extends State<DetailHost> {
  // 1. กำหนดตัวแปร
  var size, height, width;
  List<Race> races = [];
  int idUser = 0;
  int idrace = 0;
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
      team = a.data.first.raceLimitteam.toString();
      String formattedDate01 = DateFormat.Hm().format(a.data.first.raceTimeSt);
      raceTimeST = formattedDate01;
      String formattedDate02 = DateFormat.Hm().format(a.data.first.raceTimeSt);
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

      a.data.first.raceName;
      UrlImg = a.data.first.raceImage;

      log(UrlImg);
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
      body: FutureBuilder(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DetailMission()));
                                      context.read<AppData>().idrace = idrace;
                                    },
                                    child: Text('ภารกิจทั้งหมด')),
                            ),
                          )
                        ]),
                      ))
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
