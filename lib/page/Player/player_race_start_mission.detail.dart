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
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
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

  late Future loadDataMethod;

  List<MissionComplete> missionComp = [];
  List<Mission> missions = [];
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

  int teamID = 0;
  int idrace = 0;
  int misID = 0;

  double mlat = 0.0;
  double mlng = 0.0;
  bool isImage = false;

  File? _image;
  CroppedFile? croppedImage;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  UploadTask? uploadTask;

  @override
  void initState() {
    // TODO: implement initState
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

  Future<void> loadData() async {
    startLoading(context);
    try {
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

      mlat = a.data.first.mission.misLat;
      mlng = a.data.first.mission.misLng;
      teamName = a.data.first.team.teamName;
      misMediaUrl = mis3.data.first.misMediaUrl;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "$misName",
                  style: Get.textTheme.headlineSmall!.copyWith(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                child: misfind(),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(20),
                child: Image.network(misMediaUrl)),
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
                        width: 3, color: Get.theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.only(right: 35.0),
                child: SizedBox(
                  width: 80,
                  height: 50,
                  child: AnimatedButton(
                    icon: FontAwesomeIcons.plus,
                    color: Colors.orange,
                    pressEvent: () async {
                      selectmedia();
                    },
                  ),
                ),
              )
            ],
          ),

          _image != null
              ? isImage == true
                  ? Stack(children: [
                      GestureDetector(
                        onLongPress: () {
                          selectmedia();
                        },
                        onTap: () {
                          SmartDialog.show(builder: (_) {
                            return Container(
                                alignment: Alignment.center,
                                child: PhotoView(

                                    //  enablePanAlways: true,
                                    tightMode: true,
                                    imageProvider: FileImage(_image!)));
                          });
                        },
                        child: SizedBox(
                          width: Get.width / 2,
                          height: Get.height / 3,
                          child: Positioned.fill(
                            child: Image.file(_image!),
                          ),
                        ),
                      ),
                    ])
                  : _customVideoPlayerController != null
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height / 3,
                          child: GestureDetector(
                            onLongPress: () {
                              selectmedia();
                            },
                            child: CustomVideoPlayer(
                                customVideoPlayerController:
                                    _customVideoPlayerController!),
                          ),
                        )
                      : SizedBox(
                          width: 200,
                          height: 150,
                          child:
                              LoadingIndicator(indicatorType: Indicator.pacman))
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: Get.width,
                    height: 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3, color: Get.theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  )),

          // buildProgress(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
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
                    if (_image == null) {
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
