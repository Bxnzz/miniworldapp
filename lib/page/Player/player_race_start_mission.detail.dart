import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/missionCompDTO.dart';
import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStMisDetail extends StatefulWidget {
  const PlayerRaceStMisDetail({super.key});

  @override
  State<PlayerRaceStMisDetail> createState() => _PlayerRaceStMisDetailState();
}

class _PlayerRaceStMisDetailState extends State<PlayerRaceStMisDetail> {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late AttendService _attendService;
  late Future loadDataMethod;

  List<MissionComplete> missionComp = [];
  List<Mission> missions = [];
  List<Mission> missionbyID = [];

  Map<String, dynamic> mc = {};
  TextEditingController answerPass = TextEditingController();

  String onesingnalId = '';
  String misName = '';
  String misDiscrip = '';
  String misType = '';
  String type = '';
  String misMediaUrl = '';
  String dateTime = '';
  String mcID = '';
  String teamName = '';
  String vedioProcess = '';

  int teamID = 0;
  int idrace = 0;
  int misID = 0;

  double latDevice = 0.0;
  double lngDevice = 0.0;
  bool isImage = true;
  bool isSubmit = true;
  String imageInProcess = '';

  File? _image;
  CroppedFile? croppedImage;
  VideoPlayerController? videoPlayerController;

  VideoPlayerController? videoPlayerControllerInProcess;

  CustomVideoPlayerController? _customVideoPlayerController;

  CustomVideoPlayerController? _customVideoPlayerControllerInProcess;

  UploadTask? uploadTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    teamID = context.read<AppData>().idTeam;
    idrace = context.read<AppData>().idrace;
    misID = context.read<AppData>().idMis;
    latDevice = context.read<AppData>().latMiscomp;
    lngDevice = context.read<AppData>().lngMiscomp;
    log('id' + idrace.toString());
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    _attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      misID = context.read<AppData>().idMis;
      var a = await missionCompService.missionCompByTeamId(teamID: teamID);
      log("idteam ====${teamID}");
      //  var mis = await missionService.missionByraceID(raceID: idrace);
      var mis2 = await missionService.missionByraceID(raceID: idrace);
      var teambyid = await _attendService.attendByTeamID(teamID: teamID);
      teamName = teambyid.data.first.team.teamName;

      var mis3 = await missionService.missionBymisID(misID: misID);
      //var mc = await missionCompService.missionCompBymisId(misID: misID);
      log("misID ====${misID}");
      //log("${mc.data.length}");
      missionComp = a.data;
      missions = mis2.data;
      missionbyID = mis3.data;

      log("LENTH OF MISSION${mis3.data.length}");
      onesingnalId = mis2.data.first.race.user.onesingnalId;
      log("onesingnalId ====${onesingnalId}");
      misName = mis3.data.first.misName;
      log("misName =$misName");
      misDiscrip = mis3.data.first.misDiscrip;
      log("misDiscrip =$misDiscrip");
      misType = mis3.data.first.misType.toString();
      log("misType =$misType");

      misMediaUrl = missionbyID.first.misMediaUrl;

      if (misType.contains('12')) {
        type = 'ข้อความ,สื่อ';
      } else if (misType.contains('1')) {
        type = 'ข้อความ';
      } else if (misType.contains('2')) {
        type = 'รูป,คลิป';
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
      log("latdevice = $latDevice");
      log("lngdevice = $lngDevice");

      missionComp.map((e) async {
        if (e.misId == misID && e.mcStatus == 1) {
          isSubmit = false;
          imageInProcess = e.mcPhoto;
          vedioProcess = e.mcVideo;
          log("mc photo " + imageInProcess.toString());
          videoPlayerControllerInProcess = VideoPlayerController.network(
            vedioProcess,
          )..initialize().then((_) {
              _customVideoPlayerControllerInProcess =
                  CustomVideoPlayerController(
                      context: context,
                      videoPlayerController: videoPlayerControllerInProcess!,
                      customVideoPlayerSettings:
                          CustomVideoPlayerSettings(autoFadeOutControls: true));
              setState(() {});
            });
        }
      }).toList();
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    isImage = true;
    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    // img = await _cropImage(imageFile: img);
    _image = img;
    croppedImage = await ImageCropper().cropImage(sourcePath: img.path);
    if (croppedImage == null) return null;
    _image = File(croppedImage!.path);

    log("$_image");
    setState(() {});
  }

