import 'dart:convert';
import 'dart:developer';
//import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/page/General/history_create.dart';
import 'package:miniworldapp/page/General/rank_race.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';

class Static_create extends StatefulWidget {
  const Static_create({super.key});

  @override
  State<Static_create> createState() => _Static_createState();
}

class _Static_createState extends State<Static_create> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];

  late Future<void> loadDataMethod;
  late RaceService raceService;
  int idUser = 0;

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idUser = context.read<AppData>().idUser;
      log('user ' + idUser.toString());
      var r = await raceService.racesByUserID(userID: idUser);
      races = r.data;

      var status = r.data.where((element) => element.raceStatus == 4);
      log('status ' + status.toString());
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
                colors: [
                  Colors.purpleAccent,
                  Color.fromARGB(255, 144, 64, 255),
                ])),
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.only(top: 10),
                  children: races.map((element) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 2.5, right: 2.5, bottom: 5),
                      child: element.raceStatus == 4
                          ? Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20.0), //<-- SEE HERE
                              ),
                              //  shadowColor: ,
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,

                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.0),
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RankRace()));
                                  context.read<AppData>().idrace =
                                      element.raceId;
                                },
                                child: GridTile(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    child: Image.network(element.raceImage,
                                        //  width: Get.width,
                                        //  height: Get.width*0.5625/2,
                                        fit: BoxFit.cover),
                                    footer: Container(
                                      color: Get.theme.colorScheme.onBackground
                                          .withOpacity(0.5),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(element.raceName,
                                                  style: Get
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onPrimary)),
                                              Text("# ${element.raceId}",
                                                  style: Get
                                                      .textTheme.bodySmall!
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
                                                  element.raceLocation,
                                              style: Get.textTheme.bodySmall!
                                                  .copyWith(
                                                      color: Get.theme
                                                          .colorScheme.onPrimary
                                                          .withOpacity(0.8))),
                                          Container(height: 5),
                                        ],
                                      ),
                                    )),
                              ),
                            )
                          : Container(),
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
