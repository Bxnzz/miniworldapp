import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:miniworldapp/model/DTO/attendStatusDTO.dart';
import 'package:miniworldapp/model/DTO/raceStatusDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/result/teamResult.dart';
import 'package:miniworldapp/page/General/detil_race_host.dart';

import 'package:miniworldapp/page/Player/chat_room.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pushable_button/pushable_button.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../model/team.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  late List<Race> races;
  late List<AttendRace> attends;
  late AttendRace attendRace;
  late List<TeamResult> teamResult;
  List<Map<String, List<AttendRace>>> attendShow = [];
  Iterable<Map<String, List<AttendRace>>> d = [];
  List<Team> teams = [];
  late Attend attend;
  late AttendService attendService;

  late Future loadDataMethod;
  late RaceService raceService;
  late TeamService teamService;
  late int idUser;
  late int idTeam;
  int idRace = 0;
  int idAttend = 0;
  int userCreate = 0;
  var result;
  late int status = 1;
  late int raceStatus;
  int selec = 1;

  List<String> playerIds = [];
  Map<String, dynamic> mc = {};

  String Username = '';
  String raceName = '';
  String idTeamDel = '';

  bool pressAttention = false;
  late AttendStatusDto atDto;

  @override
  void initState() {
    super.initState();

    idUser = context.read<AppData>().idUser;
    idRace = context.read<AppData>().idrace;
    idAttend = context.read<AppData>().idAt;
    idTeam = context.read<AppData>().idTeam;
    status = context.read<AppData>().status;
    Username = context.read<AppData>().Username;
    raceStatus = context.read<AppData>().raceStatus;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    pressAttention = !pressAttention;
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.racesByraceID(raceID: idRace).then((value) {
      log(value.data.first.raceName);
    });

    log('id User is ${idUser}');
    log('id Race is ${idRace}');
    log('raceName is${raceName}');
    log('id Attend is${idAttend}');
    log('id Team is${idTeam}');
    log('StatusStart :${status}');
    log("Race Status$raceStatus");
    attendShow = [];
    loadDataMethod = loadData();
  }

  void _Startgame() async {
    raceStatus = 2;
    RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
    var racestatus = await raceService.updateStatusRaces(racedto, idRace);
    mc = {
      'notitype': 'startgame',
      'mcid': raceStatus,
      'raceID': idRace,
    };
    var notification1 = OSCreateNotification(
        //playerID
        additionalData: mc,
        playerIds: playerIds,
        content: raceName,
        heading: "เริ่มการแข่งขัน",
        //  iosAttachments: {"id1",urlImage},
        // bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);
    log('player ' + playerIds.toString());
    var response1 = await OneSignal.shared.postNotification(notification1);
    // Get.defaultDialog(title: mc.toString());
    Get.to(DetailHost());
  }

  Widget CardDetailPlayer() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log('xxxxx ' + attendShow.last.values.first.length.toString());
            // log('xxxxx ' + attendShow.last.values.first.last.user.userName);
            // attendShow.[team].values.first.[player].user.userName

            return ListView.builder(
              itemCount: attendShow.length,
              itemBuilder: (context, index) {
                if (attends.first.team.race.userId == idUser) {
                  return Slidable(
                      key: const ValueKey(0),

                      // The start action pane is the one at the left or the top side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (BuildContext context) async {
                              idTeamDel = attendShow[index]
                                  .values
                                  .first
                                  .first
                                  .team
                                  .teamId
                                  .toString();
                              log('team ID = ${idTeamDel}');
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "ลบทีม\"${attendShow[index].values.first.first.team.teamName}\" หรือไม่"),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('ยกเลิก',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    var teamDelete =
                                                        await teamService
                                                            .DelbyTeamID(
                                                                idTeamDel
                                                                    .toString());

                                                    if (teamDelete
                                                            .data.result ==
                                                        '1') {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'delete Successful')),
                                                      );
                                                      attendShow.removeWhere(
                                                          (element) {
                                                        return element
                                                                .values
                                                                .first
                                                                .first
                                                                .teamId ==
                                                            idTeamDel;
                                                      }); //go through the loop and match content to delete from list

                                                      setState(() {
                                                        loadDataMethod =
                                                            loadData();
                                                      });
                                                      Navigator.pop(context);
                                                      // log("race Successful");
                                                      return;
                                                    } else {
                                                      // log("team fail");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'delete fail try agin!')),
                                                      );
                                                    }
                                                    ;
                                                  },
                                                  child: Text("ตกลง")),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            backgroundColor: Color.fromARGB(255, 255, 0, 0),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'ลบทีม',
                          ),
                        ],
                      ),
                      child: CardDetail(index, textTheme, context));
                }

                return CardDetail(index, textTheme, context);
              },
            );
          } else {
            return Container();
          }
        });
  }

  SizedBox CardDetail(int index, TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12.0),
                splashColor: Colors.blue.withAlpha(30),
                child: Stack(children: [
                  Positioned(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.network(
                        attendShow[index].values.first.first.team.teamImage,
                        height: 60,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ExpansionTile(
                      key: Key(selec.toString()),
                      initiallyExpanded: idTeam ==
                              attendShow[index].values.first.first.teamId &&
                          idUser !=
                              attendShow[index]
                                  .values
                                  .first
                                  .first
                                  .team
                                  .race
                                  .userId,
                      title: idTeam ==
                                  attendShow[index].values.first.first.teamId &&
                              idUser !=
                                  attendShow[index]
                                      .values
                                      .first
                                      .first
                                      .team
                                      .race
                                      .userId
                          ?
                          //ทีมที่เข้าร่วม
                          Row(children: [
                              Text(
                                ("${attendShow[index].values.first.first.team.teamName} (ทีมคุณ)"),
                                style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(156, 39, 176, 1),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.white54,
                                        offset: Offset(5, 3),
                                      ),
                                    ]),
                              ),
                            ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Name team (Host)
                                //another team
                                Text(
                                    attendShow[index]
                                        .values
                                        .first
                                        .first
                                        .team
                                        .teamName,
                                    style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 20.0,
                                            color: Color.fromRGBO(
                                                253, 244, 255, 1),
                                            offset: Offset(5, 3),
                                          ),
                                        ])),
                              ],
                            ),
                      children: attendShow[index].values.first.map((e) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showProfileAlertDialog(context, e.user);
                                      log("tab${e.user.userName}");
                                    },
                                    child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(e.user.userImage)),
                                  ),
                                  Gap(5),
                                  Text(e.user.userName),
                                ],
                              ),
                              e.status == 2
                                  //statuscheck(logging in)
                                  ? const FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.solidCircleXmark,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                            ],
                          ),
                        );
                      }).toList())
                ]),
              ),
            ],
          )),
    );
  }

  SizedBox chkReadyBtn(BuildContext context) {
    return context.read<AppData>().status == 1
        ? SizedBox(
            width: 120,
            child: ElevatedButton(
                onPressed: () async {
                  status = 2;

                  AttendStatusDto atDto = AttendStatusDto(status: status);
                  debugPrint("asdfasdfasdf" + attendStatusDtoToJson(atDto));
                  log("id Att ${idAttend}");
                  var b = await attendService.attendByAtID(atDto, idAttend);
                  attendShow = [];
                  log("message");
                  pressAttention = true;
                  loadDataMethod = loadData();
                  setState(() {
                    context.read<AppData>().status = status;
                  });
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: const Text(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    "พร้อม")),
          )
        : SizedBox(
            width: 120,
            child: ElevatedButton(
                onPressed: () async {
                  status = 1;
                  attendShow = [];
                  pressAttention = false;
                  AttendStatusDto atDto = AttendStatusDto(status: status);
                  debugPrint("asdfasdfasdf" + attendStatusDtoToJson(atDto));
                  log("id Att ${idAttend}");
                  var b = await attendService.attendByAtID(atDto, idAttend);

                  loadDataMethod = loadData();
                  setState(() {
                    context.read<AppData>().status = status;
                  });
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text(
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    "ยกเลิก")),
          );
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      log("LoadData");
      log(idRace.toString());
      // var r = await raceService.racesByID(userID: idUser);

      var a = await attendService.attendByRaceID(raceID: idRace);

      attends = a.data;
      status = a.data.first.status;
      userCreate = a.data.first.team.race.userId;
      raceName = a.data.first.team.race.raceName;

      playerIds.clear();
      for (var element in a.data) {
        if (element.user.onesingnalId.isNotEmpty) {
          playerIds.add(element.user.onesingnalId);
        }
      }
      log('userCreate' + userCreate.toString());
      log("raceName Load is = ${raceName}");

      log(attendShow.toList().toString());
      log(" sta == ${status}");
    } catch (err) {
      log('Error:$err');
    }
    stopLoading();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = SizedBox(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
        child: Text(style: const TextStyle(color: Colors.white), "เริ่มเกม"),
        onPressed: () async {
          idRace = context.read<AppData>().idrace;
          raceStatus = 2;
          RaceStatusDto racedto = RaceStatusDto(raceStatus: raceStatus);
          var a = await raceService.updateStatusRaces(racedto, idRace);

          _Startgame();
        },
      ),
    );
    Widget cancleButton = SizedBox(
      width: 120,
      child: ElevatedButton(
        child: const Text("ยกเลิก"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ต้องการจะเริ่มเกมหรือไม่"),
      actions: [cancleButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showProfileAlertDialog(BuildContext context, AttendRaceUser user) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
        width: Get.width,
        child: Column(
          children: [
            Text("${user.userName}"),
            CircleAvatar(
              radius: Get.width / 6,
              backgroundImage: NetworkImage("${user.userImage}"),
            ),
            Text("${user.userFullname}"),
          ],
        ),
      ),
      actions: [],
      content: Container(child: Text("${user.userDiscription}")),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height.sign;
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            debugPrint(attendShow.toList().toString());
            if (snapshot.connectionState == ConnectionState.done) {
              // if (snapshot.hasData) {
              //   return Container(
              //     child: Text("data"),
              //   );
              //   if (snapshot.data) {
              //     log('No chatroom');
              //     attendShow = [];
              //     log("datahas no");
              //     // SharedPreferences.getInstance().then((prefs) {
              //     //   prefs.setString(widget.roomID, jsonEncode({}));
              //     //   _messages = [];
              //     // });
              //     Container(
              //       child: Text("data"),
              //     );
              //   }
              // }

              String tmId = '';
              List<AttendRace> temp = [];
              for (var i = 0; i < attends.length; i++) {
                if (attends[i].teamId.toString() != tmId) {
                  if (temp.isNotEmpty) {
                    var team = {tmId: temp};
                    attendShow.add(team);
                    temp = [];
                  }
                  tmId = attends[i].teamId.toString();
                  // log(tmId.toString());
                }

                temp.add(attends[i]);
              }
              if (temp.isNotEmpty) {
                var team = {tmId: temp};
                attendShow.add(team);
              }
              // log(attendShow.toString());
              // log(attendShow[1]['102']!.first.userId.toString());
              //log(attendShow.length.toString());
              return SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.circleChevronLeft,
                              color: Colors.yellow,
                              size: 35,
                            ),
                          ),
                          Text(
                            "ล็อบบี้",
                            style: textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          attendShow = [];
                          Get.to(() => ChatRoomPage(
                                raceID: idRace,
                                userID: idUser,
                                userName: Username,
                                raceName: raceName,
                              ));
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidCommentDots,
                          color: Colors.pink,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SafeArea(
                      child: ListView(
                        //padding: const EdgeInsets.all(8.0),
                        physics: const BouncingScrollPhysics(),
                        children: attendShow.map((e) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 15, left: 15),
                              child: Container(
                                  width: Get.width,
                                  height: Get.height,
                                  child: CardDetailPlayer()));
                        }).toList(),
                      ),
                    ),
                  ),
                  idUser == userCreate
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                width: 120,
                                child: PushableButton(
                                  child: Text(
                                    'เริ่มเกม',
                                    style: textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  height: 40,
                                  elevation: 8,
                                  hslColor:const HSLColor.fromAHSL(1.0, 120, 1.0, 0.37),
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                ),
                              ),
                            ),
                          
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              width: Get.width,
                              height: Get.height / 2,
                              child: Center(child: Text("ยังไม่มีทีมเข้าร่วม")),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                                child: Text('เริ่มเกม')),
                          ],
                        )
                ]),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
