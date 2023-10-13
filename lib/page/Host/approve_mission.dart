import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:miniworldapp/page/Host/check_mission_list.dart';
import 'package:miniworldapp/page/Host/list_approve.dart';
import 'package:miniworldapp/service/user.dart';
import 'package:uuid/uuid.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/missionCompDTO.dart';
import 'package:miniworldapp/model/missionComp.dart' as misComp;
import 'package:miniworldapp/model/mission.dart';
import 'package:flutter/rendering.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';

import '../../model/Status/missionCompStatus.dart';
import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../model/user.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class Notpass {
  String masseage;
  Notpass({required this.masseage});
}

class ApproveMission extends StatefulWidget {
  ApproveMission({super.key, required this.IDmc});
  late int IDmc;
  @override
  State<ApproveMission> createState() => _ApproveMissionState();
}

class _ApproveMissionState extends State<ApproveMission> {
  late MissionCompService missionCompService;
  late AttendService attendService;
  late MissionService missionService;
  late UserService userService;
  late List<MissionComplete> missionComp;
  late List<AttendRace> attend;
  late List<Mission> mission;
  late List<User> users;

  late int CompmissionId;
  String dateTime = '';
  int idrace = 0;
  int iduser = 0;
  String onesingnalId = '';

  String type = '';
  String urlImage = '';
  String urlVideo = '';
  String mcText = '';
  String mcName = '';
  String mcDiscrip = '';
  String playerID = '';
  List<String> playerIds = [];
  String hostName = '';
  String userName = '';

  TextEditingController anothor = TextEditingController();
  TextEditingController textMc = TextEditingController();

  int _counter = 0;
  List<Notpass> message = [
    Notpass(masseage: 'ประเภทหลักฐานไม่ถูกต้อง'),
    Notpass(masseage: 'กรุณาใส่ข้อความให้ถูกต้อง'),
    Notpass(masseage: 'กรุณาถ่ายรูปใหม่'),
    Notpass(masseage: 'กรุณาส่งวิดิโอใหม่'),
    Notpass(masseage: 'ภาพไม่ชัดเจน'),
    Notpass(masseage: 'อื่นๆ...')
  ];
  int _selected = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int teamID = 0;
  int misID = 0;
  String teamName = '';
  String masseageMC = '';
  String mctext = '';
  TextEditingController _discritionSpactator = TextEditingController();

  String mcID = '';
  Map<String, dynamic> mc = {};
  Map<String, dynamic> masseageMission = {};

  PlatformFile? pickedFile;

  UploadTask? uploadTask;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  bool isImage = false;

