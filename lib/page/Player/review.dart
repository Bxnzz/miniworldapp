import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/reviewDTO.dart';
import 'package:miniworldapp/model/result/reviewResult.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/review.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<ReviewResult> revResult = [];
  late double leftW = 0;
  late int latingPoint = 3;
  late int userId;
  late int raceId;
  late String userName = "";
  late ReviewService reviewService;
  late AttendService attendService;
  TextEditingController revText = TextEditingController();

  late Future<void> loadDataMethods;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = context.read<AppData>().idUser;
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethods = loadData();
  }

  Future<void> loadData() async {
    try {
      var atn = await attendService.attendByUserID(userID: userId);
      raceId = atn.data.first.team.raceId;
      userName = atn.data.first.user.userName;
      log("raceid = ${raceId}");
    } catch (err) {
      log("Eror:$err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 75, 255),
      appBar: AppBar(
        title: Text("Review"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: loadDataMethods,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        left: Get.width / 4,
                        top: 20,
                        child: circleSmile(),
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                        elevation: 0.0,
                        child: SizedBox(
                          height: Get.height / 2,
                          width: Get.width / 1.3,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("\" ${userName} \""),
                                  Text("คุณชอบการแข่งขันนี้ไหม  ?",
                                      style: Get.textTheme.headlineMedium!
                                          .copyWith()),
                                  ratungBar(),
                                  Text("ให้คะแนนเราสิ",
                                      style: Get.textTheme.headlineMedium!
                                          .copyWith()),
                                  SizedBox(
                                    height: Get.height / 5,
                                    width: Get.width / 1.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: revText,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            hintText: 'กิจกรรมเป็นอย่างไร....'),
                                        keyboardType: TextInputType.multiline,
                                        minLines: 7,
                                        maxLines: 8,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          Reviewdto reviewdto = Reviewdto(
                                            revText: revText.text,
                                            revPoint: latingPoint.toInt(),
                                            revDatetime: DateTime.now()
                                                .toIso8601String(),
                                            userId: userId,
                                            raceId: raceId,
                                          );
                                          log(
                                            DateTime.now().toIso8601String(),
                                          );
                                          var revResult = await reviewService
                                              .reviews(reviewdto);

                                          if (revResult.data.massage ==
                                              "Insert Success") {
                                            Get.to(() => HomeAll());
                                            return;
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'รีวิวผิดพลาดกรุณาดำเนินการใหม่')),
                                            );

                                            return;
                                          }
                                        },
                                        child: Text("ตกลง")),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (lating) {
        latingPoint = lating.toInt();
      },
    );
  }

  Container circleSmile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: Colors.white, width: 20),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: FaIcon(
        FontAwesomeIcons.smile,
        color: Colors.yellow,
        size: 35,
      ),
    );
  }
}
