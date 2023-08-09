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

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStartMis extends StatefulWidget {
  const PlayerRaceStartMis({super.key});

  @override
  State<PlayerRaceStartMis> createState() => _PlayerRaceStartMisState();
}

class _PlayerRaceStartMisState extends State<PlayerRaceStartMis> {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late List<MissionComplete> missionComp;

  late List<Mission> missions;
  //late List<Mission> mission;
  List<Mission> missionShow = [];
  List<String> typeMisShow = [];
  List typeShow = [];
  late int CompmissionId;
  late int misID;
  int idrace = 0;
  String onesingnalId = '';
  String misName = '';
  String misDiscrip = '';
  String misStatus = '';
  String misSeq = '';
  String misType = '';
  String type = '';

  String urlImage = '';
  String urlVideo = '';
  double mlat = 0.1;
  double mlng = 0.1;
  int mID = 0;
  int teamID = 0;
  String dateTime = '';
  String teamName = '';
  String _colorName = 'No';
  Color _color = Colors.black;
  String mcID = '';
  Map<String, dynamic> mc = {};
  File? pickedFile;

  UploadTask? uploadTask;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  TextEditingController answerPass = TextEditingController();
  bool isImage = false;
  bool lastmisComp = false;
  double lat = 0.0;
  double lng = 0.0;
  int misDistance = 0;
  String misDescrip = "";

  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    teamID = context.read<AppData>().idTeam;
    idrace = context.read<AppData>().idrace;
    misID = context.read<AppData>().idMis;
    log('id' + idrace.toString());
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    File file;
    PlatformFile platFile;
    var stname;

    setState(() {
      if (result == null) return;
      platFile = result.files.single;
      file = File(platFile.path!);
      pickedFile = file;
      //stname = pickedFile.toString()+;
      log(result.files.single.toString());
      log(platFile.extension.toString());

      //selectFile Image
      if (platFile.extension == 'jpg' ||
          platFile.extension == 'png' ||
          platFile.extension == 'jpeg') {
        isImage = true;
      }
      //selectFile video
      else {
        isImage = false;
        videoPlayerController =
            VideoPlayerController.file(File(pickedFile!.path))
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
    });
  }

  Future<void> loadData() async {
    try {
      var a = await missionCompService.missionCompByTeamId(teamID: teamID);
      log("idteam ====${teamID}");
      //  var mis = await missionService.missionByraceID(raceID: idrace);
      var mis2 = await missionService.missionByraceID(raceID: idrace);

      var mis3 = await missionService.missionBymisID(misID: misID);
      //var mc = await missionCompService.missionCompBymisId(misID: misID);
      log("misID ====${misID}");
      //log("${mc.data.length}");
      missionComp = a.data;
      missions = mis2.data;

      log("asdfasdfasdf${missionComp.first.mcId}");
      onesingnalId = mis2.data.first.race.user.onesingnalId;
      log("onesingnalId ====${onesingnalId}");
      misName = mis3.data.first.misName;
      misDiscrip = mis3.data.first.misDiscrip;
      misType = mis3.data.first.misType.toString();

      // misStatus = a.data.first.mcStatus.toString();
      // mlat = a.data.first.mission.misLat;
      // mlng = a.data.first.mission.misLng;
      // teamID = a.data.first.team.teamId;
      // teamName = a.data.first.team.teamName;

      //   mID = a.data.first.mission.misId;

      var splitT = misType.split('');
      // log(splitT.toString());
      List<String> substrings = splitT.toString().split(",");
      //substrings = splitT.toString().substring("[");
      // log('sub ' + splitT.contains('0').toString());

      if (misType.contains('12')) {
        type = 'ข้อความ,สื่อ';
      } else if (misType.contains('1')) {
        type = 'ข้อความ';
      } else if (misType.contains('2')) {
        type = 'สื่อ';
      } else if (misType.contains('3')) {
        type = 'ไม่มีการส่ง';
      } else {
        return;
      }

      // CompmissionId = a.data;
      log('one $onesingnalId');

      log('name ' + misName);
      log('type ' + type);
      log(teamID.toString());
    } catch (err) {
      log('Error:$err');
    }
  }