  late Future<void> loadDataMethod;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    var stname;
    if (result == null) return;
    pickedFile = result.files.single;
    //stname = pickedFile.toString()+;
    log(result.files.single.toString());
    log(pickedFile!.extension.toString());
    //upload Image
    if (pickedFile!.extension == 'jpg' || pickedFile!.extension == 'png') {
      setState(() {
        isImage = true;
      });
    }
    //upload video
    else {
      isImage = false;
      videoPlayerController =
          VideoPlayerController.file(File(pickedFile!.path!))
            ..initialize().then((_) {
              log(videoPlayerController.toString());
              //SizedBox(child: ,)
              _customVideoPlayerController = CustomVideoPlayerController(
                context: context,
                videoPlayerController: videoPlayerController!,
              );
              setState(() {});
            });
    }
  }

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    // IDmc = context.read<AppData>().mcID;
    iduser = context.read<AppData>().idUser;
    idrace = context.read<AppData>().idrace;

    //  log('id' + IDmc.toString());
    userService = UserService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      iduser = context.read<AppData>().idUser;
      // log('idddd'+IDmc.toString());
      var a = await missionCompService.missionCompBymcId(mcID: widget.IDmc);

      //var m = await missionService.missionAll();
      var mis = await missionService.missionByraceID(raceID: idrace);

      missionComp = a.data;

      mission = mis.data;

      urlImage = a.data.first.mcPhoto;
      mcText = a.data.first.mcText;
      urlVideo = a.data.first.mcVideo;
      mcName = a.data.first.mission.misName;
      mcDiscrip = a.data.first.mission.misDiscrip;
      teamName = a.data.first.team.teamName;
      teamID = a.data.first.team.teamId;
      misID = a.data.first.mission.misId;

      hostName = mis.data.first.race.user.userName;
      log('tt ' + teamID.toString());

      var at = await attendService.attendByTeamID(teamID: teamID);
      attend = at.data;

      playerIds.clear();
      for (var element in at.data) {
        if(element.user.onesingnalId != ''){
         playerIds.add(element.user.onesingnalId);
      }
        }
        
      log('att ' + playerIds.toString());

      var u = await userService.getUserByID(userID: iduser);
      users = u.data;
      userName = u.data.first.userName;

      // onesingnalId = mis.data.first.race.user.onesingnalId;
      // misName = a.data.first.mission.misName;
      // misDiscrip = a.data.first.mission.misDiscrip;
      // misStatus = a.data.first.mcStatus.toString();
      // misType = a.data.first.mission.misType.toString();
      // mlat = a.data.first.mission.misLat;
      // mlng = a.data.first.mission.misLng;
      // teamID = a.data.first.team.teamId;
      // teamName = a.data.first.team.teamName;
      // log('vdeoooo '+urlVideo);

      videoPlayerController = VideoPlayerController.network(urlVideo)
        ..initialize().then((value) => setState(() {}));
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController!,
      );

      log('type ' + type);
      log(widget.IDmc.toString());
      log('t' + mcName);
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  void checkMisPass() async {
    startLoading(context);
    var deviceState = await OneSignal.shared.getDeviceState();
    log('players ' + playerIds.toString());
    masseageMC = 'ผ่าน';
    MissionCompStatus missionComDto = MissionCompStatus(
        mcMasseage: masseageMC, mcStatus: 2, misId: misID, teamId: teamID);
    //log(lats);
    //print(double.parse('lat'+lats));
    mc = {'notitype': 'checkMis', 'masseage': masseageMC};
    var missionComp = await missionCompService.updateStatusMisCom(
        missionComDto, widget.IDmc.toString());

    var notification1 = OSCreateNotification(
        //playerID
        additionalData: mc,
        playerIds: playerIds,
        content: 'ส่งจากผู้สร้างการแข่งขัน: $hostName',
        heading: "หลักฐานภารกิจ: ผ่าน",
        //  iosAttachments: {"id1",urlImage},
        // bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);

      var response1 = await OneSignal.shared.postNotification(notification1);

     Navigator.of(context).pop();
     

    stopLoading();
    // Navigator.of(context).pop();
  }

  void _CheckMisUnPass() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('ไม่ผ่านเพราะ....'),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    startLoading(context);
                    masseageMC = message[_selected].masseage;
                    MissionCompStatus missionComDto = MissionCompStatus(
                        mcMasseage: masseageMC,
                        mcStatus: 3,
                        misId: misID,
                        teamId: teamID);
                    //log(lats);
                    //print(double.parse('lat'+lats));
                    mc = {'notitype': 'checkUnMis', 'masseage': masseageMC};
                    var missionComp =
                        await missionCompService.updateStatusMisCom(
                            missionComDto, widget.IDmc.toString());

                    var notification1 = OSCreateNotification(
                        //playerID
                        additionalData: mc,
                        playerIds: playerIds,
                        content: 'ส่งจากผู้สร้างการแข่งขัน: $hostName',
                        heading: "หลักฐานภารกิจ: ไม่ผ่าน",
                        //  iosAttachments: {"id1",urlImage},
                        // bigPicture: imUrlString,
                        buttons: [
                          OSActionButton(text: "ตกลง", id: "id1"),
                          OSActionButton(text: "ยกเลิก", id: "id2")
                        ]);

                    var response1 =
                        await OneSignal.shared.postNotification(notification1);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                    stopLoading();
                    
                  },
                  child: Text('ส่ง',
                      style: TextStyle(color: Get.theme.colorScheme.onPrimary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.error,
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                    'ยกเลิก',
                  ),
                  child: Text('ยกเลิก',
                      style: TextStyle(color: Get.theme.colorScheme.onPrimary)),
                ),
              ],
              content: SingleChildScrollView(
                child: StatefulBuilder(builder: (context, setdialog) {
                  return SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Divider(),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: message.length,
                              itemBuilder: (BuildContext context, int index) {
                                return RadioListTile(
                                    title: Text(message[index].masseage),
                                    value: index,
                                    groupValue: _selected,
                                    onChanged: (value) {
                                      setdialog(() {
                                        _selected = index;
                                        log(message[_selected].masseage);
                                      });
                                    });
                              }),
                        ),
                        Divider(),
                        TextFormField(
                          controller: anothor,
                          autofocus: false,
                          maxLines: 1,
                          style: TextStyle(fontSize: 18),
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "อื่นๆ....",
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ));
  }

  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    dateTime = '${now.toIso8601String()}Z';
    return Scaffold(
      appBar: AppBar(
        title: const Text('หลักฐาน'),
      ),
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'ทีม: $teamName',
                        style: Get.textTheme.headlineSmall!.copyWith(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 10),
                      child: Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Get.theme.colorScheme.secondary,
                        ),
                        child: Center(
                          child: Text(mcName,
                              style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35, bottom: 8),
                          child: Text('รายละเอียด',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                          width: Get.width,
                          height: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3,
                                  color: Get.theme.colorScheme.primary),
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(mcDiscrip),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 15),
                          child: Text('หลักฐานที่ส่ง :',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 35, top: 15),
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.amber)),
                            onPressed: () async {
                              dialogSpectator();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidPaperPlane,
                              color: Get.theme.colorScheme.onPrimary,
                              size: 15,
                            ),
                            label: Text(
                              'ส่งภาพให้ผู้ชม',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 8),
                          child: urlImage != ''
                              ? Container(
                                  width: Get.width * 0.7,
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.colorScheme.onPrimary),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(urlImage),
                                      //  fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.rectangle,
                                  ),
                                )
                              : (_customVideoPlayerController != null)
                                  ? SizedBox(
                                      width: Get.width / 1.3,
                                      height: Get.height,
                                      child: CustomVideoPlayer(
                                          customVideoPlayerController:
                                              _customVideoPlayerController!),
                                    )
                                  : Container()),
                    ),
                    mcText != ''
                        ? Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, bottom: 15),
                            child: Container(
                                width: Get.width,
                                height: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: Get.theme.colorScheme.primary),
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(mcText),
                                )),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  startLoading(context);
                                  checkMisPass();
                                  log(playerID.toString());
                                  stopLoading();

                                  // if (pickedFile == null) {

                                  // } else {}
                                },
                                child: Text('ผ่าน',
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                        color: Get.theme.colorScheme.background,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.colorScheme.error,
                                ),
                                onPressed: () {
                                  _CheckMisUnPass();
                                },
                                child: Text('ไม่ผ่าน',
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                        color: Get.theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold))),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> dialogSpectator() async {
    return urlImage != ''
        ? showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext contexts) {
              return AlertDialog(
                title: const Text(
                  'ส่งภาพบรรยากาศให้ผู้ชม?',
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 16.0,
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ยกเลิก'.toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      startLoading(context);
                      types.User _user = types.User(
                          id: iduser.toString(), firstName: userName);
                      //textTeam
                      final message = types.TextMessage(
                        author: _user,
                        id: const Uuid().v4(),
                        text: 'ชื่อทีม:$teamName\n ภารกิจ: $mcName',
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                      );
                      FirebaseFirestore.instance
                          .collection('s' + idrace.toString())
                          .add(message.toJson());
                      log('firebase ' +
                          idrace.toString() +
                          message.toJson().toString());

                      //image
                      log('imageeeeeeee' + urlImage);
                      final httpInput =
                          await HttpInput.createHttpInput(urlImage);

                      final imageMessage = types.ImageMessage(
                        author: _user,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        id: const Uuid().v4(),
                        name: 'image',
                        size: 0,
                        uri: urlImage,
                      );

                      FirebaseFirestore.instance
                          .collection('s' + idrace.toString())
                          .add(imageMessage.toJson());
                      log('firebaseImage ' +
                          idrace.toString() +
                          imageMessage.toJson().toString());

                      //textdisciption
                      final messageDiscription = types.TextMessage(
                        author: _user,
                        id: const Uuid().v4(),
                        text: _discritionSpactator.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                      );
                      if (_discritionSpactator.text != '') {
                        FirebaseFirestore.instance
                            .collection('s' + idrace.toString())
                            .add(messageDiscription.toJson());
                      }
                      Navigator.of(context).pop();
                      stopLoading();
                    
                    },
                    child: Text('ตกลง'.toUpperCase()),
                  ),
                ],
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      urlImage != ''
                          ? Container(
                              width: Get.width / 2,
                              height: Get.height / 4,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.theme.colorScheme.onPrimary),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(urlImage),
                                  //  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                            )
                          : const Center(
                              child: Text('**ส่งได้เฉพาะรูปภาพบรรยากาศ**')),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _discritionSpactator,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: ' คำอธิบาย...',
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Get.theme.colorScheme.primary)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            title: 'ข้อมูลไม่ถูกต้อง',
            desc: 'ส่งได้เฉพาะรูปภาพบรรยากาศเท่านั้น',
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red,
          ).show();
  }
}
