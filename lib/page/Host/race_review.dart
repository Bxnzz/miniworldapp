import 'dart:developer';

import 'package:animated_button/animated_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awsome;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:miniworldapp/model/review.dart';
import 'package:miniworldapp/page/Player/review.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/service/review.dart';
import 'package:miniworldapp/widget/ratingBar.dart';
import 'package:provider/provider.dart';

import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';

class raceReview extends StatefulWidget {
  const raceReview({super.key});

  @override
  State<raceReview> createState() => _raceReviewState();
}

class _raceReviewState extends State<raceReview> {
  late Future<void> loadDataMethods;
  late ReviewService reviewservice;
  late RaceService raceservice;
  late List<Review> reviews = [];
  late List<Race> races = [];
  int raceID = 0;
  int revPoint = 0;
  int userID = 0;

  String img = "";
  String revText = "";
  double avg = 0;

  late DateTime revDateTime;
  late bool showBtnRev = false;

  @override
  void initState() {
    super.initState();
    raceID = context.read<AppData>().idrace;
    userID = context.read<AppData>().idUser;
    reviewservice =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceservice = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethods = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      log("idrace =$raceID");

      var race = await raceservice.racesByraceID(raceID: raceID);
      races = race.data;
      var review = await reviewservice.reviewByRaceID(raceID: raceID);
      // log(review.data.first.raceId.toString());
      log("Err1");
      if (review.data.isNotEmpty) {
        reviews = review.data;
        revText = review.data.first.revText;
        img = review.data.first.user.userImage;
        log("Err2");
        reviews.map((e) {
          log("Err3");
          if (e.user.userId == userID) {
            showBtnRev = true;
            log("showBtnRev = $showBtnRev");
          }
        }).toList();

        if (showBtnRev == false) {
          alert_dialog();
        }
      } else {
        if (showBtnRev == false) {
          alert_dialog();
        }
        reviews = [];
        log("list review Emptyr");
      }
    } catch (err) {
      log("Eror:$err");
    } finally {
      stopLoading();
    }
  }

  void alert_dialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await awsome.AwesomeDialog(
              desc:
                  "คุณยังไม่ได้รีวิวการแข่งขันนี้\nสามารถกดปุ่ม\"รีวิว\"ได้เลย",
              transitionAnimationDuration: const Duration(milliseconds: 100),
              context: context,
              headerAnimationLoop: true,
              showCloseIcon: true,
              dismissOnBackKeyPress: true,
              animType: awsome.AnimType.scale,
              dialogType: awsome.DialogType.info,
              title: 'ภารกิจล้มเหลว!!!',
              body: Container(
                child: Text(
                    "คุณยังไม่ได้รีวิวการแข่งขันนี้\nสามารถกดปุ่ม\"รีวิว\"ได้เลย"),
              ),
              closeIcon: FaIcon(FontAwesomeIcons.x))
          .show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: loadData,
      child: FutureBuilder(
          future: loadDataMethods,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (reviews.isNotEmpty) {
                avg = reviews.map((m) => m.revPoint).reduce((a, b) => a + b) /
                    reviews.length;
              }

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  titleSpacing: 5,
                  title: Text(
                    "รีวิวการแข่งขัน",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.circleChevronLeft,
                      color: Colors.yellow,
                      size: 35,
                    ),
                  ),
                  // actions: [
                  //   showBtnRev == false
                  //       ? IconButton(
                  //           onPressed: () {
                  //             Get.to(
                  //               () => ReviewPage(),
                  //               fullscreenDialog: true,
                  //             );
                  //           },
                  //           icon: Icon(
                  //             Icons.add_comment,
                  //             size: 35,
                  //             color: Colors.white,
                  //           ))
                  //       : SizedBox()
                  // ],
                ),

                //  PreferredSize(
                //   preferredSize: Size(Get.width, Get.height),
                //   child: SafeArea(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             IconButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //               icon: const FaIcon(
                //                 FontAwesomeIcons.solidCircleLeft,
                //                 color: Colors.yellow,
                //                 size: 35,
                //               ),
                //             ),
                //             Text(
                //               "รีวิวการแข่งขัน",
                //               style: textTheme.headlineSmall?.copyWith(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.amber,
                //               ),
                //             ),
                //           ],
                //         ),
                //         showBtnRev == false
                //             ? IconButton(
                //                 onPressed: () {
                //                   Get.to(() => ReviewPage(),
                //                       fullscreenDialog: true,
                //                       transition: Transition.fadeIn);
                //                 },
                //                 icon: Icon(
                //                   Icons.add_comment,
                //                   size: 35,
                //                   color: Colors.white,
                //                 ))
                //             : SizedBox()
                //       ],
                //     ),
                //   ),
                // )
                backgroundColor: Colors.purpleAccent[700],
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              "${races.first.raceName}",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                        showBtnRev == false
                            ? Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: AnimatedButton(
                                    color: Colors.white,
                                    width: 80,
                                    height: 80,
                                    shadowDegree: ShadowDegree.dark,
                                    shape: BoxShape.circle,
                                    onPressed: () {
                                      context.read<AppData>().idrace = raceID;
                                      Get.to(
                                        () => ReviewPage(),
                                        fullscreenDialog: true,
                                      );
                                    },
                                    child: Text(
                                      "รีวิว",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    )),
                              )
                            : Container()
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${avg.toStringAsFixed(1) ?? 0}",
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text("/5",
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 206, 206, 206),
                                  )),
                              Gap(10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ratingBar(
                                    point: avg,
                                    size: 25,
                                    faIcon: FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: Colors.amber,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    reviews.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: Get.height / 3),
                            child: Text(
                              "ยังไม่มีการรีวิวในการแข่งขันนี้",
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 185, 185, 185),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: Get.width,
                            height: Get.height / 1.4,
                            child: ListView(
                              children: reviews.map((e) {
                                return Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8, top: 4, bottom: 4),
                                      child: Container(
                                        width: Get.width,
                                        height: Get.height / 6,
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              CircleAvatar(
                                                  radius: Get.width / 9,
                                                  backgroundImage: NetworkImage(
                                                      "${e.user.userImage ?? ""}")),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    height: Get.height / 10,
                                                    width: Get.width / 1.8,
                                                    // decoration: BoxDecoration(
                                                    //   border: Border.all(
                                                    //       width: 1.5, color: Colors.purple),
                                                    //   borderRadius: BorderRadius.all(
                                                    //       Radius.elliptical(10, 10)),
                                                    // ),
                                                    child: Scrollbar(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                            "${e.revText ?? ""}",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 10,
                                        right: 15,
                                        child: ratingBarStar(
                                            e.revPoint.toDouble() ?? 0.0,
                                            20.0)),
                                    Positioned(
                                      top: 10,
                                      right: 115,
                                      child: Text(
                                        "${e.user.userName ?? ""}\t",
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Scaffold();
            }
          }),
    );
  }

  RatingBar ratingBarStar(point, size) {
    return RatingBar.builder(
      glowColor: Colors.yellowAccent,
      glowRadius: 5,
      allowHalfRating: true,
      initialRating: point,
      ignoreGestures: true,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: size,
      itemBuilder: (context, _) => FaIcon(
        FontAwesomeIcons.solidStar,
        color: Color.fromARGB(255, 255, 197, 38),
      ),
      onRatingUpdate: (lating) {},
    );
  }
}
