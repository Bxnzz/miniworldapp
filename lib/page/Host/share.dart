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
import '../../model/result/rewardResult.dart';
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

  List<AttendRace> attendUsers = [];
  List<AttendRace> attends = [];
  List<RewardResult> rewards = [];
  List<RewardResult> rewardAlls = [];
  List<Race> races = [];
  List<Map<String, List<AttendRace>>> attendShow = [];

  int idUser = 0;
  int idrace = 0;
  int sumTeam = 0;
  int hostID = 0;
  int playerID = 0;
  int teamID = 0;
  int teamIDme = 0;
  int orderMe = 0;
  String playerName = '';
  String player1 = '';
  String player2 = '';
  String raceImage = '';
  String raceName = '';
  String hostName = '';
  String teamName = '';

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
       log('userrr'+ idUser.toString());
      // var racehost = await raceService.racesByUserID(userID: idUser);
      // races = racehost.data;

       var reall = await rewardService.rewardByRaceID(raceID: idrace);
      rewardAlls = reall.data;
      hostID = reall.data.first.race.userId;
      raceImage = reall.data.first.race.raceImage;
      raceName = reall.data.first.race.raceName;
      hostName = reall.data.first.race.user.userName;
      sumTeam = reall.data.last.reType;
      var atUser = await attendService.attendByUserID(userID: idUser);
      attendUsers = atUser.data;
      var a = attendUsers.where((element) => idUser == element.userId);
      // log('user '+a.first.teamId.toString());
      playerID = a.first.userId;
      teamIDme = a.first.teamId;

      var atTeam = await attendService.attendByTeamID(teamID: teamIDme);
      attends = atTeam.data;
      // for (var att in attends) {
      //    playerName = att.user.userName;
      //   log(att.user.userName);
      // }
      for (var i = 0; i < attends.length; i++) {
        log(attends[i].user.userName);
        player1 = attends[0].user.userName;
        player2 = attends[1].user.userName;
      }
      var re = await rewardService.rewardByTeamID(teamID: teamIDme);
      rewards = re.data;

      //hostID = re.data.first.team.race.user.userId;
      teamID = re.data.first.teamId;
      teamName = re.data.first.team.teamName;
      orderMe = re.data.first.reType;

      log(teamID.toString());
      
     
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
                          idUser == hostID
                              ? Screenshot(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        imageRace(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Text(
                                            'ชื่อการแข่งขัน: ' + raceName,
                                            style: Get.textTheme.bodyLarge!
                                                .copyWith(
                                                    color: Get.theme.colorScheme
                                                        .onBackground,
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                              'ผู้สร้างการแข่งขัน: ' + hostName,
                                              style: Get.textTheme.bodyLarge!
                                                  .copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                              'จำนวนผู้เข้าแข่งขันทั้งหมด: ' +
                                                  sumTeam.toString(),
                                              style: Get.textTheme.bodyLarge!
                                                  .copyWith(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : idUser == playerID
                                  ? Screenshot(
                                      controller: screenshotController,
                                      child: Container(
                                        width: 325,
                                        height: 470,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            imagePlayer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30),
                                              child: Text(
                                                'ชื่อการแข่งขัน: ' + raceName,
                                                style: Get.textTheme.bodyLarge!
                                                    .copyWith(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .onBackground,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text('ชื่อทีม:' + teamName,
                                                  style: Get
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onBackground,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text(
                                                  'สมาชิกคนที่ 1:' + player1,
                                                  style: Get
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onBackground,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Text(
                                                  'สมาชิกคนที่ 2:' + player2,
                                                  style: Get
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onBackground,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
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
        Positioned(
          bottom: 0,
          right: 10,
          left: 10,
          child: Container(
              width: Get.width,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      const Color.fromARGB(255, 73, 73, 73).withOpacity(0.5))),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: Text('#มาร่วมสนุกด้วยกันสิ!!',
              style: Get.textTheme.bodyLarge!.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/image/logo.png")),
        ),
      ],
    );
  }

  imagePlayer() {
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
        Positioned(
          bottom: 0,
          right: 10,
          left: 10,
          child: Container(
              width: Get.width,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      const Color.fromARGB(255, 73, 73, 73).withOpacity(0.5))),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          left: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    'อันดับ',
                    style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$orderMe/$sumTeam',
                    style: Get.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('#มาร่วมสนุกด้วยกันสิ!!',
                  style: Get.textTheme.bodyLarge!.copyWith(
                      color: Get.theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset("assets/image/logo.png")),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: orderMe == 1
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset("assets/image/crown1.png"),
                )
              : orderMe == 2
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset("assets/image/crown2.png"),
                    )
                  : orderMe == 3
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset("assets/image/crown3.png"),
                        )
                      : orderMe >= 3
                          ? Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Get.theme.colorScheme.primary),
                              child: Center(
                                child: Text(orderMe.toString(),
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                        color: Get.theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Container(),
        ),
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
