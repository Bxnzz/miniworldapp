import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/page/General/home_all.dart';
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
  List<Race> races = [];
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

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
              future: loadDataMethod,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(top: 10),
                    children: attends
                        .where((element) => element.team.race.raceStatus != 4)
                        .map((e) {
                      final theme = Theme.of(context);
                      final textTheme = theme.textTheme;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius:
                                  BorderRadius.circular(20.0), //<-- SEE HERE
                            ),
                            color: Colors.white,
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeJoinDetail()));
                                context.read<AppData>().status = e.status;
                                context.read<AppData>().idUser = e.userId;
                                context.read<AppData>().idTeam = e.teamId;
                                context.read<AppData>().idrace = e.team.raceId;
                                context.read<AppData>().idAt = e.atId;
                                //showDetailDialog(context, e);
                              },
                              child: GridTile(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  child: Image.network(e.team.race.raceImage,
                                      //  width: Get.width,
                                      //  height: Get.width*0.5625/2,
                                      fit: BoxFit.cover),
                                  footer: Container(
                                    color: Get.theme.colorScheme.onBackground
                                        .withOpacity(0.5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                e.team.race.raceName,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis, // new
                                                style: Get.textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimary),
                                              ),
                                            ),
                                            Text("# ${e.team.race.raceId}",
                                                style: Get.textTheme.bodySmall!
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
                                                e.team.race.raceLocation,
                                            style: Get.textTheme.bodySmall!
                                                .copyWith(
                                                    color: Get.theme.colorScheme
                                                        .onPrimary
                                                        .withOpacity(0.8))),
                                        Container(height: 5),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var r = await raceService.races();
      races = r.data;
      var a = await attendService.attendByUserID(userID: idUser);
      attends = a.data;
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }
}