  Future _pickVideo(ImageSource source) async {
    final image = await ImagePicker().pickVideo(source: source);
    isImage = false;
    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    _image = img;
    videoPlayerController = VideoPlayerController.file(File(_image!.path))
      ..initialize().then((_) {
        log(videoPlayerController.toString());
        //SizedBox(child: ,)
        _customVideoPlayerController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: videoPlayerController!,
            customVideoPlayerSettings:
                CustomVideoPlayerSettings(autoFadeOutControls: true));
        setState(() {});
      });

    setState(() {});
  }

  Future _pickMedia(ImageSource source) async {
    final image = await ImagePicker().pickMedia(imageQuality: 50);

    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    _image = img;
    if (img!.path.endsWith(".mp4") == true) {
      log("isiamge = $isImage");
      isImage = false;
      log("path ${img.path}");
      videoPlayerController = VideoPlayerController.file(File(img!.path))
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

  Future uploadFile() async {
    startLoading(context);
    var deviceState = await OneSignal.shared.getDeviceState();
    final now = DateTime.now();
    dateTime = '${now.toIso8601String()}Z';
    // log(dateTime);
    //final berlinWallFell = DateTime.utc(now);

    final path = 'files/${_image?.path.split('/').last}';

    final file = File(_image!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    log('Download Link:$urlDownload');
    log('mid ' + latDevice.toString());

    if (isImage == true) {
      //update image
      MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse(dateTime),
          mcLat: latDevice,
          mcLng: lngDevice,
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

      mc = {
        'notitype': 'mission',
        'mcid': mcID,
        'mission': misName,
        'team': teamName
      };
      log('img ${missionComp.data.misId}');
    } else {
      //update video
      MissionCompDto mdto = MissionCompDto(
          mcDatetime: DateTime.parse(dateTime),
          mcLat: latDevice,
          mcLng: lngDevice,
          mcMasseage: '',
          mcPhoto: '',
          mcStatus: 1,
          mcText: answerPass.text,
          mcVideo: urlDownload,
          misId: misID,
          teamId: teamID);
      var missionComp = await missionCompService.insertMissionComps(mdto);
      mcID = missionComp.data.mcId.toString();

      mc = {
        'notitype': 'mission',
        'mcid': mcID,
        'mission': misName,
        'team': teamName
      };
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

    //Get.defaultDialog(title: mc.toString());
    videoPlayerControllerInProcess = await VideoPlayerController.network(
      vedioProcess,
    )
      ..initialize().then((_) {
        _customVideoPlayerControllerInProcess = CustomVideoPlayerController(
            context: context,
            videoPlayerController: videoPlayerControllerInProcess!,
            customVideoPlayerSettings:
                CustomVideoPlayerSettings(autoFadeOutControls: true));
        setState(() {});
      });
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "ส่งภารกิจ",
                  style: Get.textTheme.headlineSmall!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              body: Stack(
                children: [
                  misfind(),
                  _image == null
                      ? isSubmit == true
                          ? Positioned(
                              height: 200,
                              left: Get.width / 4,
                              bottom: 50,
                              child: AnimatedButton(
                                height: 200,
                                width: 200,
                                borderRadius: BorderRadius.circular(100),
                                text: "เพิ่มหลักฐานภารกิจ",
                                buttonTextStyle: TextStyle(
                                    fontSize: 30, color: Colors.white),
                                color: Colors.orange,
                                pressEvent: () async {
                                  selectmedia();
                                },
                              ),
                            )
                          : Container()
                      : isSubmit == true
                          ? Positioned(
                              height: 100,
                              width: 100,
                              left: 300,
                              bottom: 270,
                              child: IconButton(
                                  onPressed: () {
                                    selectmedia();
                                  },
                                  tooltip: "เลือกหลักฐานใหม่",
                                  iconSize: 50,
                                  constraints: BoxConstraints.expand(),
                                  color: Colors.amber,
                                  icon: FaIcon(FontAwesomeIcons.rotate)))
                          : Container()
                ],
              ),
            );
          } else {
            return Scaffold();
          }
        });
  }

  ListView misfind() {
    return ListView(children: [
      Column(
        children: [
          Card(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 35, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ภารกิจ ",
                        style: Get.textTheme.headlineSmall!.copyWith(
                          // color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$misName",
                        style: Get.textTheme.headlineSmall!.copyWith(
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Container(
                    width: Get.width,
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(misMediaUrl),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('รายละเอียด :',
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(misDiscrip,
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onBackground,
                            fontSize: 20)),
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('ผ่านภารกิจโดย',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(type,
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onBackground,
                                fontSize: 20)),
                      ),
                    ),
                  ],
                ),
                Gap(10)

                //chk mission sending and status == 1(process)

                // buildProgress(),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                //   child: TextField(
                //     controller: answerPass,
                //     keyboardType: TextInputType.multiline,
                //     maxLines: 3,
                //     textInputAction: TextInputAction.done,
                //     decoration: InputDecoration(
                //       hintText: ' คำอธิบาย...',
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //               width: 3, color: Get.theme.colorScheme.primary)),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          isSubmit == true
              ? _image != null
                  ? isImage == true
                      ? Column(
                          children: [
                            //mission select photo
                            SizedBox(
                              width: Get.width - 80,
                              height: Get.height / 4,
                              child: GestureDetector(
                                  onTap: () {
                                    SmartDialog.show(builder: (_) {
                                      return Container(
                                          alignment: Alignment.center,
                                          child: PhotoView(

                                              //  enablePanAlways: true,
                                              tightMode: true,
                                              imageProvider:
                                                  FileImage(_image!)));
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                            )
                          ],
                        )
                      ////mission select media
                      : _customVideoPlayerController == null
                          ? SizedBox(
                              width: 200,
                              height: 150,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.pacman))
                          : SizedBox(
                              width: Get.width,
                              height: Get.height / 3,
                              child: CustomVideoPlayer(
                                  customVideoPlayerController:
                                      _customVideoPlayerController!),
                            )
                  : Container()
              //oldmission
              : isSubmit != true
                  ? SizedBox(
                      width: Get.width - 80,
                      height: Get.height / 4,
                      child: GestureDetector(
                          onTap: () {
                            SmartDialog.show(builder: (_) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: PhotoView(

                                      //  enablePanAlways: true,
                                      tightMode: true,
                                      imageProvider:
                                          NetworkImage(imageInProcess)));
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: NetworkImage(imageInProcess),
                                  fit: BoxFit.cover),
                            ),
                          )),
                    )
                  : vedioProcess != ''
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height / 3,
                          child: CustomVideoPlayer(
                              customVideoPlayerController:
                                  _customVideoPlayerControllerInProcess!),
                        )
                      : SizedBox(
                          width: 200,
                          height: 150,
                          child: LoadingIndicator(
                              indicatorType: Indicator.pacman)),
          SizedBox(
            width: 200,
            child: _image != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.primary,
                    ),
                    onPressed: isSubmit == true
                        ? () async {
                            //  _handleSendNotification();

                            if (_image == null) {
                              if (answerPass.text != '') {
                                final now = DateTime.now();
                                dateTime = '${now.toIso8601String()}Z';
                                MissionCompDto mdto = MissionCompDto(
                                    mcDatetime: DateTime.parse(dateTime),
                                    mcLat: latDevice,
                                    mcLng: lngDevice,
                                    mcMasseage: '',
                                    mcPhoto: '',
                                    mcStatus: 1,
                                    mcText: answerPass.text,
                                    mcVideo: '',
                                    misId: misID,
                                    teamId: teamID);
                                var missionComp = await missionCompService
                                    .insertMissionComps(mdto);
                                mcID = missionComp.data.mcId.toString();
                                mc = {
                                  'notitype': 'mission',
                                  'mcid': mcID,
                                  'mission': misName,
                                  'team': teamName
                                };
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

                                var response1 = await OneSignal.shared
                                    .postNotification(notification1);
                              } else {
                                Get.defaultDialog(title: 'กรุณาเลือกหลักฐาน');
                              }
                            } else {
                              await uploadFile();

                              setState(() {
                                loadDataMethod = loadData();
                              });
                            }
                          }
                        : null,
                    child: isSubmit == true
                        ? Text('ส่งหลักฐาน',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold))
                        : Text('กำลังประมวลผล',
                            style: Get.textTheme.bodyLarge!.copyWith(
                                color: Get.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold)))
                : _image != null
                    ? ElevatedButton(onPressed: () {}, child: Text("กำ"))
                    : Container(),
          )
        ],
      )
    ]);
  }

  Future<dynamic> selectmedia() {
    return showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () async {
                      await _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text("ถ่ายรูป")),
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () async {
                      await _pickVideo(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text("ถ่ายวิดิโอ")),
              ),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                    onPressed: () async {
                      await _pickMedia(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text("เลือกสื่อ")),
              )
            ],
          );
        });
  }
}
