import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
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
import '../../service/provider/appdata.dart';

class PlayerRaceStartMis extends StatefulWidget {
  const PlayerRaceStartMis({super.key});

  @override
  State<PlayerRaceStartMis> createState() => _PlayerRaceStartMisState();
}

class _PlayerRaceStartMisState extends State<PlayerRaceStartMis> {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late List<misComp.MissionComplete> missionComp;
  late List<Mission> mission;
  late int IDteam;
  late int CompmissionId;
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

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  bool isImage = false;

  late Future<void> loadDataMethod;

  Future uploadFile() async {
    startLoading(context);
    final path = 'files/${pickedFile!.name}';

    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    log('Download Link:$urlDownload');

    if (isImage == true) {
      //update image
      MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse("2002-03-14T00:00:00Z"),
          mcLat: 16.5,
          mcLng: 15.5,
          mcMasseage: '',
          mcPhoto: urlDownload,
          mcStatus: 2,
          mcText: '',
          mcVideo: '',
          misId:  6,
          teamId: 103);
      var missionComp = await missionCompService.insertMissionComps(mdto);
      missionComp.data.misId.toString();
      log('img '+missionComp.data.misId.toString());
    } else {
      //update video
       MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse("2002-03-14T00:00:00Z"),
          mcLat: 16.5,
          mcLng: 15.5,
          mcMasseage: '',
          mcPhoto: '',
          mcStatus: 2,
          mcText: '',
          mcVideo: urlDownload,
          misId:  6,
          teamId: 103);
      var missionComp = await missionCompService.insertMissionComps(mdto);
      missionComp.data.misId.toString();
      log('video '+missionComp.data.misId.toString());
    }
    stopLoading();

    // videoPlayerController = VideoPlayerController.file(File(pickedFile!.path!))
    //   ..initialize().then((_) {
    //     log(videoPlayerController.toString());
    //     _customVideoPlayerController = CustomVideoPlayerController(
    //       context: context,
    //       videoPlayerController: videoPlayerController!,
    //     );
    //     Image.file(File(pickedFile!.path!));
    //     setState(() {});
    //   });
  }

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
    IDteam = context.read<AppData>().idTeam;
    idrace = context.read<AppData>().idrace;
    log('id' + idrace.toString());
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    try {
      var a = await missionCompService.missionCompByTeamId(teamID: IDteam);
      var m = await missionService.missionAll();
      var mis = await missionService.missionByraceID(raceID: idrace);

      missionComp = a.data;
      mission = m.data;
      mission = mis.data;
      onesingnalId = mis.data.first.race.user.onesingnalId;
      misName = a.data.first.mission.misName;
      misDiscrip = a.data.first.mission.misDiscrip;
      misStatus = a.data.first.mcStatus.toString();
      misType = a.data.first.mission.misType.toString();

      var splitT = misType.split('');
      // log(splitT.toString());
      List<String> substrings = splitT.toString().split(",");
      //substrings = splitT.toString().substring("[");
      // log('sub ' + splitT.contains('0').toString());
      log(misType);
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
      log(IDteam.toString());
    } catch (err) {
      log('Error:$err');
    }
  }

  void _handleSendNotification() async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;

    var imUrlString =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNoy-7N8x4HgYJQuQC3i7SW8nj9EaWzrvhRw&usqp=CAU";

    var notification1 = OSCreateNotification(
        //playerID

        playerIds: [
          onesingnalId,
          //'572cf68a-afae-4763-8c2d-6f882966e795'
          // 'b8742e68-2547-4cca-90a0-d1561a5654cc', //a11
          // '850c1971-dd33-4af0-bbea-71efe3ff9814', //j7
          // '037f084d-7ed0-466f-9f5d-012f60789829', //a9
          // '2e395e43-98f9-45fb-82d4-dfc3cd90434d', //s13
        ],
        content: "โหลๆๆ",
        heading: "Test Notification❤ :)",
        iosAttachments: {"id1": imUrlString},
        bigPicture: imUrlString,
        buttons: [
          OSActionButton(text: "ตกลง", id: "id1"),
          OSActionButton(text: "ยกเลิก", id: "id2")
        ]);

    var response1 = await OneSignal.shared.postNotification(notification1);
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId("9670ea63-3a61-488a-afcf-8e1be833f631");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            for (int i = 0; i < mission.length; i++) {
              for (int j = 0; j < missionComp.length; j++) {
                if (missionComp[j].mcStatus == 2) {
                  log("message${missionComp[j].mcStatus}");
                }
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: Card(
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          misName,
                          style: Get.textTheme.headlineSmall!.copyWith(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold),
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
                            padding:
                                const EdgeInsets.only(right: 35, bottom: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: CircleBorder(), //<-- SEE HERE
                                padding: EdgeInsets.all(20),
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
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isImage == true
                                        ? Image.file(
                                            File(pickedFile!.path!),
                                            width: Get.width * 0.3,
                                          )
                                        : (_customVideoPlayerController != null)
                                            ? CustomVideoPlayer(
                                                customVideoPlayerController:
                                                    _customVideoPlayerController!)
                                            : Container(
                                                child:
                                                    Text("กรุณาเลือกไฟล์อื่น"),
                                              ),
                                    //Text(pickedFile!.name),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      // buildProgress(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Get.theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                _handleSendNotification();
                                uploadFile();
                              },
                              child: Text('ส่งหลักฐาน',
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                      color: Get.theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold))),
                        ),
                      )
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

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });
}
