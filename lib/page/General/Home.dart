import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/General/RaceAll.dart';
import 'package:miniworldapp/page/General/detil_race.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/home_create.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/General/profile_edit.dart';
import 'package:miniworldapp/page/General/static.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../service/user.dart';
import '../../widget/loadData.dart';
import '../Host/race_create.dart';
import '../spectator/list_spactator.dart';
import 'home_join.dart';

// class NavigationBarApp2 extends StatefulWidget {
//   const NavigationBarApp2({super.key});

//   @override
//   State<NavigationBarApp2> createState() => _NavigationBarApp2State();
// }

// class _NavigationBarApp2State extends State<NavigationBarApp2> {
//   @override
//   Widget build(BuildContext context) {
//     int currentPageIndex = 0;
//     return Scaffold(
//       // bottomNavigationBar: SalomonBottomBar(
//       //   currentIndex: currentPageIndex,
//       //   onTap: (i) => setState(() => currentPageIndex = i),
//       //   items: [
//       //     /// Home
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.home),
//       //       title: Text("Home"),
//       //       selectedColor: Colors.purple,
//       //     ),

//       //     /// Likes
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.favorite_border),
//       //       title: Text("Likes"),
//       //       selectedColor: Colors.pink,
//       //     ),

//       //     /// Search
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.search),
//       //       title: Text("Search"),
//       //       selectedColor: Colors.orange,
//       //     ),

//       //     /// Profile
//       //     SalomonBottomBarItem(
//       //       icon: Icon(Icons.person),
//       //       title: Text("Profile"),
//       //       selectedColor: Colors.teal,
//       //     ),
//       //   ],
//       // ),
//       // body: <Widget>[
//       //   Container(
//       //     color: Colors.red,
//       //     alignment: Alignment.center,
//       //     child: RaceAll(),
//       //   ),
//       //   Container(
//       //     color: Colors.green,
//       //     alignment: Alignment.center,
//       //     child: RaceCreatePage(),
//       //   ),
//       //   Container(
//       //     color: Colors.blue,
//       //     alignment: Alignment.center,
//       //     child: const Text('Page 3'),
//       //   ),
//       //    Container(
//       //     color: Colors.blue,
//       //     alignment: Alignment.center,
//       //     child: const Text('Page 3'),
//       //   ),
//       // ][currentPageIndex],
//     );
//   }
// }



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  String _text = '';
  String Username = '';

  int userID = 0;
  String oneID = '';
  String userimg = '';
  String userDescrip = '';
  String userFullName = '';
   List<Race> races = [];
  late RaceService raceService;
  late UserService userService;
  
  @override
  void initState() {
    super.initState();
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);

    Username = context.read<AppData>().Username;
    userID = context.read<AppData>().idUser;
    userimg = context.read<AppData>().userImage;
    userFullName = context.read<AppData>().userFullName;
    userDescrip = context.read<AppData>().userDescrip;

    log(Username);
    log("${userID}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentPageIndex,
        onTap: (i) => setState(() => currentPageIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            title: Text("หน้าหลัก"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: FaIcon(FontAwesomeIcons.userPlus),
            title: Text("ที่สร้าง"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: FaIcon(FontAwesomeIcons.users),
            title: Text("ที่เข้าร่วม"),
            selectedColor: Colors.orange,
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: RaceAll(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: Home_create(),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Home_join(),
        ),
      ][currentPageIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 5),
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
          openForegroundColor: Colors.amber,
          closedBackgroundColor: Colors.amber,
          openBackgroundColor: Colors.black,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          // BeveledRectangleBorder(
          //     borderRadius: BorderRadius.circular(20)),
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
          title:
              // SafeArea(
              //   child: Column(
              //     children: [
              //       CircleAvatar(
              //         backgroundImage: NetworkImage("${userimg}"),
              //       )
              //     ],
              //   ),
              // ),
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: FaIcon(FontAwesomeIcons.alignLeft,
                      color: Theme.of(context).colorScheme.onPrimary, size: 18),
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
        ),
      ),
      drawer: drawer(
          userimg: userimg, Username: Username, userDescrip: userDescrip),
    );
  }
}

class drawer extends StatelessWidget {
  const drawer({
    super.key,
    required this.userimg,
    required this.Username,
    required this.userDescrip,
  });

  final String userimg;
  final String Username;
  final String userDescrip;
  

  @override
  Widget build(BuildContext context) {
    String oneID = '';
    late UserService userService;
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    return Container(
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
                    height: 215,
                    child: DrawerHeader(
                      decoration: BoxDecoration(),
                      child: Stack(children: [
                        Positioned(
                            bottom: 130,
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
                                    backgroundImage: NetworkImage(userimg)),
                              ),
                            ),
                            Gap(15),
                            Align(
                              heightFactor: 1,
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                child: Text(Username,
                                    style: Get.theme.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold)),
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
                    onTap: () async {
                      OneSignal.shared.disablePush(true);
                      oneID = context.read<AppData>().oneID;
                      var one = await userService.updateOneID(oneID);
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
