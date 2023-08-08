import 'dart:convert';
import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/General/RaceAll.dart';
import 'package:miniworldapp/page/General/detil_race.dart';
import 'package:miniworldapp/page/General/home_join_detail.dart';

import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/General/static.dart';
import 'package:miniworldapp/page/General/profile_edit.dart';
import 'package:miniworldapp/page/Host/race_create.dart';
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/page/Host/start_list_mission.dart';
import 'package:miniworldapp/page/spectator/list_spactator.dart';
import 'package:miniworldapp/page/uploadImage,video.dart';
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
  int userID = 0;
  String userimg = '';
  String userDescrip = '';
  String userFullName = '';
  TextEditingController textController = TextEditingController();
  List<Race> races = [];
  late RaceService raceService;
  int selectedPos = 0;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    
    TabItem( 
      FontAwesomeIcons.houseFlag,
      "ทั้งหมด",
      Colors.blue,
      labelStyle: TextStyle(

        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      FontAwesomeIcons.userPlus,
      "ที่สร้าง",
      Colors.pink,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      FontAwesomeIcons.users,
      "ที่เข้าร่วม",
      Colors.amber,
      circleStrokeColor: Colors.white,
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    Username = context.read<AppData>().Username;
    userID = context.read<AppData>().idUser;
    userimg = context.read<AppData>().userImage;
    userFullName = context.read<AppData>().userFullName;
    userDescrip = context.read<AppData>().userDescrip;

    log(Username);
    log("${userID}");
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: 1,
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          Get.to(() => const HomeAll());
          return true;
        },
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 90,right: 5),
            child: SpeedDial(
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
                    Get.to(ListSpactator());
                    setState(() {
                      _text = '"เข้าชมการแข่งขัน"';
                    });
                  },
                ),
              ],
              closedForegroundColor: Colors.black,
              openForegroundColor: Colors.white,
              closedBackgroundColor: Colors.white,
              openBackgroundColor: Colors.black,
            ),
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Builder(
                  builder: (context) => IconButton(
                    icon: FaIcon(FontAwesomeIcons.alignLeft,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 18),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
            
              ],
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.amber,
                child: IconButton(
                  icon: const Icon(Icons.search_sharp),
                  color: Colors.white,
                  onPressed: () {
                    showSearch(context: context, delegate: mySearchDelegate());
                  },
                ),
              ),
            ],
            centerTitle: false,
            titleSpacing: 0,
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                child: bodyContainer(),
                padding: EdgeInsets.only(bottom: bottomNavBarHeight),
              ),
              Align(alignment: Alignment.bottomCenter, child: bottomNav())
            ],
          ),
          drawer: Container(
            child: SizedBox(
              width: Get.width / 1.2,
              child: Drawer(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      // Important: Remove any padding from the ListView.

                      children: [
                        Container(
                          height: 230,
                          child: DrawerHeader(
                            decoration: BoxDecoration(),
                            child: Stack(children: [
                              Positioned(
                                  bottom: 140,
                                  left: Get.width / 1.6,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.to(() => Profile_edit());
                                    },
                                    icon: FaIcon(FontAwesomeIcons.edit),
                                  )),
                              Column(
                                children: [
                                  Gap(20),
                                  Align(
                                    heightFactor: 1,
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 5,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255))),
                                      child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              NetworkImage(userimg)),
                                    ),
                                  ),
                                  Gap(20),
                                  Align(
                                    heightFactor: 1,
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      child: Text(Username,
                                          style: Get
                                              .theme.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      child: Text(
                                        userDescrip,
                                        style: Get.theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: Color.fromARGB(
                                                    255, 104, 104, 104)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
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
                          leading: FaIcon(FontAwesomeIcons.chartSimple),
                          title: const Text('สถิติการแข่งขัน'),
                          onTap: () {
                            Get.to(const Static());
                          },
                        ),
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.doorOpen),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyContainer() {
    switch (selectedPos) {
      case 0:
        RaceAll();
        break;
      case 1:
        Home_join();
        break;
      case 2:
        Home_create();
        break;
    }

    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: selectedColor,
          child: selectedPos == 0
              ? RaceAll()
              : selectedPos == 1
                  ? Home_create()
                  : selectedPos == 2
                      ? Home_join()
                      : Container()),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value = _navigationController.value! + 1;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      iconsSize: 20,
      backgroundBoxShadow: <BoxShadow>[
        const BoxShadow(color: Colors.grey, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }
}

class mySearchDelegate extends SearchDelegate {
  int raceID = 0;
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      });

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildResults(BuildContext context) {
    late Future<void> loadDataMethod;
    List<Race> races = [];
    List<Race> match = [];

    late RaceService raceService;
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    Future<void> loadData() async {
      startLoading(context);
      try {
        var a = await raceService.races();
        races = a.data;

        for (var rac in races) {
          if (rac.raceName.toLowerCase().contains(query.toLowerCase()) ||
              rac.raceId.toString().contains(query.toLowerCase())) {
            match.add(rac);
          }
        }
      } catch (err) {
        log('Error:$err');
      } finally {
        stopLoading();
      }
    }

    loadDataMethod = loadData();
    return FutureBuilder(
      future: loadDataMethod,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.only(top: 10),
          children: match.map((element) {
            return Padding(
              padding: const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                ),
                //  shadowColor: ,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,

                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetailRace()));
                    context.read<AppData>().idrace = element.raceId;
                  },
                  child: GridTile(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      child: Image.network(element.raceImage,
                          //  width: Get.width,
                          //  height: Get.width*0.5625/2,
                          fit: BoxFit.cover),
                      footer: Container(
                        color:
                            Get.theme.colorScheme.onBackground.withOpacity(0.5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(element.raceName,
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Get.theme.colorScheme.onPrimary)),
                                Text("# ${element.raceId}",
                                    style: Get.textTheme.bodySmall!.copyWith(
                                        color:
                                            Get.theme.colorScheme.onPrimary)),
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
                          ],
                        ),
                      )),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    late Future<void> loadDataMethod;
    List<Race> races = [];
    List<Race> match = [];

    late RaceService raceService;
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    Future<void> loadData() async {
      try {
        var a = await raceService.races();
        races = a.data;

        for (var rac in races) {
          if (rac.raceName.toLowerCase().contains(query.toLowerCase()) ||
              rac.raceId.toString().contains(query.toLowerCase())) {
            match.add(rac);
          }
        }
      } catch (err) {
        log('Error:$err');
      }
    }

    loadDataMethod = loadData();
    return FutureBuilder(
      future: loadDataMethod,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.only(top: 10),
          children: match.map((element) {
            return Padding(
              padding: const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                ),
                //  shadowColor: ,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,

                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetailRace()));
                    context.read<AppData>().idrace = element.raceId;
                  },
                  child: GridTile(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      child: Image.network(element.raceImage,
                          //  width: Get.width,
                          //  height: Get.width*0.5625/2,
                          fit: BoxFit.cover),
                      footer: Container(
                        color:
                            Get.theme.colorScheme.onBackground.withOpacity(0.5),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(element.raceName,
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Get.theme.colorScheme.onPrimary)),
                                Text("# ${element.raceId}",
                                    style: Get.textTheme.bodySmall!.copyWith(
                                        color:
                                            Get.theme.colorScheme.onPrimary)),
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
                          ],
                        ),
                      )),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
