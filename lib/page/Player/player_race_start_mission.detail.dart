import 'dart:developer';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awsome;

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
import 'package:lottie/lottie.dart';
import 'package:miniworldapp/page/Player/test.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/missionComp.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:miniworldapp/widget/dialogAlert.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../model/DTO/missionCompDTO.dart';
import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStMisDetail extends StatefulWidget {
  const PlayerRaceStMisDetail({super.key});

  @override
  State<PlayerRaceStMisDetail> createState() => _PlayerRaceStMisDetailState();
}

class _PlayerRaceStMisDetailState extends State<PlayerRaceStMisDetail>
    with TickerProviderStateMixin {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late AttendService _attendService;
  late Future loadDataMethod;
  late final AnimationController _controller;
  late List<MissionComplete> missionComp;
  List<Mission> missions = [];
  List<Mission> missionbyID = [];

  Map<String, dynamic> mc = {};
  TextEditingController answerPass = TextEditingController();
  TextEditingController textInProcesCtl = TextEditingController();

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
  String imageInProcess = '';
  String textinProcess = '';

  int teamID = 0;
  int idrace = 0;
  int misID = 0;
  int MCmisID = 0;
  int mcLastSt = 0;

  double latDevice = 0.0;
  double lngDevice = 0.0;
  bool isImage = true;
  bool isSubmit = false;
  bool answerShow = false;
  bool isText = false;
  int StSubmitDb = 0;

  File? _image;
  CroppedFile? croppedImage;
  VideoPlayerController? videoPlayerController;

  VideoPlayerController? videoPlayerControllerInProcess;

  CustomVideoPlayerController? _customVideoPlayerController;

  CustomVideoPlayerController? _customVideoPlayerControllerInProcess;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showFullscreenButton: true);
  UploadTask? uploadTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    teamID = context.read<AppData>().idTeam;
    idrace = context.read<AppData>().idrace;
    misID = context.read<AppData>().idMis;

    latDevice = context.read<AppData>().latMiscomp;
    lngDevice = context.read<AppData>().lngMiscomp;
    log("isSubmit " + isSubmit.toString());
    log('provider isSubmit ' + context.read<AppData>().isSubmit.toString());

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    _attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  void dispose() {
    if (_customVideoPlayerControllerInProcess != null ||
        _customVideoPlayerController != null) {
      _customVideoPlayerControllerInProcess!.dispose();
      _customVideoPlayerController!.dispose();
    }
    answerPass.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      log('provider isSubmit on loadData ' +
          context.read<AppData>().isSubmit.toString());
      isSubmit = context.read<AppData>().isSubmit;
      misID = context.read<AppData>().idMis;
      log("before a ");
      log("mission id $misID");
      var mis3 = await missionService.missionBymisID(misID: misID);
      log("idteam ====${teamID}");
      //first mission
      if (mis3.data.first.misSeq == 1) {
        context.read<AppData>().firstMis = false;
        log("firstmis");
        var a = await missionCompService.missionCompByTeamId(teamID: teamID);

        log("firstmis1");
        if (a.data.isNotEmpty) {
          missionComp = a.data;
          log("firstmis2");
          var b = await missionCompService.missionCompBymisId(
              misID: a.data.last.misId);
          log("b mcSt:${b.data.last.mcStatus}");
          log("b misID:${b.data.last.misId}");
          if (b.data.last.mcStatus == 3) {
            StSubmitDb = 3;
            log("missioncomp Status : fail $StSubmitDb");
          }
          if (b.data.last.mcStatus == 2) {
            StSubmitDb = 2;
            log("missioncomp Status : pass $StSubmitDb");
          }
          if (b.data.last.mcStatus == 1) {
            StSubmitDb = 1;
            log("missioncomp Status : wait $StSubmitDb");
          }
          missionComp.map((e) {
            if (e.misId == misID && e.mcStatus == 1) {
              imageInProcess = e.mcPhoto;
              vedioProcess = e.mcVideo;
              textinProcess = e.mcText;
              textInProcesCtl.text = textinProcess;
              log("mc photo " + imageInProcess.toString());
              log("mc vedioProcess " + vedioProcess.toString());
              log("mc text = " + textinProcess);
            }
          }).toList();
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
            }).onError((error, stackTrace) {
              log(error.toString());
            });
        }
        if (a.data.isEmpty) {
          log("firstmisnull");
        }
      }
      //another mission
      if (mis3.data.first.misSeq != 1) {
        var a = await missionCompService.missionCompByTeamId(teamID: teamID);
        missionComp = a.data;
        if (a.data.last.misId != null) {
          var b = await missionCompService.missionCompBymisId(
              misID: a.data.last.misId);
          log("b mcSt:${b.data.last.mcStatus}");
          log("b misID:${b.data.last.misId}");
          if (b.data.last.mcStatus == 3) {
            StSubmitDb = 3;
            log("missioncomp Status : fail $StSubmitDb");
          }
          if (b.data.last.mcStatus == 2) {
            StSubmitDb = 2;
            log("missioncomp Status : pass $StSubmitDb");
          }
          if (b.data.last.mcStatus == 1) {
            StSubmitDb = 1;
            log("missioncomp Status : wait $StSubmitDb");
          }
        }

        missionComp.map((e) {
          if (e.misId == misID && e.mcStatus == 1) {
            imageInProcess = e.mcPhoto;
            vedioProcess = e.mcVideo;
            textinProcess = e.mcText;
            textInProcesCtl.text = textinProcess;
            log("mc photo " + imageInProcess.toString());
            log("mc vedioProcess " + vedioProcess.toString());
            log("mc text = " + textinProcess);
          }
        }).toList();
        videoPlayerControllerInProcess = VideoPlayerController.network(
          vedioProcess,
        )..initialize().then((_) {
            _customVideoPlayerControllerInProcess = CustomVideoPlayerController(
                context: context,
                videoPlayerController: videoPlayerControllerInProcess!,
                customVideoPlayerSettings:
                    CustomVideoPlayerSettings(autoFadeOutControls: true));
            setState(() {});
          }).onError((error, stackTrace) {
            log(error.toString());
          });
      }

      log("before mis2");
      var mis2 = await missionService.missionByraceID(raceID: idrace);
      var teambyid = await _attendService.attendByTeamID(teamID: teamID);
      teamName = teambyid.data.first.team.teamName;

      var mc = await missionCompService.missionCompBymisId(misID: misID);
      if (mc.data.isEmpty) {
        log("set SubmitStatus =false");
        context.read<AppData>().isSubmit = false;
      }
      if (mc.data.isNotEmpty) {
        mcLastSt = mc.data.last.mcStatus;
        MCmisID = mc.data.last.misId;

        // context.read<AppData>().isSubmit = true;
        log("MCmisID = $MCmisID");
        log("mcLastSt${mc.data.last.mcStatus}");
        log("misID ====${misID}");
      }

      //log("${mc.data.length}");

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
      log("StSubmitDb = $StSubmitDb");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
      // if (StSubmitDb == 3) {
      //   GetAlertDialog();
      // }
    }
  }

  void GetAlertDialog() {
    Get.defaultDialog(
        title: 'ภารกิจล้มเหลว!!!',
        content: dialog_alert(
            asset: 'assets/image/failmsg.json', width: 200, height: 200),
        actions: [
          SizedBox(
            width: Get.width,
            child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("ปิด")),
          )
        ]);
  }

  void alert_dialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await awsome.AwesomeDialog(
              transitionAnimationDuration: const Duration(milliseconds: 100),
              context: context,
              headerAnimationLoop: true,
              showCloseIcon: true,
              dismissOnBackKeyPress: true,
              animType: awsome.AnimType.scale,
              dialogType: awsome.DialogType.error,
              title: 'ภารกิจล้มเหลว!!!',
              btnOkText: 'ทำภารกิจใหม่',
              body: Lottie.asset(
                'assets/image/wrongGf.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              closeIcon: FaIcon(FontAwesomeIcons.x))
          .show();
    });
  }

  Future _pickImage(ImageSource source) async {
    if (StSubmitDb == 3) {
      StSubmitDb = 5;
    } else {
      StSubmitDb = 4;
    }

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
    if (StSubmitDb == 3) {
      StSubmitDb = 5;
    } else {
      StSubmitDb = 4;
    }
    final image = await ImagePicker().pickVideo(source: source);
    isImage = false;
    if (image == null) {
      return;
    }
    File? img = File(image.path!);
    _image = img;
    videoPlayerController = VideoPlayerController.file(File(_image!.path))
      ..initialize().then((_) {
        //SizedBox(child: ,)
        _customVideoPlayerController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: videoPlayerController!,
            customVideoPlayerSettings:
                CustomVideoPlayerSettings(autoFadeOutControls: true));
        setState(() {});
        log("videoPlayerController" + videoPlayerController.toString());
      });
    log("videoPlayerController" + videoPlayerController.toString());

    setState(() {});
  }

  Future _pickMedia(ImageSource source) async {
    if (StSubmitDb == 3) {
      StSubmitDb = 5;
    } else {
      StSubmitDb = 4;
    }
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

    context.read<AppData>().firstMis = true;
    isSubmit = true;
    context.read<AppData>().isSubmit = isSubmit;
    var deviceState = await OneSignal.shared.getDeviceState();
    final now = DateTime.now();
    dateTime = '${now.toIso8601String()}Z';
    // log(dateTime);
    //final berlinWallFell = DateTime.utc(now);
    // if (answerPass.text != '') {
    //   final now = DateTime.now();
    //   dateTime = '${now.toIso8601String()}Z';
    //   MissionCompDto mdto = MissionCompDto(
    //       mcDatetime: DateTime.parse(dateTime),
    //       mcLat: latDevice,
    //       mcLng: lngDevice,
    //       mcMasseage: '',
    //       mcPhoto: '',
    //       mcStatus: 1,
    //       mcText: answerPass.text,
    //       mcVideo: '',
    //       misId: misID,
    //       teamId: teamID);
    //   var missionComp = await missionCompService.insertMissionComps(mdto);
    //   mcID = missionComp.data.mcId.toString();
    //   mc = {
    //     'notitype': 'mission',
    //     'mcid': mcID,
    //     'mission': misName,
    //     'team': teamName
    //   };
    //   var notification1 = OSCreateNotification(
    //       //playerID
    //       additionalData: mc,
    //       playerIds: [
    //         onesingnalId,
    //         //'9556bafc-c68e-4ef2-a469-2a4b61d09168',
    //       ],
    //       content: 'ส่งจากทีม: $teamName',
    //       heading: "หลักฐานภารกิจ: $misName",
    //       //  iosAttachments: {"id1",urlImage},
    //       // bigPicture: imUrlString,
    //       buttons: [
    //         OSActionButton(text: "ตกลง", id: "id1"),
    //         OSActionButton(text: "ยกเลิก", id: "id2")
    //       ]);

    //   var response1 = await OneSignal.shared.postNotification(notification1);
    // } else {
    //   Get.defaultDialog(title: 'กรุณาเลือกหลักฐาน');
    // }
    if (_image != null) {
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
      _image = null;
    } else if (_image == null) {
      log("upload");
      //upload type mission Text
      isText = true;
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
      setState(() {});
    }
    answerPass.clear();
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
    // videoPlayerControllerInProcess = await VideoPlayerController.network(
    //   vedioProcess,
    // )
    //   ..initialize().then((_) {
    //     _customVideoPlayerControllerInProcess = CustomVideoPlayerController(
    //         context: context,
    //         videoPlayerController: videoPlayerControllerInProcess!,
    //         customVideoPlayerSettings:
    //             CustomVideoPlayerSettings(autoFadeOutControls: true));
    //     setState(() {});
    //   });

    // videoPlayerController = null;

    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ส่งภารกิจ",
          style: Get.textTheme.headlineSmall!.copyWith(
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/image/NewBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
            future: loadDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: loadData,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 95),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              cardDetailMis(),
                              //type mission is 12
                              if (StSubmitDb != 1 && misType == "12")
                                //ข้อความและสื่อ
                                SizedBox(
                                  width: Get.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 15),
                                    child: TextField(
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          log("onChange");
                                          log("$answerPass");
                                          log("${answerPass.text}");
                                          answerShow = true;
                                          setState(() {});
                                        } else {
                                          log("anserShow false");
                                          answerShow = false;
                                          setState(() {});
                                        }
                                      },
                                      controller: answerPass,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: ' คำอธิบายหลักฐาน...',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: Get.theme.colorScheme
                                                    .primary)),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(),
                              // //messege only
                              if (StSubmitDb != 1 &&
                                  misType == '1' &&
                                  StSubmitDb != 3)
                                SizedBox(
                                  width: Get.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 15),

                                    ///ข้อความเท่านั้น
                                    child: TextField(
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          log("onChange");
                                          log("$answerPass");
                                          log("${answerPass.text}");
                                          answerShow = true;
                                          setState(() {});
                                        } else {
                                          log("anserShow false");
                                          answerShow = false;
                                          setState(() {});
                                        }
                                      },
                                      controller: answerPass,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: ' คำอธิบายหลักฐาน...',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: Get.theme.colorScheme
                                                    .primary)),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(),
                              misfind(),
                              Gap(15),
                              //mission fail media
                              StSubmitDb == 3 && misType != '1'
                                  ? Column(
                                      children: [
                                        Center(
                                          child: AnimatedButton(
                                              height: 150,
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                              onPressed: () {
                                                selectmedia();
                                              },
                                              child: Text(
                                                '      ทำ\nภารกิจใหม่',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ],
                                    )
                                  //mission fail text
                                  : StSubmitDb == 3
                                      ? SizedBox(
                                          width: Get.width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                bottom: 15),
                                            child: TextField(
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  log("onChange");
                                                  log("$answerPass");
                                                  log("${answerPass.text}");
                                                  answerShow = true;
                                                  setState(() {});
                                                } else {
                                                  log("anserShow false");
                                                  answerShow = false;
                                                  setState(() {});
                                                }
                                              },
                                              controller: answerPass,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 3,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: Colors
                                                          .red), //<-- SEE HERE
                                                ),
                                                hintText:
                                                    'ตอบคำถามใหม่อีกทีนะ....',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 3,
                                                            color:
                                                                Colors.amber)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                              if (_image == null)
                                if (StSubmitDb == 0 && StSubmitDb == 2 ||
                                    misType != '1' &&
                                        StSubmitDb != 1 &&
                                        StSubmitDb != 3)
                                  AnimatedButton(
                                      height: 150,
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                      onPressed: () {
                                        selectmedia();
                                      },
                                      child: Text(
                                        '   เพิ่ม\nหลักฐาน',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ))
                                else
                                  Container(),
                              btnSend(),
                            ],
                          ),
                        ),
                        if (_image != null && StSubmitDb == 4 ||
                            StSubmitDb == 5)
                          Positioned(
                            bottom: 210,
                            right: 50,
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white),
                              child: IconButton(
                                  onPressed: () {
                                    selectmedia();
                                  },
                                  tooltip: "เลือกหลักฐานใหม่",
                                  iconSize: 35,
                                  constraints: BoxConstraints.expand(),
                                  color: Colors.amber,
                                  icon:
                                      Icon(Icons.add_photo_alternate_rounded)),
                            ),
                          ),
                        if (_image != null && StSubmitDb == 4 ||
                            StSubmitDb == 5)
                          Positioned(
                            bottom: 210,
                            left: 50,
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white.withOpacity(0.8)),
                              child: IconButton(
                                  onPressed: () {
                                    _image = null;
                                    log("StSubmitDb = $StSubmitDb");
                                    if (StSubmitDb == 5) {
                                      log("StSubmitDb in if =$StSubmitDb");
                                      StSubmitDb = 3;
                                    }
                                    if (StSubmitDb == 4) {
                                      log("StSubmitDb in if =$StSubmitDb");
                                      StSubmitDb = 0;
                                    }

                                    setState(() {});
                                  },
                                  tooltip: "ลบหลักฐาน",
                                  iconSize: 25,
                                  constraints: BoxConstraints.expand(),
                                  color: Colors.red,
                                  icon: FaIcon(FontAwesomeIcons.trash)),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              } else {
                return Scaffold();
              }
            }),
      ),
    );
  }

  misfind() {
    return Column(
      children: [
        // SizedBox(
        //   width: Get.width,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        //     child: TextField(
        //       controller: answerPass,
        //       keyboardType: TextInputType.multiline,
        //       maxLines: 3,
        //       textInputAction: TextInputAction.done,
        //       decoration: InputDecoration(
        //         hintText: ' คำอธิบาย...',
        //         focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(
        //                 width: 3, color: Get.theme.colorScheme.primary)),
        //       ),
        //     ),
        //   ),
        // ),

        // ElevatedButton(
        //     onPressed: () {
        //       Get.to(() => testpage());
        //     },
        //     child: Text("as")),
        _image != null
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
                                        imageProvider: FileImage(_image!)));
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
                        child:
                            LoadingIndicator(indicatorType: Indicator.pacman))
                    : SizedBox(
                        width: Get.width - 80,
                        height: Get.height / 4,
                        child: CustomVideoPlayer(
                            customVideoPlayerController:
                                _customVideoPlayerController!),
                      )
            : Container()
        //oldmission
        ,
        if (StSubmitDb == 1 &&
            textInProcesCtl.text.isNotEmpty &&
            misType != '2')
          SizedBox(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: TextField(
                controller: textInProcesCtl,
                readOnly: true,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: ' คำอธิบาย...',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Get.theme.colorScheme.primary)),
                ),
              ),
            ),
          ),

        StSubmitDb == 1 && imageInProcess != ''
            //photo
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
                                imageProvider: NetworkImage(imageInProcess)));
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
            //video
            : context.read<AppData>().isSubmit == true &&
                    _customVideoPlayerControllerInProcess != null &&
                    vedioProcess != ''
                ? SizedBox(
                    width: Get.width - 80,
                    height: Get.height / 4,
                    child: CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerControllerInProcess!),
                  )
                : Container(),
      ],
    );
  }

  Card cardDetailMis() {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 5,
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
                      image: NetworkImage(misMediaUrl), fit: BoxFit.cover),
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
                      color: Get.theme.colorScheme.onBackground, fontSize: 15)),
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
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
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
    );
  }

  Column btnSend() {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: (answerPass.text.isNotEmpty || _image != null)
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.primary,
                  ),
                  onPressed: () async {
                    //  _handleSendNotification();

                    StSubmitDb = 1;
                    await uploadFile();

                    setState(() {
                      loadDataMethod = loadData();
                    });
                  },
                  child: Text(
                    'ส่งหลักฐานaaa',
                    style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
              )
              : StSubmitDb == 1 || textInProcesCtl.text.isNotEmpty
                  ? ElevatedButton(
                      onPressed: null,
                      child: Text(
                        "ส่งแล้วรอประมวลผล",
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
        ),
        // isText == true
        //     ? SizedBox(
        //         width: 200,
        //         child: (StSubmitDb == 4 || StSubmitDb == 5)
        //             ? ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Get.theme.colorScheme.primary,
        //                 ),
        //                 onPressed: () async {
        //                   //  _handleSendNotification();

        //                   await uploadFile();
        //                   StSubmitDb = 1;
        //                   setState(() {
        //                     loadDataMethod = loadData();
        //                   });
        //                 },
        //                 child: Text('ส่งหลักฐานdd',
        //                     style: Get.textTheme.bodyLarge!.copyWith(
        //                         color: Get.theme.colorScheme.onPrimary,
        //                         fontWeight: FontWeight.bold)))
        //             : StSubmitDb == 1 || textInProcesCtl.text.isNotEmpty
        //                 ? ElevatedButton(
        //                     onPressed: null,
        //                     child: Text(
        //                       "ส่งแล้วรอประมวลผล",
        //                       style: Get.textTheme.bodyLarge!.copyWith(
        //                           color: Colors.grey,
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                   )
        //                 : Container(),
        //       )
        //     : Container()
      ],
    );
  }

  Future<dynamic> selectmedia() {
    return showModalBottomSheet(
        useRootNavigator: true,
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
