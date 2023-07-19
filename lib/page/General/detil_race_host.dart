import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/Host/host_race_start.dart';
import 'package:miniworldapp/page/Player/lobby.dart';

import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../model/result/raceResult.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../Host/check_mission_list.dart';
import '../Host/detil_mission.dart';
import '../Host/race_edit.dart';
import '../Player/createTeam.dart';
import '../showmap.dart';

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
  int idAttend = 0;
  int idTeam = 0;
  String UrlImg = '';
  String Rname = '';
  String team = '';
  String Rlocation = '';
  String raceTimeST = '';
  String raceTimeFN = '';
  String singUpST = '';
  String singUpFN = '';
  String eventDatetime = '';
  int raceStatus = 0;

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late RaceResult raceRe;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);

  @override
  void initState() {
    super.initState();
    idrace = context.read<AppData>().idrace;
    idAttend = context.read<AppData>().idAt;
    idTeam = context.read<AppData>().idTeam;
    idUser = context.read<AppData>().idUser;
    raceStatus = context.read<AppData>().raceStatus;
    log(idrace.toString());
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.racesByraceID(raceID: idrace).then((value) {
      log(value.data.first.raceName);
    });

    log(idUser.toString());
    log("raceStatus is $raceStatus");

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
      raceStatus = a.data.first.raceStatus;
      log("race Statusssss = $raceStatus");
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
                          Container(
                            padding: EdgeInsets.all(8),
                            child: PopupMenuButton(
                                icon: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white),
                                    child: const FaIcon(
                                        FontAwesomeIcons.elementor,
                                        size: 38,
                                        color: Colors.pinkAccent)),
                                onSelected: (result) {
                                  if (result == 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditRace()));
                                    context.read<AppData>().idrace = idrace;
                                  }
                                  if (result == 1) {
                                    //  Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 255, 255),
                                        title: Center(
                                            child: Text('ลบการแข่งขัน?')),
                                        content: Text(
                                            'คุณต้องการจะลบการแข่งขันนี้หรือไม่?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('ยกเลิก',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          SizedBox(
                                              width: 120,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent),
                                                  onPressed: () async {
                                                    log('race' +
                                                        idrace.toString());
                                                    //  try {
                                                    //
                                                    //  }on DioError catch (e) {
                                                    //    //throw Exception(e);
                                                    //    log(e.response!.data);
                                                    //  }
                                                    var race = await raceService
                                                        .deleteRace(
                                                            idrace.toString());
                                                    log(race.toString());
                                                    raceRe = race.data;
                                                    if (raceRe.result == '1') {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'delete Successful')),
                                                      );
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                      // log("race Successful");
                                                      return;
                                                    } else {
                                                      // log("team fail");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'delete fail try agin!')),
                                                      );

                                                      return;
                                                    }
                                                  },
                                                  child: const Text(
                                                    'ลบ',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )))
                                        ],
                                      ),
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    _buildPopupMenuEdit('แก้ไข', Icons.edit, 0),
                                    _buildPopupMenuDelete(
                                        'ลบ', Icons.delete, 1),
                                  ];
                                }),
                          ),
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
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(35)),
                          color: Colors.white,
                        ),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Rname,
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold)),
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
                          ),
                          Center(
                              child: races.first.raceStatus == 1
                                  ? SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Lobby(),
                                                ));
                                            context.read<AppData>().idrace =
                                                idrace;
                                            context.read<AppData>().idUser =
                                                idUser;
                                            context.read<AppData>().idAt =
                                                idAttend;
                                            context.read<AppData>().idTeam =
                                                idTeam;
                                          },
                                          child: Text('เข้าล็อบบี้')),
                                    )
                                  : SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CheckMissionList(),
                                                ));
                                            context.read<AppData>().idrace =
                                                idrace;
                                            context.read<AppData>().idUser =
                                                idUser;
                                            context.read<AppData>().idAt =
                                                idAttend;
                                            context.read<AppData>().idTeam =
                                                idTeam;
                                          },
                                          child:
                                              Text('การแข่งขันกำลังดำเนินการ')),
                                    ))
                        ]),
                      ))
                ],
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          }),
    );
  }

  PopupMenuItem _buildPopupMenuEdit(
      String menuTitle, IconData iconData, int value) {
    return PopupMenuItem(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => EditRace()));
          // context.read<AppData>().idrace = idraces;
        },
        value: value,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    iconData,
                    color: Get.theme.colorScheme.primary,
                  ),
                  Text(
                    menuTitle,
                    style: (Get.textTheme.bodySmall!.copyWith(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Divider(),
              )
            ],
          ),
        ));
  }

  PopupMenuItem _buildPopupMenuDelete(
      String menuTitle, IconData iconData, int value) {
    return PopupMenuItem(
        value: value,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  iconData,
                  color: Get.theme.colorScheme.primary,
                ),
                Text(
                  menuTitle,
                  style: (Get.textTheme.bodySmall!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ],
        ));
  }
}
