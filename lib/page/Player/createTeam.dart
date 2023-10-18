import 'dart:developer';
import 'dart:io';

import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/home_join.dart';
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/lobby.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/widget/loadData.dart';

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
  List<AttendRace> attends = [];
  List<TeamDto> teamDTOs = [];
  List<Race> races = [];

  late Future<void> loadDataMethod;
  late TeamService teamService;
  late UserService userService;
  late AttendService attendService;
  late RaceService raceService;

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
  bool isJoin = false;
  File? _image;
  final avata = GlobalKey<FormState>();
  final keys = GlobalKey<FormState>();
  String img = '';
  late DateTime raceST;
  late DateTime raceFN;
  String attendDateTime = '';
  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  late Future<void> loadDataMethods;
  // late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    //   _navigationController.value = 2;
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วยR
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    userService.getUserAll().then((value) {
      log("is ${userService}");
    });

    // 2.2 async method
    idrace = context.read<AppData>().idrace;
    Username = context.read<AppData>().Username;
    idUser = context.read<AppData>().idUser;
    status = context.read<AppData>().status;

    log("race id is " + idrace.toString());
    log("user is " + idUser.toString());

    attendDateTime = DateTime.now().toIso8601String();
    //context.read<AppData>().attendDateTime = attendDateTime;

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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.circleChevronLeft,
              color: Colors.yellow,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/image/BGall.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
              future: loadDataMethods,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Form(
                    key: _formKey,
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Card(
                            surfaceTintColor: Colors.transparent,
                            elevation: 10,
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.fromLTRB(32, 60, 32, 32),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: upImg(),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, right: 30, left: 30),
                                      child: textField(
                                          nameTeam,
                                          'ชื่อทีม',
                                          'ชื่อทีม*',
                                          'กรุณาใส่ชื่อทีม',
                                          false)),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, right: 30, left: 30),
                                      child: textField(nameMember1, 'ตัวฉันเอง',
                                          'ตัวฉันเอง', '', true)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: SizedBox(
                                        width: 300,
                                        child: SelectAndSearchmember()),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: FilledButton(
                                          onPressed: () async {
                                            log("message");
                                            if (_formKey.currentState!
                                                .validate()) {
                                              log("message2");
                                              //regis race  first team
                                              // var b = await attendService
                                              //     .attendByUserID(userID: idUser);
                                              // attends = b.data;
                                              //  log("asdfasdf  ${attends.first.atId}");
                                              if (attends.isEmpty) {
                                                log("Can join first attend");
                                                setState(() {
                                                  uploadFile();
                                                });
                                              }
                                              if (attends.isNotEmpty) {
                                                for (var j in attends) {
                                                  log("message1");
                                                  log("${j.atId}");
                                                  // log("attend${j.datetime}");
                                                  log("ST${raceST}");
                                                  log("FN${raceFN}");
                                                  log("stJoin${j.team.race.raceTimeSt}");
                                                  log("fnJoin${j.team.race.raceTimeFn}");
                                                  if (raceST.isAfter(j.team.race.raceTimeSt) &&
                                                      raceST.isBefore(j.team
                                                          .race.raceTimeFn) &&
                                                      raceFN.isAfter(j.team.race
                                                          .raceTimeSt) &&
                                                      raceFN.isBefore(j.team
                                                          .race.raceTimeFn)) {
                                                    isJoin = true;
                                                    log("can't join chk 4 condition");
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'เคยลงทะเบียนเข้าร่วมในเวลานี้ไปแล้ว!!')),
                                                    );
                                                    break;
                                                  }
                                                }
                                                if (isJoin == false) {
                                                  uploadFile();
                                                }
                                              }
                                            }
                                          },
                                          child: Text(
                                            'สร้างทีม',
                                            style: Get.textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Get.theme.colorScheme
                                                        .onPrimary),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 222, 72, 249),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text('ลงทะเบียนการแข่งขัน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  Widget SelectAndSearchmember() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('เพิ่มสมาชิก*'),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<User>(
            isExpanded: true,
            hint: Text(
              'เพิ่มสมาชิก...',
              style: Get.textTheme.bodyLarge!,
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.userName,
                        style: Get.textTheme.bodyLarge!,
                      ),
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
            buttonStyleData: ButtonStyleData(
                height: 40,

                // padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Get.theme.colorScheme.primary))),
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
                return (item.value!.userName.toString().contains(searchValue));
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
    );
  }

  Future<void> loadDatas() async {
    startLoading(context);
    try {
      var a = await userService.getUserAll();
      items = a.data;
      log("messageload");
      var b = await attendService.attendByUserID(userID: idUser);
      attends = b.data!;
      // log("asdfasdf  ${attends.first.atId}");

      var r = await raceService.racesByraceID(raceID: idrace);
      races = r.data;
      raceST = races.first.raceTimeSt;
      raceFN = races.first.raceTimeFn;
      // status = b.data.first.status;
      // log("${races.first.raceTimeSt}");
      // log("fin${races.first.raceTimeFn}");
      // for (var i in races) {
      //   log("${i.raceId}");
      // }
      // log("start${raceST}");
      // log("stop${raceFN}");
      // log("id race${races.first.raceId}");
      log("rid${races.first.raceId}");
      log("ST${raceST}");
      log("FN${raceFN}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path!);

    // img = await _cropImage(imageFile: img);
    _image = img;
    setState(() {});
    log(img.path);
  }

  upImg() {
    return _image != null
        ? Stack(
            children: [
              SizedBox(
                width: 250,
                height: 150,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    key: keys,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                          log('message');
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.camera,
                          size: 25,
                        ))),
              )
            ],
          )
        : SizedBox(
            width: 250,
            height: 150,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 5),
                  color: Colors.purpleAccent,
                ),
                key: keys,
                child: IconButton(
                    onPressed: () async {
                      _pickImage(ImageSource.gallery);
                      log('message');
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.camera,
                      size: 30,
                      color: Get.theme.colorScheme.onPrimary,
                    ))),
          );
  }

  Future uploadFile() async {
    startLoading(context);
    if (_image == null) {
      // log("team fail");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาใส่รูปภาพ...')),
      );
      stopLoading();
      return;
    }

    final path = 'files/${_image?.path.split('/').last}';
    final file = File(_image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link:$urlDownload');

    img = urlDownload;

    avata.currentWidget;
    // setState(() {
    //   Image.file(File(pickedFile!.path));
    // });
    log(users.toList().toString());
    TeamDto dto =
        TeamDto(raceId: idrace, teamName: nameTeam.text, teamImage: img);
    var team = await teamService.teams(dto);
    log(idUser.toString());
    AttendDto attendDto = AttendDto(
        lat: 0.1,
        lng: 0.1,
        datetime: attendDateTime,
        userId: idUser,
        teamId: team.data.teamId,
        status: 1);

    var attends = await attendService.attends(attendDto);
    AttendDto attendDto2 = AttendDto(
        lat: 0.1,
        lng: 0.1,
        datetime: attendDateTime,
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
      context.read<AppData>().idUser = idUser;
      context.read<AppData>().attendDateTime = attendDateTime;
      log("attendDateTime Provider = ${context.read<AppData>().attendDateTime}");

      // Get.to(() => Home_join(
      //       navigationController: CircularBottomNavigationController(2),
      //     ));
      stopLoading();

      Get.to(() => Home());
      return;
    } else {
      log("team fail");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('ลงทะเบียนผิดพลาด หรือ เคยลงทะเบียนเข้าร่วมไปแล้ว!!')),
      );
      stopLoading();

      return;
    }
  }

  textField(final TextEditingController controller, String hintText,
      String labelText, String error, bool readON) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(labelText),
        ),
        TextFormField(
          readOnly: readON,
          controller: controller,
          style: Get.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return error;
            }

            return null;
          },
        ),
      ],
    );
  }
}
