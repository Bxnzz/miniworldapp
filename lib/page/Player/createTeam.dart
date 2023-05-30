import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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

  TextEditingController textEditingController = TextEditingController();
  String Username = '';
  String name = '';

  var selectedValue;
  int idrace = 0;
  var userid = 0;
  int idUser = 0;
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();

  List<User> items = [];
  // final List<String> items = [
  //   'A_Item1',
  //   'A_Item2',
  //   'A_Item3',
  //   'A_Item4',
  //   'B_Item1',
  //   'B_Item2',
  //   'B_Item3',
  //   'B_Item4',
  // ];

  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  late Future<void> loadDataMethods;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService.getUserAll().then((value) {
      log("is ${userService}");
    });
    idrace = context.read<AppData>().idrace;
    log("race id is " + idrace.toString());
    // 2.2 async method

    Username = context.read<AppData>().Username;
    idUser = context.read<AppData>().idUser;
    log("user is " + idUser.toString());
    //items = context.read<AppData>().users;

    nameMember1.text = Username;
    //textEditingController.text = items.toList().toString();
    //log(items.toList().toString());
    loadDataMethods = loadDatas();
  }

  @override
  void dispose() {
    // nameTeam.dispose(); // ยกเลิกการใช้งานที่เกี่ยวข้องทั้งหมดถ้ามี
    nameMember1.dispose();
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 234, 112, 255),

      body: SingleChildScrollView(
        child: FutureBuilder(
            future: loadDataMethods,
            builder: (context, AsyncSnapshot snapshot) {
              return Form(
                key: _formKey,
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
                                padding:
                                    const EdgeInsets.fromLTRB(32, 50, 32, 32),
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
                              padding:
                                  const EdgeInsets.fromLTRB(32, 20, 32, 32),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'ตัวฉันเอง',
                                ),
                                readOnly: true,
                                controller: nameMember1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 20, 32, 32),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<User>(
                                  isExpanded: true,
                                  hint: Text(
                                    'เพิ่มสมาชิก',
                                    // style: TextStyle(
                                    //   fontSize: 14,
                                    //   color: Theme.of(context).hintColor,
                                    // ),
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(item.userName),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  },
                                  // buttonStyleData: const ButtonStyleData(
                                  //   height: 40,
                                  //   width: 200,
                                  // ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: textEditingController,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 4,
                                        right: 8,
                                        left: 8,
                                      ),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        controller: textEditingController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Search for an item...',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return (item.value
                                          .toString()
                                          .contains(searchValue));
                                    },
                                  ),
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController.clear();
                                    }
                                    //     textEditingController.clear();
                                    //   }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  log(users.toList().toString());
                                  if (_formKey.currentState!.validate()) {
                                    TeamDto dto = TeamDto(
                                        raceId: idrace,
                                        teamName: nameTeam.text,
                                        teamImage: '');
                                    //log(dto.toString());

                                    var team = await teamService.Teams(dto);
                                    //log(team.data.teamId.toString());
                                    log(idUser.toString());
                                    AttendDto attendDto = AttendDto(
                                        lat: 0.0,
                                        lng: 0.0,
                                        datetime: '2023-02-1',
                                        userId: idUser,
                                        teamId: team.data.teamId);
                                    //   AttendDto Atdto2 = AttendDto(lat: 0, lng: 0, datetime: '', userId: 2, teamId: team.data.teamId);
                                    //  attendDto = AttendDto(lat: 0.0, lng: 0.0, datetime: '2023-02-1', userId: idUser, teamId: team.data.teamId);
                                    var attends =
                                        await attendService.attends(attendDto);
                                    // log(Atdto.toString());
                                    //  attends = await attendService.Attends(Atdto2);
                                    //  log(attends.data.massage);
                                    // log(team.data.teamId.toString());

                                    log(attends.data.massage);
                                    if (team.data.teamId > 0 &&
                                        attends.data.massage ==
                                            "Insert Success") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('team Successful')),
                                      );
                                      log("team success");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Lobby(),
                                            settings:
                                                RouteSettings(arguments: null),
                                          ));
                                      return;
                                    } else {
                                      log("team fail");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('team fail try agin!')),
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
                              border: Border.all(
                                  color: Colors.purple.shade50, width: 3),
                              shape: BoxShape.rectangle,
                            ),
                            child: const Text('ลงทะเบียนเข้าร่วม'),
                          ),
                        ),
                      )
                    ])),
              );
            }),
      ),
    );
  }

  Future<void> loadDatas() async {
    try {
      var a = await userService.getUserAll();
      items = a.data;
      // debugPrint("asdfasdfasdfasd" + users.toString());
    } catch (err) {
      log('Error:$err');
    }
  }
}

//   Future<List<UserItem>> loadMembers() async {
//     List<UserItem> userObjs = [];
//     for (var user in context.read<AppData>().users) {
//       UserItem item = UserItem(
//         label: user.userName,
//         value: user,
//       );
//       userObjs.add(item);
//       log(userObjs.toString());
//     }
//     return userObjs;
//   }
// }

class UserItem {
  late String label;
  late User value;
  UserItem({required this.label, required this.value});
}
