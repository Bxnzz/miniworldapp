import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/user.dart';
import 'package:miniworldapp/page/General/login.dart';
import 'package:miniworldapp/page/General/profile_edit.dart';
import 'package:miniworldapp/page/General/static_create.dart';
import 'package:miniworldapp/page/General/static_join.dart';
import 'package:provider/provider.dart';

import '../../model/result/attendRaceResult.dart';
import '../../model/result/raceResult.dart';
import '../../model/result/rewardResult.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import '../../service/reward.dart';
import '../../service/user.dart';
import '../../widget/loadData.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late Future loadDataMethod;
  List<User> users = [];
  int idUser = 0;
  String userName = '';
  String userFullName = '';
  String imageUser = '';
  String userDescrip = '';
  late UserService userService;
  late AttendService attendService;
  late RewardService rewardService;

  List<RewardResult> rewards = [];
  List<AttendRace> teamAttends = [];
  Set<int> teamMe = {};
  Set<int> teamAllRegis = {};
  Set<int> teamRe = {};
  Set<int> all = {};
  int sum1 = 0;
  int sum2 = 0;
  int sum3 = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idUser = context.read<AppData>().idUser;
      log('user ' + idUser.toString());
      // userName = context.read<AppData>().Username;
      // log('username ' + userName.toString());
      var user = await userService.getUserByID(userID: idUser);
      users = user.data;
      imageUser = users.first.userImage;
      userFullName = users.first.userFullname;
      userName = users.first.userName;
      userDescrip = users.first.userDiscription;
      var t = await attendService.attendByUserID(userID: idUser);
      teamAttends = t.data;
      //  hostID = t.data.first

      for (var tm in teamAttends) {
        log(tm.team.raceId.toString());
        teamMe.add(tm.team.raceId);
        //log('teamAll'+ tm.teamId.toString());
        teamAllRegis.add(tm.teamId);
      }
      log('teamAll' + teamAllRegis.toString());
      log('raceteams ' + teamMe.toString());

      var re = await rewardService.rewardAll();
      rewards = re.data;
      sum1 = 0;
      sum2 = 0;
      sum3 = 0;
      for (var element in rewards) {
        //  log('RewardTeam'+element.teamId.toString());
        teamRe.add(element.teamId);
        var all = teamAllRegis.intersection(teamRe);
        log('all$all');

        if (all.contains(element.teamId)) {
          log('Name ' +
              element.team.teamName +
              ' no. ' +
              element.reType.toString());
          log('sumAll ' + all.length.toString());
          if (element.reType == 1) {
            log('sum ' + all.length.toString());
            sum1 = all.length;
            log('sum1 ' + sum1.toString());
          }
          if (element.reType == 2) {
            log('sum2 ' + all.length.toString());
            sum2 = all.length;
          }
          if (element.reType == 3) {
            log('sum3 ' + all.length.toString());
            sum3 = all.length;
          } else {}
        }
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 244, 244),
            body: FutureBuilder(
                future: loadDataMethod,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton(
                                    icon: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 153, 152, 152)
                                                  .withOpacity(0.8),
                                              blurRadius: 3.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                        ),
                                        child: const FaIcon(
                                            FontAwesomeIcons.elementor,
                                            size: 38,
                                            color: Colors.purpleAccent)),
                                    onSelected: (result) {
                                      if (result == 0) {
                                        Get.to(() => Profile_edit())!
                                            .then((value) {
                                          setState(() {
                                            loadDataMethod = loadData();
                                            log('Goback');
                                          });
                                        });
                                      }
                                      if (result == 1) {
                                        //  Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            title: Center(
                                                child: Text('ออกจากระบบ')),
                                            content: Text(
                                                'คุณต้องการจะออกจากระบบหรือไม่?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
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
                                                        Get.offAll(
                                                            () => Login());
                                                      },
                                                      child: const Text(
                                                        'ตกลง',
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
                                        borderRadius: BorderRadius.circular(8)),
                                    offset: Offset(-6, 50),
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        _buildPopupMenuEdit(
                                            'แก้ไขโปรไฟล์', Icons.edit, 0),
                                        _buildPopupMenuExit('ออกจากระบบ',
                                            Icons.exit_to_app_rounded, 1),
                                      ];
                                    }),
                              ]),
                          Container(
                            height: height * 0.35,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double innerHeight = constraints.maxHeight;
                                double innerWidth = constraints.maxWidth;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: innerHeight * 0.73,
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 153, 152, 152)
                                                  .withOpacity(0.8),
                                              blurRadius: 3.0,
                                              offset: new Offset(0.0, 3.0),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Text('$userFullName ($userName)',
                                                style: Get
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onBackground)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(userDescrip,
                                                style: Get.textTheme.titleSmall!
                                                    .copyWith(
                                                        color: const Color
                                                                .fromARGB(255,
                                                            118, 118, 118))),
                                            Gap(5),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Image.asset(
                                                    "assets/image/crown1.png",
                                                    width: 35,
                                                  ),
                                                  Text(sum1.toString()),
                                                  Image.asset(
                                                    "assets/image/crown2.png",
                                                    width: 35,
                                                  ),
                                                  Text(sum2.toString()),
                                                  Image.asset(
                                                    "assets/image/crown3.png",
                                                    width: 35,
                                                  ),
                                                  Text(sum3.toString()),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: <BoxShadow>[
                                              new BoxShadow(
                                                color: const Color.fromARGB(
                                                    255, 121, 121, 121),
                                                blurRadius: 3.0,
                                                offset: new Offset(0.0, 3.0),
                                              ),
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: Get.width / 6,
                                            backgroundImage:
                                                NetworkImage(imageUser),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 45,
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicatorPadding: EdgeInsets.zero,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.purpleAccent),
                              controller: _tabController,
                              // give the indicator a decoration (color and border radius)

                              labelColor: Colors.white,

                              // unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(50),
                                    //     border: Border.all(color: Colors.redAccent, width: 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("เคยสร้าง"),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(50),
                                    //     border: Border.all(color: Colors.redAccent, width: 1)),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("เคยเข้าร่วม"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // first tab bar view widget
                                Center(child: Static_create()),

                                // second tab bar view widget
                                Center(child: Static_join()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    iconData,
                    color: Get.theme.colorScheme.primary,
                  ),
                  Text(
                    menuTitle,
                    style: (Get.textTheme.bodySmall!.copyWith(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Divider(),
              )
            ],
          ),
        ));
  }

  PopupMenuItem _buildPopupMenuExit(
      String menuTitle, IconData iconData, int value) {
    return PopupMenuItem(
        value: value,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  iconData,
                  color: Get.theme.colorScheme.primary,
                ),
                Text(
                  menuTitle,
                  style: (Get.textTheme.bodySmall!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ],
        ));
  }
}
