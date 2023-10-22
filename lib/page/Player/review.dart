import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/DTO/reviewDTO.dart';
import 'package:miniworldapp/model/result/reviewResult.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/Host/race_review.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/provider/appdata.dart';
import 'package:miniworldapp/service/review.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../widget/loadData.dart';

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

  final _formKey = GlobalKey<FormState>();
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
    raceId = context.read<AppData>().idrace;
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var atn = await attendService.attendByUserID(userID: userId);

      userName = atn.data.first.user.userName;

      log("raceid = ${raceId}");
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
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 36, 33, 37),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("รีวิว",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ))),
      //  PreferredSize(
      //     preferredSize: Size(Get.width, Get.height),
      //     child: SafeArea(
      //       child: Row(
      //         children: [
      //           // IconButton(
      //           //   onPressed: () {
      //           //     Navigator.of(context).pop();
      //           //   },
      //           //   icon: const FaIcon(
      //           //     FontAwesomeIcons.circleChevronLeft,
      //           //     color: Colors.yellow,
      //           //     size: 35,
      //           //   ),
      //           // ),
      //           Text(
      //             "รีวิวการแข่งขัน",
      //             style: textTheme.bodyLarge?.copyWith(
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white,
      //                 fontSize: 20),
      //           )
      //         ],
      //       ),
      //     )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/image/NewBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: loadDataMethods,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SafeArea(
                    child: Center(
                      child: Stack(
                        children: [
                          Positioned(
                            left: Get.width / 4,
                            top: 20,
                            child: circleSmile(),
                          ),
                          Card(
                            margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                            surfaceTintColor: Colors.transparent,
                            elevation: 10,
                            child: SizedBox(
                              height: Get.height / 2 + 50,
                              width: Get.width / 1.3,
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("\" ${userName} \""),
                                      Text("คุณชอบการแข่งขันนี้ไหม?",
                                          style: Get.textTheme.headlineMedium!
                                              .copyWith()),
                                      Text("ให้คะแนนเราสิ",
                                          style: Get.textTheme.headlineMedium!
                                              .copyWith()),
                                      ratungBar(),
                                      SizedBox(
                                        height: Get.height / 5,
                                        width: Get.width / 1.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: revText,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                hintText:
                                                    'กิจกรรมเป็นอย่างไร....'),
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 7,
                                            maxLines: 8,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          cancleBtns(context),
                                          Container(
                                            width: 100,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  Reviewdto reviewdto =
                                                      Reviewdto(
                                                    revText: revText.text,
                                                    revPoint:
                                                        latingPoint.toInt(),
                                                    revDatetime: DateTime.now()
                                                        .toIso8601String(),
                                                    userId: userId,
                                                    raceId: raceId,
                                                  );
                                                  log(
                                                    DateTime.now()
                                                        .toIso8601String(),
                                                  );
                                                  var revResult =
                                                      await reviewService
                                                          .reviews(reviewdto);

                                                  if (revResult.data.massage ==
                                                      "Insert Success") {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'รีวิวสำเร็จ :)')),
                                                    );
                                                    Get.back();
                                                    Get.back();
                                                    Get.to(() => raceReview());
                                                    return;
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'รีวิวผิดพลาดกรุณาดำเนินการใหม่')),
                                                    );

                                                    return;
                                                  }
                                                },
                                                child: Text("ตกลง")),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
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
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color.fromARGB(255, 153, 152, 152).withOpacity(0.8),
            blurRadius: 3.0,
            offset: new Offset(0.0, 3.0),
          ),
        ],
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

Container cancleBtns(context) {
  return Container(
      width: 100,
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("ยกเลิก")));
}
