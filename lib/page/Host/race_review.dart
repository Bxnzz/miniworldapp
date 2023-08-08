import 'dart:developer';

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
import 'package:miniworldapp/service/review.dart';
import 'package:provider/provider.dart';

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
  late List<Review> reviews = [];
  int raceID = 0;
  int revPoint = 0;
  int userID = 0;

  String img = "";
  String revText = "";

  late DateTime revDateTime;

  @override
  void initState() {
    super.initState();
    raceID = context.read<AppData>().idrace;
    userID = context.read<AppData>().idUser;
    reviewservice =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethods = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var review = await reviewservice.reviewByRaceID(raceID: raceID);

      reviews = review.data;
      revText = review.data.first.revText;
      img = review.data.first.user.userImage;
    } catch (err) {
      log("Eror:$err");
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Get.width, Get.height),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.circleChevronLeft,
                  color: Colors.yellow,
                  size: 35,
                ),
              ),
              Text(
                "รีวิวการแข่งขัน",
                style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 20),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.purpleAccent[700],
      body: FutureBuilder(
          future: loadDataMethods,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var avg = reviews.map((m) => m.revPoint).reduce((a, b) => a + b) /
                  reviews.length;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "${reviews.first.race.raceName}",
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              Text("${avg}",
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  )),
                              ratingBar(avg, 30.0)
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
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
                                              "${e.user.userImage}")),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "${e.revText}",
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
                                child: ratingBar(e.revPoint.toDouble(), 20.0)),
                            Positioned(
                              top: 10,
                              right: 115,
                              child: Text(
                                "${e.user.userName}\t",
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  RatingBar ratingBar(point, size) {
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
