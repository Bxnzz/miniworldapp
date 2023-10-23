import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/model/DTO/missionCompDTO.dart';
import 'package:miniworldapp/model/missionComp.dart' as misComp;
import 'package:miniworldapp/model/mission.dart';
import 'package:flutter/rendering.dart';
import 'package:miniworldapp/page/Player/player_race_start_hint.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.detail.dart';

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStartMis extends StatefulWidget {
  const PlayerRaceStartMis({super.key, required this.controller});
  final PersistentTabController controller;
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
  bool isfd = false;
  bool next = false;
  late Future<void> loadDataMethod;

  File? _image;
  CroppedFile? croppedImage;
  final keys = GlobalKey<FormState>();
  @override
  void initState() {
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
    super.initState();
  }

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    // img = await _cropImage(imageFile: img);
    _image = img;
    croppedImage = await ImageCropper().cropImage(sourcePath: img.path);
    if (croppedImage == null) return null;
    _image = File(croppedImage!.path);
    setState(() {});
  }

  Future _pickVideo(ImageSource source) async {
    final image = await ImagePicker().pickVideo(source: source);

    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    // img = await _cropImage(imageFile: img);
    _image = img;
    setState(() {});
  }

  Future _pickMedia(ImageSource source) async {
    final image = await ImagePicker().pickMedia(imageQuality: 50);

    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    _image = img;
    if (_image!.path.endsWith(".mp4") == true) {
      log("isiamge = $isImage");
      isImage = false;
      log("path ${img.path}");
      videoPlayerController = VideoPlayerController.file(File(_image!.path))
        ..initialize().then((_) {
          log(videoPlayerController.toString());
          //SizedBox(child: ,)
          _customVideoPlayerController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: videoPlayerController!,
          );
          setState(() {});
        });

      return;
    } else {
      log("isiamge = $isImage");

      isImage = true;

      croppedImage = await ImageCropper().cropImage(sourcePath: img.path);
      if (croppedImage == null) return null;
      _image = File(croppedImage!.path);
      // img = await _cropImage(imageFile: img);

      setState(() {});
    }
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
      setState(() {});
    });
  }

  Future<void> loadData() async {
    try {
      log("asdfasdfffffff");
      misID = context.read<AppData>().idMis;
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

      log("asdfasdfasdf${mis3.data.length}");
      onesingnalId = mis2.data.first.race.user.onesingnalId;
      log("onesingnalId ====${onesingnalId}");
      misName = mis3.data.first.misName;
      misDiscrip = mis3.data.first.misDiscrip;
      misType = mis3.data.first.misType.toString();
      log("misID COMP" + misID.toString());
      log("provider=  " + context.read<AppData>().misID.toString());
      missionComp.map((e) {
        if (e.misId == context.read<AppData>().idMis && e.mcStatus == 2) {
          log("Set 0");
          context.read<AppData>().idMis = 0;
          misID = 0;
        }
      }).toList();

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
      body: FutureBuilder(
        future: loadData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            missionShow = [];

            for (int i = 0; i < missions.length; i++) {
              log("message");
              log("i" + i.toString());
              // if (i == 0) {
              //   missionShow.add(missions[0]);
              // }

              for (int j = 0; j < missionComp.length; j++) {
                if (missionComp[j].misId == missions[i].misId &&
                    missionComp[j].mcStatus == 2) {
                  log("pass ${missions[i].misId}");
                  // log("next ${missions[i + 1].misId}");

                  missionShow.add(missions[i]);
                  if (i + 1 > missions.length - 1) {
                    lastmisComp = true;
                    log("lastmis = $lastmisComp");
                    // showAlertDialog();
                  }
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
                }
              }
            }

            return RefreshIndicator(
              onRefresh: refresh,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  mission_pass_timeline(),
                  lastmisComp == false
                      ? context.read<AppData>().idMis == 0
                          ? mission_wait_timeline()
                          : mission_find_timeline()
                      : mission_finish_timeline()
                ]),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Column mission_pass_timeline() {
    return Column(
        children: missionShow.map((e) {
      if (missionShow.indexOf(e) == 0) {
        isfd = true;
      } else {
        isfd = false;
      }

      return GestureDetector(
        onTap: () {},
        child: TimelineTile(
          isFirst: isfd,
          alignment: TimelineAlign.start,
          beforeLineStyle: LineStyle(
            thickness: 8,
          ),
          afterLineStyle: LineStyle(
            thickness: 8,
          ),
          indicatorStyle: IndicatorStyle(
              width: 40,
              height: 40,
              color: Colors.white,
              iconStyle: IconStyle(
                color: Colors.green,
                iconData: Icons.check_circle,
              )),
          endChild: Container(
            height: 100,
            padding: EdgeInsets.only(
              left: 25,
            ),
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.purple),
            child: Text(
              "${e.misName}\n:${e.misDiscrip}",
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      );
    }).toList());
  }

  TimelineTile mission_wait_timeline() {
    return TimelineTile(
      isLast: true,
      beforeLineStyle: LineStyle(
        thickness: 8,
      ),
      afterLineStyle: LineStyle(
        thickness: 8,
      ),
      indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: Colors.white,
          iconStyle: IconStyle(
            color: Colors.red,
            iconData: Icons.question_mark,
          )),
      alignment: TimelineAlign.start,
      endChild: Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.only(top: 25, bottom: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey),
        child: Text(
          "ค้นหาภารกิจ!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  TimelineTile mission_find_timeline() {
    return TimelineTile(
        isLast: true,
        beforeLineStyle: LineStyle(
          thickness: 8,
        ),
        afterLineStyle: LineStyle(
          thickness: 8,
        ),
        indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            color: Colors.white,
            iconStyle: IconStyle(
              color: Colors.red,
              iconData: Icons.gps_fixed_rounded,
            )),
        alignment: TimelineAlign.start,
        endChild: Container(
          height: 100,
          child: AnimatedButton(
            borderRadius: BorderRadius.circular(10),
            pressEvent: () {
              Get.to(() => PlayerRaceStMisDetail(), fullscreenDialog: true);
              // dialogShow();
            },
            text: "$misName (กำลังทำ)",
            buttonTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
            color: Colors.amber,
          ),
        ));
  }

  Future<dynamic> dialogShow() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text("$misName")),
        content: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  _image != null
                      ? isImage == true
                          ? Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.white, width: 5),
                              ),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ))
                          : CustomVideoPlayer(
                              customVideoPlayerController:
                                  _customVideoPlayerController!)
                      : Container(),
                  misType.contains('2')
                      ? Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                    onPressed: () async {
                                      await _pickImage(ImageSource.camera);
                                      setState(() {});
                                      log('message');
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: 25,
                                    ))),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                    onPressed: () async {
                                      await _pickVideo(ImageSource.camera);
                                      setState(() {});
                                      log('message');
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.video,
                                      size: 25,
                                    ))),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                    onPressed: () async {
                                      await _pickMedia(ImageSource.gallery);
                                      setState(() {});
                                      log('message');
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.photoFilm,
                                      size: 25,
                                    ))),
                          ],
                        )
                      : Positioned(
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
                        ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () async {},
              child: const Text('สำเร็จ'),
            ),
          ),
        ],
      ),
    );
  }

  TimelineTile mission_finish_timeline() {
    return TimelineTile(
      isLast: true,
      beforeLineStyle: LineStyle(
        thickness: 8,
      ),
      afterLineStyle: LineStyle(
        thickness: 8,
      ),
      indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: Colors.white,
          iconStyle: IconStyle(
            color: Colors.green,
            iconData: Icons.check_circle,
          )),
      alignment: TimelineAlign.start,
      endChild: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.green),
          child: const Row(
            children: [
              Text(
                "ภารกิจเสร็จสิ้น",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          )),
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
      // Container(
      //     constraints: const BoxConstraints(maxHeight: 700),
      //     color: Colors.white,
      //     child: TimelineTile(
      //       alignment: TimelineAlign.end,
      //       startChild: Container(
      //         color: Colors.amberAccent,
      //       ),
      //       endChild: Container(
      //         constraints: const BoxConstraints(
      //           minHeight: 120,
      //         ),
      //         color: Colors.lightGreenAccent,
      //       ),
      //     )),
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
