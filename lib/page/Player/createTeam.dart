import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miniworldapp/model/DTO/teamDTO.dart';
import 'package:miniworldapp/model/team.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';
import '../../service/team.dart';


class CeateTeam extends StatefulWidget {
  const CeateTeam({super.key});

  @override
  State<CeateTeam> createState() => _CeateTeamState();
}

class _CeateTeamState extends State<CeateTeam> {
   // 1. กำหนดตัวแปร
  List<Team> teams = [];
 // List<User> users = [];
  List<TeamDto> teamDTOs = [];
  late Future<void> loadDataMethod;
  late TeamService teamService;

  TextEditingController nameTeam = TextEditingController();
  TextEditingController nameMember1 = TextEditingController();
  TextEditingController nameMember2 = TextEditingController();

  
 // var nameItems = List<String>.from(elements);

   // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR
    teamService =
        TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    //  loadDataMethod = addData(logins);
  }
  @override
  void dispose() {
    nameTeam.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    nameMember1.dispose();
    nameMember2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 112, 255),
      body: Center(
          child: Stack(
              alignment: AlignmentDirectional.topCenter,
              clipBehavior: Clip.none,
              children: [
                Card(
                  margin:  EdgeInsets.fromLTRB(32, 100, 32, 32),
                  color: Colors.purple.shade50,
                  
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              
                              hintText: 'ชื่อทีม',
                            ),
                            controller: nameTeam,
                          )),
                           Padding(
                            padding: EdgeInsets.fromLTRB(32, 20, 32, 32),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'ชื่อสมาชิกคนที่ 1',
                              ),
                              controller: nameMember1,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'ชื่อสมาชิกคนที่ 2',
                              ),
                              controller: nameMember2,
                              ),
                          ),
                         // Padding(padding: EdgeInsets.all(8.0),
                          // child: ElevatedButton(onPressed: () async{
                          //     TeamDto dto = TeamDto(
                          //       teamName: nameTeam.text, userId: 1, raceId: 5, teamImage: '');
                          //   log(jsonEncode(dto));

                          //   var team = await teamService.Teams(dto);
                          //   if (teams.data.userId != 0) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Login Successful')),
                          //             );
                          //             log("login success");
                          // },
                          // child: Text('ลงทะเบียน'),),
                          // )
                        
                    ],
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.purple.shade50, width: 3),
                        shape: BoxShape.rectangle,
                        
                      ),
                      child: const Text('ลงทะเบียนเข้าร่วม'),
                    ),
                  ),
                )
              ])),
    );
  }
}

