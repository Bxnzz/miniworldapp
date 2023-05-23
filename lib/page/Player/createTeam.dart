import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/attend.dart';

import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../model/DTO/teamDTO.dart';
import '../../model/team.dart';
import '../../model/user.dart';
import '../../service/provider/appdata.dart';

import '../../service/team.dart';
import '../../service/user.dart';

class CeateTeam extends StatefulWidget {
  const CeateTeam({super.key});

  @override
  State<CeateTeam> createState() => _CeateTeamState();
}

class _CeateTeamState extends State<CeateTeam> {
  // 1. กำหนดตัวแปร
  List<Team> teams = [];
  List<User> users = [];
  List<Attend> attends = [];
  List<TeamDto> teamDTOs = [];

  late Future<void> loadDataMethod;
  late TeamService teamService;
  late UserService userService;
  late AttendService attendService;

  TextEditingController nameTeam = TextEditingController();
  TextEditingController nameMember1 = TextEditingController();
  TextEditingController nameMember2 = TextEditingController();

  String Username = '';
  String name = 'te';
  String? _user;
  int idrace = 0;
  var userid = 0;
  int idUser = 0;
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService.getUserByName(name).then((value) {
      log(value.data.first.userFullname);
    });
    idrace = context.read<AppData>().idrace;
    log(idrace.toString());
    // 2.2 async method
    loadDataMethod = loadData();
    Username = context.read<AppData>().Username;
    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
    nameMember1.text = Username;
  }

  @override
  void dispose() {
    // nameTeam.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    nameMember1.dispose();
    nameMember2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 234, 112, 255),
      key: _formKey,
      body: SingleChildScrollView(
        child: Center(
            child: Stack(
                alignment: AlignmentDirectional.topCenter,
                clipBehavior: Clip.none,
                children: [
              Card(
                margin: EdgeInsets.fromLTRB(32, 100, 32, 32),
                color: Colors.purple.shade50,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'ชื่อทีม',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: nameTeam,
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'สมาชิกคนที่ 1',
                        ),
                        controller: nameMember1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                      
                      child: SearchField<User>(
                        hint: 'สมาชิกคนที่ 2', 
                    suggestions: users.map((e) => SearchFieldListItem<User>( 
                                            
                            nameU = e.userName,
                            item: e,
                            
                            // Use child to show Custom Widgets in the suggestions
                            // defaults to Text widget
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                 
                                  Text(nameU),
                                  
                                ],
                              ),
                            ),
                          ),
                          
                        ).toList(),
                         controller: nameMember2,  
                  ),   
                                 
                    ),
                   Padding(padding: EdgeInsets.all(8.0),
                   child: ElevatedButton(onPressed: () async{
                      TeamDto dto = TeamDto(raceId: idrace, teamName: nameTeam.text, teamImage: ''
                      ); 
                     
                  //    AttendDto Adto AttendDto(lat: , lng: , datetime: , userId: userid, teamId: );

                       var team = await teamService.Teams(dto);
                       log(team.data.massage);
                            if (team.data.massage == "Create Success") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('team Successful')),
                              );
                              log("team success");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Lobby(),
                                    settings: RouteSettings(arguments: null),
                                  ));
                              return;
                            } else {
                              log("team fail");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('team fail try agin!')),
                              );

                              return;
                            }
                          }
                        },
                        child: Text('สร้างทีม'),
                      ),
                    )
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
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var u = await userService.getUserByName(name);
      users = u.data;
    } catch (err) {
      log('Error:$err');
    }
  }

  Future<List<UserItem>> loadMembers() async {
    List<UserItem> userObjs = [];
    for (var user in context.read<AppData>().users) {
      UserItem item = UserItem(label: '${user.userName}', value: user);
      userObjs.add(item);
    }
    return userObjs;
  }
}

class UserItem {
  late String label;
  late User value;
  UserItem({required this.label, required this.value});
}
