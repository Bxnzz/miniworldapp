import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late double leftW = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 75, 255),
      appBar: AppBar(
        title: Text("Review"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: Get.width / 4,
                top: 20,
                child: Container(
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
                ),
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
                        children: [
                          Text("คุณชอบการแข่งขันนี้ไหม  ?",
                              style: Get.textTheme.headlineMedium!.copyWith()),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Text("ให้คะแนนเราสิ",
                              style: Get.textTheme.headlineMedium!.copyWith()),
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
                                minLines: 7, // <-- SEE HERE
                                maxLines: 8, // <-- SEE HERE
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
