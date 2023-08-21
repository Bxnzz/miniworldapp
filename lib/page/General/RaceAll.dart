import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/General/detil_race.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';

class RaceAll extends StatefulWidget {
  const RaceAll({super.key});

  @override
  State<RaceAll> createState() => _RaceAllState();
}

class _RaceAllState extends State<RaceAll> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];
  int idUser = 0;
  bool isLoaded = false;

  late Future<void> loadDataMethod;
  late RaceService raceService;

  var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.races().then((value) {
      log(value.data.first.raceName);
    });
    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Stack(
            children: [
              // Positioned(
              //     child:

              //     SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         borderRadius: const BorderRadius.only(
              //             bottomLeft: Radius.circular(40),
              //             bottomRight: Radius.circular(40)),
              //         gradient: LinearGradient(
              //             begin: FractionalOffset(0.0, 0.0),
              //             end: FractionalOffset(1.0, 0.0),
              //             stops: [0.0, 1.0],
              //             tileMode: TileMode.clamp,
              //             colors: [
              //               Colors.purpleAccent,
              //               Color.fromARGB(255, 144, 64, 255),
              //             ])),
              //   ),
              // )),
              // Positioned(
              //   top: 0,
              //   child: SizedBox(
              //     width: Get.width,
              //     height: Get.height,
              //     child: Container(
              //        decoration:  BoxDecoration(
              //                    color:   Colors.grey[100]
              //                 ),
              //                   ),
              //   ),),
              Column(
                children: <Widget>[
                  // SizedBox(
                  //   width: Get.width - 50,
                  //   height: 85,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20),
                  //         color: Colors.white),
                  //     child: Column(
                  //       children: [
                  //         Text('User'),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 SizedBox(
                  //                     width: 30,
                  //                     height: 30,
                  //                     child:
                  //                         Image.asset("assets/image/crown1.png")),
                  //                 Text('0')
                  //               ],
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.only(top: 30, bottom: 8),
                  //               child: const VerticalDivider(),
                  //             ),
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 SizedBox(
                  //                   width: 30,
                  //                   height: 30,
                  //                   child: Image.asset("assets/image/crown2.png"),
                  //                 ),
                  //                 Text('2')
                  //               ],
                  //             ),
                  //             const VerticalDivider(),
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 SizedBox(
                  //                   width: 30,
                  //                   height: 30,
                  //                   child: Image.asset("assets/image/crown3.png"),
                  //                 ),
                  //                 Text('0')
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: FutureBuilder(
                        future: loadDataMethod,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              //padding: EdgeInsets.only(top: 10),
                              children: races.map((element) {
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
                                      borderRadius: BorderRadius.circular(12.0),
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailRace()));
                                        context.read<AppData>().idrace =
                                            element.raceId;
                                      },
                                      child: GridTile(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          child: Image.network(
                                              element.raceImage,
                                              //  width: Get.width,
                                              //  height: Get.width*0.5625/2,
                                              fit: BoxFit.cover),
                                          footer: Container(
                                            color: Get
                                                .theme.colorScheme.onBackground
                                                .withOpacity(0.5),
                                            padding: const EdgeInsets.fromLTRB(
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
                                                    Text(element.raceName,
                                                        style: Get.textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Get
                                                                    .theme
                                                                    .colorScheme
                                                                    .onPrimary)),
                                                    Text("# ${element.raceId}",
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
                                                        element.raceLocation,
                                                    style: Get
                                                        .textTheme.bodySmall!
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
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Container();
                            // const CircularProgressIndicator();
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await raceService.races();
      races = a.data;
      isLoaded = true;
    } catch (err) {
      isLoaded = false;
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }
}
