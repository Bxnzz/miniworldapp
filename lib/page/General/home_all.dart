import 'dart:convert';
import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/General/detil_race.dart';

import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/Host/race_create.dart';
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/page/Host/start_list_mission.dart';
import 'package:miniworldapp/page/uploadImage,video.dart';
import 'package:miniworldapp/page/uploadImage,video.dart';

import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/darwer.dart';
import '../../widget/loadData.dart';

import '../Player/createTeam.dart';
import '../notification.dart';
import 'home_create.dart';
import 'home_join.dart';



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        
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
                return ListView(
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                      
                          //  IconButton(onPressed: (){
                          //   Darweruser();
                          //  }, icon: Container(
                          //    decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(100),
                          //               color: Colors.white),
                          //    child: FaIcon(
                          //                 FontAwesomeIcons.elementor,
                          //                 size: 38,
                          //                 color: Colors.pinkAccent),
                          //  )) 
                          ],
                        )
                      ],
                    ),
                    new SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: Get.height,
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.only(top: 10),
                        children: races.map((element) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 2.5, right: 2.5, bottom: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 5,
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
                                    child: Image.network(element.raceImage,
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
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onPrimary
                                                          .withOpacity(0.8))),
                                          Container(height: 5),
                                          //  Row(
                                          //    mainAxisAlignment: MainAxisAlignment.end,
                                          //    children: [
                                          //      ElevatedButton(
                                          //        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                                          //          onPressed: () {
                                          //               Navigator.push(
                                          //    context,
                                          //    MaterialPageRoute(
                                          //        builder: (context) => DetailRace()));
                                          //         context.read<AppData>().idrace =
                                          //    element.raceId;
                                          //          },
                                          //          child:  Text('รายละเอียด',style: TextStyle(color: Colors.white),)),
                                          //    ],
                                          //  ),
                      
                                          // Text("# " + element.raceId.toString()),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
                // const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Paddingtop() {
    return Padding(padding: EdgeInsets.only(bottom: 8));
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
