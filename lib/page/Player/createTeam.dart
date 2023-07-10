import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  int idUser = 0;
  int idUser2 = 0;
  late int status;
  final _formKey = GlobalKey<FormState>();

  List<User> items = [];

  //Select Uploadfile to firebase
  File? pickedFile;
  UploadTask? uploadTask;
  bool isImage = true;
  final avata = GlobalKey<FormState>();
  String img = '';

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

    log("race id is " + idrace.toString());
    // 2.2 async method
    idrace = context.read<AppData>().idrace;
    Username = context.read<AppData>().Username;
    idUser = context.read<AppData>().idUser;
    status = context.read<AppData>().status;

    log("user is " + idUser.toString());

    nameMember1.text = Username;
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
                          children: [
                            GestureDetector(
                                onTap: () {
                                  selectFile();
                                },
                                child: pickedFile != null
                                    ? CircleAvatar(
                                        key: avata,
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        backgroundImage: FileImage(pickedFile!))
                                    : CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: GestureDetector(
                                          onTap: () {
                                            selectFile();
                                            log('message');
                                          },
                                          child: Icon(
                                            Icons.add_photo_alternate,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                          ),
                                        ),
                                      )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 50, 32, 32),
                                child: textField(nameTeam, '', 'ชื่อทีม',
                                    'กรุณาใส่ชื่อทีม', false)),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 20, 32, 32),
                                child: textField(
                                    nameMember1, '', 'ตัวฉันเอง', '', true)),
                            SelectAndSearchmember(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (await _formKey.currentState!.validate()) {
                                    setState(() {
                                      uploadFile();
                                    });
                                  }
                                },
                                child: Text('สร้างทีม'),
                              ),
                            )
                          ],
                        ),
                      ),
                      textRegisterRace()
                    ])),
              );
            }),
      ),
    );
  }

  Padding SelectAndSearchmember() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<User>(
              isExpanded: true,
              hint: const Text(
                'เพิ่มสมาชิก',
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
                  idUser2 = value!.userId;
                  selectedValue = value;
                  log(idUser2.toString());
                });
              },

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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'ค้นหาผู้เล่น.',
                      hintStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value!.userName
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
        ],
      ),
    );
  }

  Future<void> loadDatas() async {
    try {
      var a = await userService.getUserAll();
      items = a.data;
      // var b=  await attendService.attendByRaceID(raceID: idrace);

      // status = b.data.first.status;
    } catch (err) {
      log('Error:$err');
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    File file;
    PlatformFile platFile;

    setState(() {
      if (result == null) return;
      platFile = result.files.single;
      file = File(platFile.path!);
      pickedFile = file;

      log(result.files.single.toString());
      log(platFile.extension.toString());
      if (platFile.extension == 'jpg' || platFile.extension == 'png') {
        setState(() {
          isImage = true;
        });
      } else {
        isImage = false;
      }
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile?.path.split('/').last}';
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาอัพโหลดรูปทีม')),
      );
    } else {
      final file = File(pickedFile!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      log('Download Link:$urlDownload');
      img = urlDownload;
      avata.currentWidget;
      setState(() {
        Image.file(File(pickedFile!.path));
      });
      log(users.toList().toString());
      TeamDto dto =
          TeamDto(raceId: idrace, teamName: nameTeam.text, teamImage: img);
      var team = await teamService.teams(dto);
      log(idUser.toString());
      AttendDto attendDto = AttendDto(
          lat: 0.1,
          lng: 0.1,
          datetime: '2023-02-1',
          userId: idUser,
          teamId: team.data.teamId,
          status: 1);

      var attends = await attendService.attends(attendDto);
      AttendDto attendDto2 = AttendDto(
          lat: 0.1,
          lng: 0.1,
          datetime: '2023-02-1',
          userId: idUser2,
          teamId: team.data.teamId,
          status: 1);
      var attends2 = await attendService.attends(attendDto2);

      log(attends.data.massage);
      if (team.data.teamId > 0 && attends.data.massage == "Insert Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('team Successful')),
        );
        log("team success");
        Get.to(() => Lobby());
        return;
      } else {
        log("team fail");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('ลงทะเบียนผิดพลาด หรือ เคยลงทะเบียนเข้าร่วมไปแล้ว!!')),
        );

        return;
      }
    }
  }
}

class textRegisterRace extends StatelessWidget {
  const textRegisterRace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.purple.shade50, width: 3),
            shape: BoxShape.rectangle,
          ),
          child: const Text('ลงทะเบียนเข้าร่วม'),
        ),
      ),
    );
  }
}

textField(final TextEditingController controller, String hintText,
    String labelText, String error, bool readON) {
  return TextFormField(
    readOnly: readON,
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return error;
      }

      return null;
    },
  );
}
