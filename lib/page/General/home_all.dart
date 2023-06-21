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

import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';
import '../Player/createTeam.dart';
import '../notification.dart';
import 'home_create.dart';
import 'home_join.dart';

class HomeAll extends StatefulWidget {
  const HomeAll({super.key});

  @override
  State<HomeAll> createState() => _HomeAllState();
}

class _HomeAllState extends State<HomeAll> {
  final transitionType = ContainerTransitionType.fade;
  String Username = '';
  String _text = '';

  @override
  void initState() {
    super.initState();

    Username = context.read<AppData>().Username;
    log(Username);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 3,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          child: const Icon(Icons.add),
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.squarePlus),
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              label: 'สร้างการแข่งขัน',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RaceCreatePage()));
                setState(() {
                  _text = 'สร้างการแข่งขัน';
                });
              },
            ),
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.eye),
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              label: 'เข้าชมการแข่งขัน',
              onPressed: () {
                setState(() {
                  _text = '"เข้าชมการแข่งขัน"';
                });
              },
            ),
            SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.bell),
              foregroundColor: Colors.black,
              backgroundColor: Colors.amber,
              label: 'Noti',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadPage()));
                setState(() {
                  _text = '"Noti"';
                });
              },
            ),
          ],
          closedForegroundColor: Colors.black,
          openForegroundColor: Colors.white,
          closedBackgroundColor: Colors.white,
          openBackgroundColor: Colors.black,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,

          elevation: 0,
          flexibleSpace: Container(
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
          ),
          // backgroundColor: Theme.of(context).colorScheme.primary,
          title: Builder(
            builder: (context) => IconButton(
              icon: FaIcon(FontAwesomeIcons.alignLeft,
                  color: Theme.of(context).colorScheme.onPrimary, size: 18),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          centerTitle: false,
          titleSpacing: 0,
          //  actions: <Widget>[Text(Username)],
          bottom: TabBar(
            labelColor: Get.theme.colorScheme.primary,
            unselectedLabelColor: Get.theme.colorScheme.onPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: const <Widget>[
              Tab(
                child: Text('ทั้งหมด'),
              ),
              Tab(
                child: Text('ที่สร้าง'),
              ),
              Tab(
                child: Text('ที่เข้าร่วม'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: RaceAll()),
            Center(
              child: Home_create(),
            ),
            Center(
              child: Home_join(),
            ),
          ],
        ),
        drawer: SizedBox(
          width: 200,
          child: Drawer(
            backgroundColor: Get.theme.colorScheme.onPrimary,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        Username,
                        // style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.house),
                  title: const Text('หน้าหลัก'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.chartLine),
                  title: const Text('สถิติการแข่งขัน'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.user),
                  title: const Text('แก้ไขโปรไฟล์'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.rightFromBracket),
                  title: const Text('ออกจากระบบ'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.only(top: 10),
                children: races.map((element) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5),
                    child: Card(
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
                                  builder: (context) => DetailRace()));
                          context.read<AppData>().idrace = element.raceId;
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
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(element.raceName,
                                          style: Get.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Get.theme.colorScheme
                                                      .onPrimary)),
                                      Text("# ${element.raceId}",
                                          style: Get.textTheme.bodySmall!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .onPrimary)),
                                    ],
                                  ),
                                  Container(height: 5),
                                  // Text("ปิดรับสมัคร: " +
                                  //     formatter.formatInBuddhistCalendarThai(
                                  //         element.raceTimeFn)),
                                  Text("สถานที่: " + element.raceLocation,
                                      style: Get.textTheme.bodySmall!.copyWith(
                                          color: Get.theme.colorScheme.onPrimary
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
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
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