  Future uploadFile() async {
    startLoading(context);
    var deviceState = await OneSignal.shared.getDeviceState();
    final now = DateTime.now();
    dateTime = '${now.toIso8601String()}Z';
    // log(dateTime);
    //final berlinWallFell = DateTime.utc(now);

    final path = 'files/${pickedFile?.path.split('/').last}';

    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    log('Download Link:$urlDownload');
    log('mid ' + mlat.toString());

    if (isImage == true) {
      //update image
      MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse(dateTime),
          mcLat: mlat,
          mcLng: mlng,
          mcMasseage: '',
          mcPhoto: urlDownload,
          mcStatus: 1,
          mcText: answerPass.text,
          mcVideo: '',
          misId: misID,
          teamId: teamID);
      debugPrint(missionCompDtoToJson(mdto));
      var missionComp = await missionCompService.insertMissionComps(mdto);

      missionComp.data;
      mcID = missionComp.data.mcId.toString();

      mc = {'notitype': 'mission', 'mcid': mcID, 'mission': misName};
      log('img ${missionComp.data.misId}');
    } else {
      //update video
      MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse(dateTime),
          mcLat: mlat,
          mcLng: mlng,
          mcMasseage: '',
          mcPhoto: '',
          mcStatus: 1,
          mcText: answerPass.text,
          mcVideo: urlDownload,
          misId: misID,
          teamId: teamID);
      var missionComp = await missionCompService.insertMissionComps(mdto);
      mcID = missionComp.data.mcId.toString();

