import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:card_actions/card_actions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:miniworldapp/page/General/detil_race_host.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';

import 'package:miniworldapp/page/Host/race_edit.dart';

import 'package:miniworldapp/widget/dialog.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../Host/mission_create.dart';

class Home_create extends StatefulWidget {
  const Home_create({super.key});

  @override
  State<Home_create> createState() => _Home_createState();
}

class _Home_createState extends State<Home_create> {
  // 1. กำหนดตัวแปร
  List<Race> race = [];
  int idUser = 0;
  String raceID = '';

  var selectedItem = '';

  late RaceResult raceRe;
  late Future<void> loadDataMethod;
  late RaceService raceService;

  var formatter = DateFormat.yMEd();
  var formatter2 = DateFormat.Hms();
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
                padding: EdgeInsets.only(top: 10),
                children: race.map((element) {
                  //IDrace = element.raceId;
                  final theme = Theme.of(context);
                  final textTheme = theme.textTheme;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Column(
                      children: [
                        Stack(
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
                                          builder: (context) => DetailHost()));
                                  context.read<AppData>().idrace =
                                      element.raceId;
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Image.network(element.raceImage,
                                        width: Get.width,
                                        height: Get.width * 0.5625,
                                        fit: BoxFit.cover),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 15, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ชื่อ: " + element.raceName,
                                                  style: textTheme.displayMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "# ${element.raceId}",
                                                  style: textTheme.displayMedium
                                                      ?.copyWith(
                                                    color: Colors.purple,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(height: 8),
                                            // Text("ปิดรับสมัคร: " +
                                            //     formatter.formatInBuddhistCalendarThai(
                                            //         element.raceTimeFn)),
                                            Text(
                                              "สถานที่: " +
                                                  element.raceLocation,
                                              style:
                                                  textTheme.bodyLarge?.copyWith(
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122),
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  // padding: EdgeInsets.all(8),
                                  // decoration: BoxDecoration(

                                  //     color: Colors.white.withOpacity(0.5),
                                  //     borderRadius: BorderRadius.circular(100)),
                                  child: PopupMenuButton(
                                      onSelected: (result) {
                                        if (result == 0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditRace()));
                                          context.read<AppData>().idrace =
                                              element.raceId;
                                        }
                                        if (result == 1) {
                                          //  Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              title: Center(
                                                  child: Text('ลบการแข่งขัน?')),
                                              content: Text(
                                                  'คุณต้องการจะลบการแข่งขันนี้หรือไม่?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('ยกเลิก',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                                SizedBox(
                                                    width: 120,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent),
                                                        onPressed: () async {
                                                          log('race' +
                                                              element.raceId
                                                                  .toString());
                                                          //  try {
                                                          //
                                                          //  }on DioError catch (e) {
                                                          //    //throw Exception(e);
                                                          //    log(e.response!.data);
                                                          //  }
                                                          var race = await raceService
                                                              .deleteRace(element
                                                                  .raceId
                                                                  .toString());
                                                          log(race.toString());
                                                          raceRe = race.data;
                                                          if (raceRe.result ==
                                                              '1') {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'delete Successful')),
                                                            );
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                            // log("race Successful");
                                                            return;
                                                          } else {
                                                            // log("team fail");
                                                            ScaffoldMessenger
                                                                    .of(context)
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
                                                              color:
                                                                  Colors.white),
                                                        )))
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          _buildPopupMenuEdit(
                                              'แก้ไข', Icons.edit, 0),
                                          _buildPopupMenuDelete(
                                              'ลบ', Icons.delete, 1),
                                        ];
                                      }),
                                )),
                          ],
                        ),
                      ],
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

  PopupMenuItem _buildPopupMenuEdit(
      String menuTitle, IconData iconData, int value) {
    return PopupMenuItem(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => EditRace()));
          // context.read<AppData>().idrace = idraces;
        },
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Icon(iconData), Text(menuTitle)],
        ));
  }

  PopupMenuItem _buildPopupMenuDelete(
      String menuTitle, IconData iconData, int value) {
    return PopupMenuItem(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Icon(iconData), Text(menuTitle)],
        ));
  }
}
