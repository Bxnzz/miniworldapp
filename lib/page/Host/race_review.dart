import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

  int raceID = 0;
  int revPoint = 0;
  int userID = 0;

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
                    color: Colors.purple,
                    fontSize: 20),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: loadDataMethods,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: Get.width,
                  child: Card(
                    child: InkWell(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("ชื่อ"),
                            ratungBar(),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: Get.width / 7,
                            ),
                            SizedBox(
                              height: Get.height / 5,
                              width: Get.width / 1.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      hintText: 'กิจกรรมเป็นอย่างไร....'),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 7,
                                  maxLines: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  RatingBar ratungBar() {
    return RatingBar.builder(
      glowColor: Colors.yellowAccent,
      glowRadius: 10,
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 50,
      itemBuilder: (context, _) => FaIcon(
        FontAwesomeIcons.solidStar,
        color: Colors.yellow,
      ),
      onRatingUpdate: (lating) {},
    );
  }
}