      mc = {'notitype': 'mission', 'mcid': mcID, 'mission': misName};
      log('mcc$mc');
      log('one $onesingnalId');
    }
    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var notification1 = OSCreateNotification(
        //playerID
        additionalData: mc,
        playerIds: [
          onesingnalId,

          //'9556bafc-c68e-4ef2-a469-2a4b61d09168',
        ],
        content: 'ส่งจากทีม: $teamName',
        heading: "หลักฐานภารกิจ: $misName",
        //  iosAttachments: {"id1",urlImage},
        // bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);

    var response1 = await OneSignal.shared.postNotification(notification1);
    stopLoading();
    Get.defaultDialog(title: mc.toString());
  }

  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              missionShow = [];
              // String misId = '';
              // List<MissionComplete> temp = [];
              // for (var i = 0; i < missionComp.length; i++) {
              //   if (missionComp[i].mcStatus != 2) {
              //     if (temp.isNotEmpty) {
              //       var mission = {misId: temp};
              //       missionShow.add(mission);
              //       temp = [];
              //     }
              //     misId = missions[i].misId.toString();
              //   }

              //   temp.add(missionComp[i]);
              // }
              // if (temp.isNotEmpty) {
              //   var mission = {misId: temp};
              //   missionShow.add(mission);
              // }
              // log(missionShow.toString());
              for (int i = 0; i < missions.length; i++) {
                log("message");
                //first mis
                // if (i == 0) {
                //   log("first Mis");
                //   lat = missions[0].misLat;
                //   lng = missions[0].misLng;

                //   misID = missions[0].misId;
                //   misName = missions[0].misName;
                //   misDistance = missions[0].misDistance;
                //   misDescrip = missions[0].misDiscrip;
                //   misType = missions[0].misType.toString();
                //   if (misType.contains('12')) {
                //     type = 'ข้อความ,สื่อ';
                //   }
                //   if (misType.contains('1')) {
                //     type = 'ข้อความ';
                //   } else if (misType.contains('2')) {
                //     type = 'สื่อ';
                //   } else if (misType.contains('3')) {
                //     type = 'ไม่มีการส่ง';
                //   }
                // }

                for (int j = 0; j < missionComp.length; j++) {
                  if (missionComp[j].misId == missions[i].misId &&
                      missionComp[j].mcStatus == 2) {
                    log("pass ${missions[i].misId}");
                    missionShow.add(missions[i]);

                    for (int k = 0; k < missionShow.length; k++) {
                      typeMisShow.add(missionShow[k].misType.toString());

                      if (missionShow[k].misType.toString().contains('12')) {
                        typeMisShow[k] = 'ข้อความ,สื่อ';
                      }
                      if (missionShow[k].misType.toString().contains('1')) {
                        typeMisShow[k] = 'ข้อความ';
                      } else if (missionShow[k]
                          .misType
                          .toString()
                          .contains('2')) {
                        typeMisShow[k] = 'สื่อ';
                      } else if (missionShow[k]
                          .misType
                          .toString()
                          .contains('3')) {
                        typeMisShow[k] = 'ไม่มีการส่ง';
                      }
                    }

                    log("MissionShow :$missionShow");
                  } else {
                    if (i + 1 > missions.length - 1) {
                      log("next ${missions[i].misId}");

                      lastmisComp = true;
                      // showAlertDialog();
                    }
                    //else {
                    //   log("next ${missions[i + 1].misId}");
                    //   log("lat lng${missions[i + 1].misLat}${missions[i + 1].misLng}");

                    //   lat = missions[i + 1].misLat;
                    //   lng = missions[i + 1].misLng;

                    //   log("lat $lat");
                    //   log("lng $lng");
                    //   misID = missions[i + 1].misId;
                    //   misName = missions[i + 1].misName;
                    //   misDistance = missions[i + 1].misDistance;
                    //   misDescrip = missions[i + 1].misDiscrip;
                    //   misType = missions[i + 1].misType.toString();
                    //   if (misType.contains('12')) {
                    //     type = 'ข้อความ,สื่อ';
                    //   }
                    //   if (misType.contains('1')) {
                    //     type = 'ข้อความ';
                    //   } else if (misType.contains('2')) {
                    //     type = 'สื่อ';
                    //   } else if (misType.contains('3')) {
                    //     type = 'ไม่มีการส่ง';
                    //   }

                    //   log("mis id = ${misID}");
                    //   log("distance = ${misDistance}");
                    //   // if (i == mission.length) {
                    //   //   log("message");
                    //   // }
                    // }
                  }
                }
              }

              return ListView(children: [
                Container(height: 300, width: Get.width, child: misPass()),
                Container(height: 500, width: Get.width, child: misfind()),
              ]);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  ListView misPass() {
    return ListView.builder(
      itemCount: missionShow.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  missionShow[index].misName,
                  style: Get.textTheme.headlineSmall!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            children: [
              ListTile(
                title: Column(
                  children: [
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(missionShow[index].misDiscrip),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 8),
                          child: Text('ประเภท',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35, bottom: 8),
                          child: Container(
                            height: 35,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Get.theme.colorScheme.secondary,
                            ),
                            child: Center(
                              child: Text(typeMisShow[index],
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                      color: Get.theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 35, bottom: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: CircleBorder(), //<-- SEE HERE
                              padding: EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              selectFile();
                            },
                            child: FaIcon(
                              //<-- SEE HERE
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                    pickedFile != null
                        ? isImage == true
                            ? SizedBox(
                                width: Get.width / 3,
                                height: Get.height / 3,
                                child: GestureDetector(
                                  child: Image.file(
                                    (pickedFile!),
                                    width: Get.width / 2,
                                    height: Get.height / 2,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: Get.width,
                                height: Get.height / 3,
                                child: CustomVideoPlayer(
                                    customVideoPlayerController:
                                        _customVideoPlayerController!),
                              )
                        : Text("ยังไม่ได้เพิ่มไฟล์"),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                      child: TextField(
                        controller: answerPass,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              //  _handleSendNotification();
                              if (pickedFile == null) {
                                Get.defaultDialog(title: 'กรุณาเลือกหลักฐาน');
                              } else {
                                setState(() {
                                  uploadFile();
                                });
                              }
                            },
                            child: Text('ส่งหลักฐาน',
                                style: Get.textTheme.bodyLarge!.copyWith(
                                    color: Get.theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              )
            ]);
      },
    );
  }

  ListView misfind() {
    return ListView(children: [
      ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            misName + "(กำลังทำ)",
            style: Get.textTheme.headlineSmall!.copyWith(
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                              width: 3, color: Get.theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(misDiscrip),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35, top: 8),
                      child: Text('ประเภท',
                          style: Get.textTheme.bodyMedium!.copyWith(
                              color: Get.theme.colorScheme.onBackground,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35, bottom: 8),
                      child: Container(
                        height: 35,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Get.theme.colorScheme.secondary,
                        ),
                        child: Center(
                          child: Text(type,
                              style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35, bottom: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: CircleBorder(), //<-- SEE HERE
                          padding: EdgeInsets.all(15),
                        ),
                        onPressed: () {
                          selectFile();
                        },
                        child: FaIcon(
                          //<-- SEE HERE
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    )
                  ],
                ),

                pickedFile != null
                    ? isImage == true
                        ? SizedBox(
                            width: Get.width / 3,
                            height: Get.height / 3,
                            child: GestureDetector(
                              child: Image.file(
                                (pickedFile!),
                                width: Get.width / 2,
                                height: Get.height / 2,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: Get.width,
                            height: Get.height / 3,
                            child: CustomVideoPlayer(
                                customVideoPlayerController:
                                    _customVideoPlayerController!),
                          )
                    : Text("ยังไม่ได้เพิ่มไฟล์"),

                // buildProgress(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                  child: TextField(
                    controller: answerPass,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: ' คำอธิบาย...',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: Get.theme.colorScheme.primary)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          //  _handleSendNotification();
                          if (pickedFile == null) {
                            Get.defaultDialog(title: 'กรุณาเลือกหลักฐาน');
                          } else {
                            setState(() {
                              uploadFile();
                            });
                          }
                        },
                        child: Text('ส่งหลักฐาน',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold))),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ]);
  }
}
