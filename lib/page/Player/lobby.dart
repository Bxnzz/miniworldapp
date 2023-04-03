import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:provider/provider.dart';

import '../../model/team.dart';
import '../../service/provider/appdata.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lobby'),
     //     actions: <Widget>[Text(Username)],
          
        ),
        body: const Lobbys()
               
        ),
       
        
      
    );
  }
}

class Lobbys extends StatefulWidget {
  const Lobbys({super.key});

  @override
  State<Lobbys> createState() => _LobbysState();
}

class _LobbysState extends State<Lobbys> {
  // 1. กำหนดตัวแปร
  List<Team> teams = [];

  late Future<void> loadDataMethod;
  late TeamService teamService;

 // var formatter = DateFormat.yMEd();
  // var dateInBuddhistCalendarFormat = formatter.formatInBuddhistCalendarThai(now);

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService.getTeams().then((value) {
      log(value.data.first.teamName);
    });
    // 2.2 async method
    loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: teams.map((element) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("ชื่อ: ${element.teamName}"),
                            content: SizedBox(
                              height: 95,
                              child: Column(
                                children: [
                                  // Text(
                                  //    'จำนวนทีม: ${element.raceLimitteam.toString()}'),
                                  // Text(
                                  //     'เปิดรับสมัคร: ${formatter.formatInBuddhistCalendarThai(element.raceTimeSt)}'),
                                  // Text(
                                  //     'ปิดรับสมัคร:${formatter.formatInBuddhistCalendarThai(element.raceTimeFn)} '),
                                  // Text(
                                  //     'ปิดรับสมัคร:${formatter.formatInBuddhistCalendarThai(element.eventDatetime)} '),
                                ],
                              ),
                            ),
                            // actions: <Widget>[
                            //   TextButton(
                            //     onPressed: () =>
                            //         Navigator.pop(context, 'Cancel'),
                            //     child: const Text('ยกเลิก'),
                            //   ),
                            //   ElevatedButton(
                            //     onPressed: () {  Navigator.push(context,
                            //      MaterialPageRoute(builder: (context) => CeateTeam()));
                            //      context.read<AppData>().idrace = element.raceId; 
                            //      },
                            //     child: const Text('ลงทะเบียน'),
                            //   ),
                            // ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("ชื่อ: " + element.teamName),
                              // Text("ปิดรับสมัคร: " +
                              //     formatter.formatInBuddhistCalendarThai(
                              //         element.raceTimeFn)),
                              // Text("สถานที่: " + element.raceLocation),
                              // Text("# " + element.raceId.toString()),
                            ],
                          ),
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
      var a = await teamService.getTeams();
      teams = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}