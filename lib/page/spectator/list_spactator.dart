import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/page/spectator/spectator.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';

class ListSpactator extends StatefulWidget {
  const ListSpactator({super.key});

  @override
  State<ListSpactator> createState() => _ListSpactatorState();
}

class _ListSpactatorState extends State<ListSpactator> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];
  List<AttendRace> teamAttends = [];

  late Future<void> loadDataMethod;
  late RaceService raceService;
  late AttendService attendService;
  List<AttendRace> idUserAttends = [];
  List<AttendRace> teamIdAtt = [];

  Set<int> race_all = {};
  int hostID = 0;
  Set<int> teamMe = {};

  int idUser = 0;

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idUser = context.read<AppData>().idUser;
      log('user ' + idUser.toString());

      var r = await raceService.races();
      races = r.data;
      for (var re in races) {
        if (re.raceStatus == 2) {
          log('race ' + re.raceId.toString());
          race_all.add(re.raceId);
        }
      }

      //  log('status ' + status.toString());

      var t = await attendService.attendByUserID(userID: idUser);
      teamAttends = t.data;
      //  hostID = t.data.first

      for (var tm in teamAttends) {
        log(tm.team.raceId.toString());
        teamMe.add(tm.team.raceId);
      }
      log('race ' + teamMe.toString());

      var a = await attendService.attendsAll();
      // attends = a.data;

      idUserAttends = a.data
          .where((element) => teamMe.contains(element.team.raceId) == false)
          .toList();

      for (var att in idUserAttends) {
        log(att.userId.toString());
        race_all.add(att.team.raceId);
        log('race ' + race_all.toString());
      }
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Center(child: Text('โหมดผู้ชม')),
      // ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(50),
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/image/TOP2.png'),
                                opacity: 0.8,
                                fit: BoxFit.cover,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color.fromARGB(255, 153, 152, 152)
                                      .withOpacity(0.8),
                                  blurRadius: 3.0,
                                  offset: new Offset(0.0, 3.0),
                                ),
                              ],
                            ),
                            width: Get.width,
                            height: 100,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: GridView.count(
                                crossAxisCount: 2,
                                padding: EdgeInsets.only(top: 10),
                                children: races
                                    .where((element) =>
                                        element.raceStatus == 2 &&
                                        element.userId != idUser &&
                                        race_all.contains(element.raceId) &&
                                        teamMe.contains(element.raceId) ==
                                            false)
                                    .map((e) {
                                  return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.5, right: 2.5, bottom: 5),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              20.0), //<-- SEE HERE
                                        ),
                                        //  shadowColor: ,
                                        color: Colors.white,
                                        clipBehavior: Clip.hardEdge,

                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          splashColor:
                                              Colors.blue.withAlpha(30),
                                          onTap: () {
                                            Get.to(Spectator());
                                            context.read<AppData>().idrace =
                                                e.raceId;
                                            log(e.raceId.toString());
                                          },
                                          child: GridTile(
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              child: Image.network(e.raceImage,
                                                  //  width: Get.width,
                                                  //  height: Get.width*0.5625/2,
                                                  fit: BoxFit.cover),
                                              footer: Container(
                                                color: Get.theme.colorScheme
                                                    .onBackground
                                                    .withOpacity(0.5),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              e.raceName,
                                                              softWrap: false,
                                                              maxLines: 1,
                                                              overflow: TextOverflow
                                                                  .ellipsis, // new
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Get
                                                                          .theme
                                                                          .colorScheme
                                                                          .onPrimary)),
                                                        ),
                                                        Text("# ${e.raceId}",
                                                            style: Get.textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    color: Get
                                                                        .theme
                                                                        .colorScheme
                                                                        .onPrimary)),
                                                      ],
                                                    ),
                                                    Container(height: 5),
                                                    // Text("ปิดรับสมัคร: " +
                                                    //     formatter.formatInBuddhistCalendarThai(
                                                    //         element.raceTimeFn)),
                                                    Text(
                                                        "สถานที่: " +
                                                            e.raceLocation,
                                                        style: Get.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Get
                                                                    .theme
                                                                    .colorScheme
                                                                    .onPrimary
                                                                    .withOpacity(
                                                                        0.8))),
                                                    Container(height: 5),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ));
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 63,
                        right: 50,
                        left: 50,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            border: Border.all(color: Colors.white, width: 3),
                            shape: BoxShape.rectangle,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFFe8e8e8),
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5)),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(-2, 0)),
                              BoxShadow(
                                  color: Colors.white, offset: Offset(2, 0))
                            ],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text('โหมดผู้ชม',
                                style: Get.textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.onPrimary)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
