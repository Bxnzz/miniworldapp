import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/reward.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../model/reward.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  late AttendService attendService;
  late RewardService rewardService;
  late RaceService raceService;

  List<AttendRace> attends = [];
  List<Reward> rewards = [];
  List<Race> races = [];
  List<Map<String, List<AttendRace>>> attendShow = [];

  int idUser = 0;
  int idrace = 0;
  String raceImage = '';
  String raceName = '';
  String hostName = '';

  int counter = 0;
  late Uint8List capturedImage;
  late File img;
  late File file;
  // late Uint8List _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      idUser = context.read<AppData>().idUser;

      var re = await rewardService.rewardByRaceID(raceID: idrace);
      rewards = re.data;
      raceImage = re.data.first.race.raceImage;
      raceName = re.data.first.race.raceName;
      hostName = re.data.first.race.user.userFullname;
      var att = await attendService.attendByRaceID(raceID: idrace);
      attends = att.data;
      String tmId = '';
      List<AttendRace> temp = [];
      for (var i = 0; i < attends.length; i++) {
        if (attends[i].teamId.toString() != tmId) {
          if (temp.isNotEmpty) {
            var team = {tmId: temp};
            attendShow.add(team);
            temp = [];
          }
          tmId = attends[i].teamId.toString();
          // log(tmId.toString());
        }

        temp.add(attends[i]);
      }
      if (temp.isNotEmpty) {
        var team = {tmId: temp};
        attendShow.add(team);
      }
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                            Colors.purpleAccent,
                            Colors.blue,
                          ])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 100,
                          ),
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              width: 325,
                              height: 470,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                children: [
                                  imageRace(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text('ชื่อการแข่งขัน: ' + raceName,
                                        style: Get.textTheme.bodyLarge!
                                            .copyWith(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                        'ผู้สร้างการแข่งขัน: ' + hostName,
                                        style: Get.textTheme.bodyLarge!
                                            .copyWith(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // :idUser == attendShow.where((element) => element.values.first.)  ?Container(
                          //  width: 325,
                          // height: 470,
                          // decoration: const BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(15)),
                          // ),
                          // child: Column(
                          //   children: [
                          //     imageRace(),
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 15),
                          //       child: Text('ชื่อการแข่งขัน: '+raceName,
                          //           style: Get.textTheme.bodyLarge!.copyWith(
                          //               color:
                          //                   Get.theme.colorScheme.primary,
                          //               fontWeight: FontWeight.bold)),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 15),
                          //       child: Text('ผู้สร้างการแข่งขัน: '+hostName,
                          //           style: Get.textTheme.bodyLarge!.copyWith(
                          //               color:
                          //                   Get.theme.colorScheme.primary,
                          //               fontWeight: FontWeight.bold)),
                          //     )
                          //   ],
                          // ),
                          // )
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                onPressed: () {
                                  screenshotController
                                      .capture(
                                          delay: Duration(milliseconds: 10))
                                      .then((image) async {
                                    capturedImage = image!;
                                    final Directory tempDir =
                                        (await getExternalStorageDirectory())!;

                                    file =
                                        await File(tempDir.path + '/image.png')
                                            .writeAsBytes(capturedImage);

                                    log(file.path);
                                    //    ShowCapturedWidget(context, file.path);
                                    _saved();
                                  }).catchError((onError) {
                                    print(onError);
                                  });
                                },
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.shareNodes),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text('แชร์',
                                          style: Get.textTheme.bodyLarge!
                                              .copyWith(
                                                  color: Get.theme.colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )));
            } else {
              return Container();
            }
          }),
    );
  }

  imageRace() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(2.5, 2.5),
                  blurRadius: 16,
                ),
              ],
            ),
            margin: EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Image.network(
                raceImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   left: 10,
        //   child: Text(
        //     'Caption',
        //     style: TextStyle(
        //       color: Colors.amber,
        //       fontSize: 20,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  _saved() async {
    // final result = await ImageGallerySaver.saveImage(capturedImage);
    // log("File Saved to Gallery");
    log(file.path);
    appinioSocialShare
        .shareToSystem('test', 'testtt', filePath: file.path)
        .then((value) {
      log('message');
    }).onError((error, stackTrace) {
      log(error.toString());
    });
  }
}
