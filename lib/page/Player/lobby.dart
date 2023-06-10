import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/DTO/attendStatusDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:provider/provider.dart';

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
  List<AttendRace> attends = [];
  late AttendRace attendRace;
  List<Map<String, List<AttendRace>>> attendShow = [];
  Iterable<Map<String, List<AttendRace>>> d = [];
  List<Team> teams = [];
  late Attend attend;
  late AttendService attendService;
  late Future<void> loadDataMethod;
  late RaceService raceService;
  late TeamService teamService;
  late int idUser;
  late int idTeam;
  late int idRace;
  late int idAttend;
  int status = 1;
  late AttendStatusDto result;
  bool pressAttention = false;

  @override
  void initState() {
    super.initState();

    idUser = context.read<AppData>().idUser;
    idRace = context.read<AppData>().idrace;
    idAttend = context.read<AppData>().idAt;
    idTeam = context.read<AppData>().idTeam;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
    log('${idUser}');
    log('raceID ${idRace}');
    log('idAt${idAttend}');
    log('idTeam${idTeam}');
    log('StatusStart :${status}');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height.sign;
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('ล็อบบี้'),
      ),
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      physics: const BouncingScrollPhysics(),
                      children: attendShow.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              splashColor: Colors.blue.withAlpha(30),
                              child: ExpansionTile(
                                  title: idAttend == e.values.first.first.atId
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(e.values.first.first.team
                                                .teamName),
                                            status == 2 &&
                                                    attends.first.status == 2
                                                ? Text(
                                                    "(พร้อม)",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )
                                                : Text(
                                                    "(ยังไม่พร้อม)",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(e.values.first.first.team
                                                .teamName),
                                            Text(
                                              "(ยังไม่พร้อม)",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                  children: e.values.first
                                      .map((user) => ListTile(
                                            title: Row(
                                              children: [
                                                Text(user.user.userName
                                                    .toString()),
                                              ],
                                            ),
                                          ))
                                      .toList()),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            attendShow = [];

                            log("status is $status");
                            pressAttention = !pressAttention;
                            if (status == 1) {
                              status = 2;
                              attends.first.status = 2;
                            } else {
                              status = 1;
                            }

                            //result = b.data;
                          });
                          AttendStatusDto atDto =
                              AttendStatusDto(status: status);
                          var b =
                              await attendService.attendByAtID(atDto, idAttend);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: status == 2 && attends.first.status == status
                              ? Colors.red
                              : Colors.green, // Background color
                        ),
                        child: status == 2 && attends.first.status == status
                            ? Text(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                "ยกเลิก")
                            : Text(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                "พร้อม"),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> loadData() async {
    try {
      // var r = await raceService.racesByID(userID: idUser);
      var a = await attendService.attendByRaceID(raceID: idRace);
      attends = a.data;
      log(attendShow.toList().toString());
    } catch (err) {
      log('Error:$err');
    }
  }
}
