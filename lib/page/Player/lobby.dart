import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/DTO/attendStatusDTO.dart';
import 'package:miniworldapp/model/DTO/raceDTO.dart';
import 'package:miniworldapp/model/DTO/raceStatusDTO.dart';
import 'package:miniworldapp/model/attend.dart';

import 'package:miniworldapp/page/Host/host_race_start.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:provider/provider.dart';

import '../../model/missionComp.dart';

import '../../model/result/attendRaceResult.dart';
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
  late int idAttend;
  late int userCreate;
  var result;
  late int status = 1;
  late int raceStatus;

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
    raceStatus = context.read<AppData>().raceStatus;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    pressAttention = !pressAttention;
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.racesByraceID(raceID: idRace).then((value) {
      log(value.data.first.raceName);
    });
    loadDataMethod = loadData();
    log('id User is ${idUser}');
    log('id Race is ${idRace}');
    log('id Attend is${idAttend}');
    log('id Team is${idTeam}');
    log('StatusStart :${status}');
    log("Race Status$raceStatus");
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
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: Row(
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
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    //padding: const EdgeInsets.all(8.0),
                    physics: const BouncingScrollPhysics(),
                    children: attendShow.map((e) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, right: 15, left: 15),
                          child: CardDetailPlayer(e));
                    }).toList(),
                  ),
                ),
                idUser != userCreate
                    ? Column(children: [
                        chkReadyBtn(context),
                        //Host
                      ])
                    : ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        child: Text('เริ่มเกม'))
              ]);
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          }),
    );
  }

  Card CardDetailPlayer(Map<String, List<AttendRace>> e) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        splashColor: Colors.blue.withAlpha(30),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: ExpansionTile(
              title: idAttend == e.values.first.first.atId
                  ?
                  //ทีมที่เข้าร่วม
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.values.first.first.team.teamName + " (ทีมคุณ)"),
                        e.values.first.first.status == 2 &&
                                e.values.first.first.atId == idAttend
                            ? Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: const Text(
                                  "(พร้อม)",
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            : const Text(
                                "(ยังไม่พร้อม)",
                                style: TextStyle(color: Colors.red),
                              )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        attends.isEmpty
                            ? Text("ยังไม่มีทีมเข้าร่วม")
                            : Text(e.values.first.first.team.teamName),
                        e.values.first.first.status == 2
                            ? Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: const Text(
                                  "(พร้อม)",
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            : const Text(
                                "(ยังไม่พร้อม)",
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
              children: e.values.first
                  .map((user) => ListTile(
                        title: Row(
                          children: [
                            Text(user.user.userName.toString()),
                          ],
                        ),
                      ))
                  .toList()),
        ),
      ),
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
                  debugPrint(attendStatusDtoToJson(atDto));
                  log("id Att ${idAttend}");
                  //  var b = await attendService.attendByAtID(atDto, idAttend);
                  attendShow = [];
                  log("message");
                  setState(() {
                    context.read<AppData>().status = status;
                    loadDataMethod = loadData();
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
                  AttendStatusDto atDto = AttendStatusDto(status: status);
                  var b = await attendService.attendByAtID(atDto, idAttend);

                  attendShow = [];
                  setState(() {
                    loadDataMethod = loadData();
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
    try {
      log("LoadData");
      log(idRace.toString());
      // var r = await raceService.racesByID(userID: idUser);

      var a = await attendService.attendByRaceID(raceID: idRace);
      log("ssdsd" + a.data.first.atId.toString());
      attends = a.data;
      status = a.data.first.status;
      userCreate = a.data.first.team.race.userId;
      log('userCreate' + userCreate.toString());

      log(attendShow.toList().toString());
    } catch (err) {
      log('Error:$err');
    }
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

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HostRaceStart(),
              ));
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
}
