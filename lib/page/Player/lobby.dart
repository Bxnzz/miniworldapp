import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  late AttendService attendService;
  late Future<void> loadDataMethod;
  late RaceService raceService;
  late int idUser;
  late int idTeam;
  late int idRace;
  @override
  void initState() {
    super.initState();
    idUser = context.read<AppData>().idUser;
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    idRace = context.read<AppData>().idrace;
    loadDataMethod = loadData();
    log('${idUser}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ล็อบบี้'),
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: attends.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        splashColor: Colors.blue.withAlpha(30),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text("ทีม : ${e.team.teamId}" + '${e.teamId}')
                              ],
                            )
                          ],
                        ),
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

  Future<void> loadData() async {
    try {
      // var r = await raceService.racesByID(userID: idUser);
      var a = await attendService.attendByUserID(userID: idUser);
      attends = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}
