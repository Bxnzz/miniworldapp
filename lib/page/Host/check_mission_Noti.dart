import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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

import '../../model/Status/missionCompStatus.dart';
import '../../model/mission.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class Notpass {
  String masseage;
  Notpass({required this.masseage});
}

class CheckMisNoti extends StatefulWidget {
  CheckMisNoti({super.key, required this.IDmc});
  late int IDmc;
  @override
  State<CheckMisNoti> createState() => _CheckMisNotiState();
}

class _CheckMisNotiState extends State<CheckMisNoti> {
  late MissionCompService missionCompService;
  late AttendService attendService;
  late MissionService missionService;
  late List<misComp.MissionComplete> missionComp;
  late List<AttendRace> attend;
  late List<Mission> mission;

  late int CompmissionId;
  String dateTime = '';
  int idrace = 0;
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

  int _counter = 0;
  List<Notpass> message = [
    Notpass(masseage: 'ประเภทหลักฐานไม่ถูกต้อง'),
    Notpass(masseage: 'กรุณาใส่ข้อความให้ถูกต้อง'),
    Notpass(masseage: 'กรุณาถ่ายรูปใหม่'),
    Notpass(masseage: 'กรุณาส่งวิดิโอใหม่'),
    Notpass(masseage: 'ภาพไม่ชัดเจน'),
    Notpass(masseage: 'อื่น...')
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
    idrace = context.read<AppData>().idrace;

    //  log('id' + IDmc.toString());
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
      playerIds.clear() ;
      for (var element in at.data) {
        playerIds.add(element.user.onesingnalId);
      }
      log('att ' + playerIds.toString());

      // onesingnalId = mis.data.first.race.user.onesingnalId;
      // misName = a.data.first.mission.misName;
      // misDiscrip = a.data.first.mission.misDiscrip;
      // misStatus = a.data.first.mcStatus.toString();
      // misType = a.data.first.mission.misType.toString();
      // mlat = a.data.first.mission.misLat;
      // mlng = a.data.first.mission.misLng;
      // teamID = a.data.first.team.teamId;
      // teamName = a.data.first.team.teamName;

      videoPlayerController = VideoPlayerController.network(urlVideo)
        ..initialize().then((value) => setState(() {}));
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController!,
      );

      log('type ' + type);
      log(widget.IDmc.toString());
      log('t' + mcName);
      stopLoading();
    } catch (err) {
      log('Error:$err');
    }
  }

  void _CheckMisPass() async {
    //var deviceState = await OneSignal.shared.getDeviceState();

    MissionCompStatus missionComDto = MissionCompStatus(
        mcMasseage: 'ผ่าน', mcStatus: 1, misId: misID, teamId: teamID);
    //log(lats);
    //print(double.parse('lat'+lats));
    mc = {'notitype':'checkMis','mcid':mcID};
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
  }

  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    dateTime = '${now.toIso8601String()}Z';
    return Scaffold(
      appBar: AppBar(title: Text('ตรวจสอบหลักฐาน')),
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: Card(
                child: InkWell(
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
                          width: 100,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 15),
                            child: Text('หลักฐานที่ส่ง :',
                                style: Get.textTheme.bodyMedium!.copyWith(
                                    color: Get.theme.colorScheme.onBackground,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 35),
                            child: urlImage != ''
                                ? Container(
                                    width: Get.width * 0.7,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Get.theme.colorScheme.onPrimary),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(urlImage),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: BoxShape.rectangle,
                                    ),
                                  )
                                : (_customVideoPlayerController != null)
                                    ? CustomVideoPlayer(
                                        customVideoPlayerController:
                                            _customVideoPlayerController!)
                                    : mcText != null
                                        ? Container(
                                            width: Get.width,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color: Get.theme.colorScheme
                                                        .primary),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.white),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Text(mcText),
                                            ))
                                        : Container()),
                      ),

                      // pickedFile != null
                      //  Expanded(
                      //     child: isImage == true
                      //         ? Image.file(
                      //             File(urlImage),
                      //             width: Get.width * 0.3,
                      //           )
                      //         : (_customVideoPlayerController != null)
                      //             ? CustomVideoPlayer(
                      //                 customVideoPlayerController:
                      //                     _customVideoPlayerController!)
                      //             : Container(
                      //                 child: Text("กรุณาเลือกไฟล์อื่น"),
                      //               ),
                      //   ),
                      //: Container(),
                      // buildProgress(),
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
                                    _CheckMisPass();
                                    log(playerID.toString());

                                    // if (pickedFile == null) {
                                    //   Get.defaultDialog(
                                    //       title: 'กรุณาเลือกหลักฐาน');
                                    // } else {}
                                  },
                                  child: Text('ผ่าน',
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.background,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Get.theme.colorScheme.error,
                                  ),
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text('ไม่ผ่านเพราะ....'),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () => Navigator.pop(
                                                    context, 'ส่ง'),
                                                child: Text('ส่ง',
                                                    style: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimary)),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Get
                                                      .theme.colorScheme.error,
                                                ),
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  'ยกเลิก',
                                                ),
                                                child: Text('ยกเลิก',
                                                    style: TextStyle(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onPrimary)),
                                              ),
                                            ],
                                            content: SingleChildScrollView(
                                              child: StatefulBuilder(builder:
                                                  (context, setdialog) {
                                                return Container(
                                                  width: double.maxFinite,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Divider(),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.4,
                                                        ),
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                message.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return RadioListTile(
                                                                  title: Text(message[
                                                                          index]
                                                                      .masseage),
                                                                  value: index,
                                                                  groupValue:
                                                                      _selected,
                                                                  onChanged:
                                                                      (value) {
                                                                    setdialog(
                                                                        () {
                                                                      _selected =
                                                                          index;
                                                                      log(_selected
                                                                          .toString());
                                                                    });
                                                                  });
                                                            }),
                                                      ),
                                                      Divider(),
                                                      TextField(
                                                        autofocus: false,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                        decoration:
                                                            new InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "อื่นๆ....",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                          )),
                                  child: Text('ไม่ผ่าน',
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold))),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
}
