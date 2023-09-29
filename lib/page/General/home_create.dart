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
import 'package:miniworldapp/page/General/home_join.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';

import 'package:miniworldapp/page/Host/race_edit.dart';

import 'package:miniworldapp/widget/dialog.dart';
import 'package:miniworldapp/widget/loadData.dart';
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
    raceService.racesByUserID(userID: idUser).then((value) {
      log(value.data.first.raceName);
    });

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
    return Container(
      child: RaceCreate(),
    );
  }

  RaceCreate() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.only(top: 10),
                  children: race.where((e) => e.raceStatus != 4).map((element) {
                    //IDrace = element.raceId;
                    final theme = Theme.of(context);
                    final textTheme = theme.textTheme;
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 2.5, right: 2.5, bottom: 5),
                      //child: Stack(
                      //  children: [
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
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
                                    builder: (context) => DetailHost()));
                            context.read<AppData>().idrace = element.raceId;
                          },
                          child: GridTile(
                            // crossAxisAlignment: CrossAxisAlignment.start,

                            child: Image.network(element.raceImage,
                                // width: Get.width,
                                // height: Get.width * 0.5625,
                                fit: BoxFit.cover),
                            footer: Container(
                                color: Get.theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(element.raceName,
                                             softWrap: false,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis, // new
                                              style: Get.textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Get.theme.colorScheme
                                                          .onPrimary)),
                                        ),
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
                                    Text("สถานที่: ${element.raceLocation}",
                                        style: Get.textTheme.bodySmall!
                                            .copyWith(
                                                color: Get
                                                    .theme.colorScheme.onPrimary
                                                    .withOpacity(0.8))),
                                    Container(height: 5),
                                  ],
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
    );
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await raceService.racesByUserID(userID: idUser);
      race = a.data;
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
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

class TabbarRace extends StatefulWidget {
  const TabbarRace({super.key});

  @override
  State<TabbarRace> createState() => _TabbarRaceState();
}

class _TabbarRaceState extends State<TabbarRace>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 130, //30 for bottom
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  // bottom: 150, // to shift little up
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                            colors: [
                              Color.fromARGB(255, 207, 107, 244),
                              Color.fromARGB(255, 152, 90, 238),
                            ])),
                    width: Get.width,
                    height: 100,
                  ),
                ),
                Positioned(
                    bottom: 10,
                    left: 25,
                    right: 25,
                    child: SizedBox(
                      height: 45,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFe8e8e8),
                                blurRadius: 5.0,
                                offset: Offset(0, 5)),
                            BoxShadow(
                                color: Colors.white, offset: Offset(-5, 0)),
                            BoxShadow(color: Colors.white, offset: Offset(5, 0))
                          ],
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorPadding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: Colors.amber,
                          ),

                          labelColor: Colors.white,

                          // unselectedLabelColor: Colors.black,
                          tabs: [
                            // first tab [you can add an icon using the icon property]
                            const Tab(
                              text: 'การแข่งขันที่สร้าง',
                            ),
                            // second tab [you can add an icon using the icon property]
                            const Tab(
                              text: 'การแข่งขันที่เข้าร่วม',
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                Center(child: Home_create()),

                // second tab bar view widget
                Center(child: Home_join()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
