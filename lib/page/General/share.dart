import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'dart:typed_data';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/review.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/review.dart';
import 'package:miniworldapp/service/reward.dart';
import 'package:miniworldapp/service/team.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:miniworldapp/widget/ratingBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../model/race.dart';
import '../../model/result/attendRaceResult.dart';
import '../../model/result/rewardResult.dart';
import '../../model/reward.dart';
import '../../model/team.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';
import 'package:crypto/crypto.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  late AttendService attendService;
  late RewardService rewardService;
  late RaceService raceService;
  late ReviewService reviewService;
  late TeamService teamService;

  List<AttendRace> attendUsers = [];
  List<AttendRace> attends = [];
  List<AttendRace> attendBytid = [];
  List<RewardResult> rewards = [];
  List<RewardResult> rewardAlls = [];
  List<Race> races = [];
  List<Team> teams = [];
  List<Map<String, List<AttendRace>>> attendShow = [];
  List<Review> reviews = [];
  List textShare = [
    "มาร่วมสนุกกันสิ!!!",
    "ปังปุริเย่มากแก><",
    "เริ่ดมากกกกก😀",
    "สนุกสุดเหวี่ยง",
    "ใครแน่จริงมาแข่งกัน!",
    "ทีมเวิร์คเป็นยอด🤣",
    "ใครจะไปอดใจไหวสนุกขนาดนี้",
    "เดือดฝุดๆ 😝😜",
    "Happy race ",
    "So funny"
  ];
  final _random = new math.Random();
  var element;
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

  double avg = 0;

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
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    teamService = TeamService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    element = textShare[_random.nextInt(textShare.length)];

    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      idrace = context.read<AppData>().idrace;
      idUser = context.read<AppData>().idUser;
      log('userrr' + idUser.toString());
      // var racehost = await raceService.racesByUserID(userID: idUser);
      // races = racehost.data;
      log(" id race$idrace");
      var review = await reviewService.reviewByRaceID(raceID: idrace);
      if (review.data.isNotEmpty) {
        reviews = review.data;
      }

      var teamByrID = await teamService.teambyRaceID(raceID: idrace);
      teams = teamByrID.data;

      var reall = await rewardService.rewardByRaceID(raceID: idrace);
      rewardAlls = reall.data;
      hostID = reall.data.first.race.userId;
      raceImage = reall.data.first.race.raceImage;
      raceName = reall.data.first.race.raceName;
      hostName = reall.data.first.race.user.userName;
      sumTeam = reall.data.last.reType;
      var atByrID = await attendService.attendByUserID(userID: idUser);

      attendUsers = atByrID.data;
     
      for (var element in attendUsers) {
        if(element.team.raceId == idrace){
          log('teammm '+element.team.teamId.toString());
          teamIDme = element.team.teamId;
      log('attTeam ' + teamIDme.toString());
      var re = await rewardService.rewardByTeamID(teamID: teamIDme);
      rewards = re.data;
     
       log('No.'+rewards.first.reType.toString());
      orderMe = re.data.first.reType;
      log("orderMe = $orderMe");
      log('team in attend by uid ${teamIDme}');
        }
      }
       teamIDme = attendUsers.first.teamId;
      log('attTeam ' + teamIDme.toString());
      var re = await rewardService.rewardByTeamID(teamID: 15);
      rewards = re.data;
     
       log('No.'+rewards.first.reType.toString());
      // orderMe = re.data.first.reType;
      // log("orderMe = $orderMe");
      // log('team in attend by uid ${teamIDme}');
     

      attendUsers.map((e) async {
        if (e.team.raceId == idrace) {
          var atByTid =
              await attendService.attendByTeamID(teamID: e.team.teamId);
          attendBytid = atByTid.data;

          if (attendBytid.length < 2) {
            player1 = attendBytid[0].user.userName;
          } else if (attendBytid.length >= 2) {
            player1 = attendBytid[0].user.userName;
            player2 = attendBytid[1].user.userName;
          }

          log("player1 = $player1");
          log("player2 = $player2");
          teamName = attendBytid.first.team.teamName;
          log("${attendBytid.length}");
          log("teamid === ${e.team.teamId}");
          log("username1 ${e.user.userName}");
        }

       // log('team in attend by uid ${teamIDme}');
      }).toList();

     

      var a = attendUsers.where((element) => idUser == element.userId);

      log('user ' + a.first.teamId.toString());
      playerID = a.first.userId;

      log('team' + teamIDme.toString());
      // for (var att in attends) {
      //    playerName = att.user.userName;
      //   log(att.user.userName);
      // }

      // var re = await rewardService.rewardByTeamID(teamID: teamIDme);
      // rewards = re.data;

      // //hostID = re.data.first.team.race.user.userId;

      // orderMe = re.data.first.reType;
      // log("orderMe = $orderMe");
      // for (var i = 0; i < attends.length; i++) {
      //   log(attends[i].user.userName);
      //   if (attends.length < 2) {
      //     log("player1");
      //     player1 = attends[0].user.userName;
      //   } else if (attends.length >= 2) {
      //     log("player2");
      //     player1 = attends[0].user.userName;
      //     player2 = attends[1].user.userName;
      //   }
      // }
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "แชร์ผลการแข่งขัน",
          style: Get.textTheme.headlineSmall!.copyWith(),
        ),
        // leading: IconButton(
        //   icon: FaIcon(
        //     FontAwesomeIcons.circleChevronLeft,
        //     color: Colors.yellow,
        //     size: 35,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (reviews.isNotEmpty) {
                avg = reviews.map((m) => m.revPoint).reduce((a, b) => a + b) /
                    reviews.length;
                log("${reviews.length}");
              }

              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //host
                      idUser == hostID
                          ? Screenshot(
                              controller: screenshotController,
                              child: Stack(
                                children: [
                                  Container(
                                    width: Get.width / 1.2,
                                    height: 500,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              "assets/image/NewBG.jpg")),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x3f000000),
                                          offset: Offset(0, 6),
                                          blurRadius: 0.2,
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                            10,
                                          ),
                                          child: imageRace(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 15, left: 15),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'การแข่งขัน: ' +
                                                            raceName,
                                                        style: Get.textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          'ผู้สร้าง: ' +
                                                              hostName,
                                                          style: Get.textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .onBackground,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          'ทีมเข้าแข่งขัน: ' +
                                                              sumTeam
                                                                  .toString() +
                                                              ' ทีม',
                                                          style: Get.textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .onBackground,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("คะแนนเฉลี่ย   ",
                                                          style: Get.textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .onBackground,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      ratingBar(
                                                          point: avg,
                                                          size: 30,
                                                          faIcon: FaIcon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            color: Colors.amber,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 483,
                                  //   width: Get.width / 1.2,
                                  //   height: 15,
                                  //   child: Container(
                                  //     height: 20,
                                  //     decoration: BoxDecoration(
                                  //       color: Color(0xffd3d8ff),
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(21)),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           color: Color(0x3f000000),
                                  //           offset: Offset(0, 4),
                                  //           blurRadius: 0,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  // Screenshot(
                                  //   controller: screenshotController,
                                  //   child: Column(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       imageRace(),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 30),
                                  //         child: Text(
                                  //           'ชื่อการแข่งขัน: ' + raceName,
                                  //           style: Get.textTheme.bodyLarge!
                                  //               .copyWith(
                                  //                   color: Get.theme.colorScheme
                                  //                       .onBackground,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //           textAlign: TextAlign.start,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 15),
                                  //         child: Text(
                                  //             'ผู้สร้างการแข่งขัน: ' + hostName,
                                  //             style: Get.textTheme.bodyLarge!
                                  //                 .copyWith(
                                  //                     color: Get
                                  //                         .theme
                                  //                         .colorScheme
                                  //                         .onBackground,
                                  //                     fontWeight:
                                  //                         FontWeight.bold)),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 15),
                                  //         child: Text(
                                  //             'จำนวนผู้เข้าแข่งขันทั้งหมด: ' +
                                  //                 sumTeam.toString(),
                                  //             style: Get.textTheme.bodyLarge!
                                  //                 .copyWith(
                                  //                     color: Get
                                  //                         .theme
                                  //                         .colorScheme
                                  //                         .onBackground,
                                  //                     fontWeight:
                                  //                         FontWeight.bold)),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          //player
                          : idUser == playerID
                              ? Screenshot(
                                  controller: screenshotController,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: Get.width / 1.2,
                                        height: 500,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/image/NewBG.jpg")),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x3f000000),
                                              offset: Offset(0, 6),
                                              blurRadius: 0.2,
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                10,
                                              ),
                                              child: imagePlayer(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, right: 15, left: 15),
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'ชื่อการแข่งขัน: ' +
                                                                raceName,
                                                            style: Get.textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'ชื่อทีม:' +
                                                                teamName,
                                                            style: Get.textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'สมาชิกคนที่ 1: ' +
                                                                  player1,
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          player2.isEmpty
                                                              ? Container()
                                                              : Text(
                                                                  'สมาชิกคนที่ 2: ' +
                                                                      player2,
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ratingBar(
                                                              point: avg,
                                                              size: 30,
                                                              faIcon: FaIcon(
                                                                FontAwesomeIcons
                                                                    .solidStar,
                                                                color: Colors
                                                                    .amber,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Positioned(
                                      //   top: 483,
                                      //   width: Get.width / 1.2,
                                      //   height: 15,
                                      //   child: Container(
                                      //     height: 20,
                                      //     decoration: BoxDecoration(
                                      //       color: Color(0xffd3d8ff),
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(21)),
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color(0x3f000000),
                                      //           offset: Offset(0, 4),
                                      //           blurRadius: 0,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Positioned(
                                        top: 280,
                                        right: 30,
                                        child: crown(),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                      Gap(10),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3f000000),
                              offset: Offset(0, 6),
                              blurRadius: 0.2,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              screenshotController
                                  .capture(delay: Duration(milliseconds: 10))
                                  .then((image) async {
                                capturedImage = image!;
                                final Directory tempDir =
                                    (await getExternalStorageDirectory())!;

                                file = await File(tempDir.path + '/image.png')
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
                                      style: Get.textTheme.bodyLarge!.copyWith(
                                          color: Get.theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ));
            } else {
              return Container();
            }
          }),
    );
  }

  crown() {
    return orderMe == 1
        ? SizedBox(
            width: 80,
            height: 80,
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
                    : Container();
  }

  imageRace() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
          child: Container(
            height: 200,
            width: Get.width,
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
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 3),
                  child: Text('#$element',
                      style: Get.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   right: 20,
        //   left: 20,
        //   child:
        // ),
        Positioned(
          top: 10,
          left: 10,
          child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset("assets/image/Logominirace.png")),
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
            width: Get.width,
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
                color: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Column(
                    children: [
                      Text(
                        'อันดับ',
                        style: Get.textTheme.bodyMedium!.copyWith(
                            color: Get.theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$orderMe/$sumTeam',
                        style: Get.textTheme.bodyMedium!.copyWith(
                            color: Get.theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 3),
                  child: Text('$element',
                      style: Get.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   right: 20,
        //   left: 20,
        //   child:
        // ),
        Positioned(
          top: 10,
          left: 10,
          child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset("assets/image/Logominirace.png")),
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
