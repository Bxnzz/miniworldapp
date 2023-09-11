import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAppbar extends StatefulWidget {
  const ProfileAppbar({super.key});

  @override
  State<ProfileAppbar> createState() => _ProfileAppbarState();
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[800],
        appBar: PreferredSize(
            child: appBarUser(), preferredSize: Size(Get.width, 200)),
        body: Container());
  }
}

Widget appBarUser() {
  return SafeArea(
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white),
      width: Get.width,
      height: 80,
      child: Stack(
        children: [
          const Positioned(
              left: 30,
              top: 5,
              child: CircleAvatar(
                radius: 30,
              )),
          Positioned(
              left: 90,
              top: 5,
              child: Text(
                "ยูเซอร์เนม",
                style: Get.textTheme.bodyLarge!.copyWith(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Positioned(
              left: 90,
              top: 35,
              child: Text(
                "ยูเซอร์เนม เนมยูเซอร์",
                style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w100),
              )),
          //gold
          Positioned(
              right: 140,
              bottom: 2,
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      "assets/image/crown1.png",
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Get.theme.colorScheme.primary,
                    ),
                    height: 30,
                    width: 50,
                    child: Center(child: Text("10")),
                  ),
                ],
              )),
          //silver
          Positioned(
              right: 80,
              bottom: 2,
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      "assets/image/crown2.png",
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Get.theme.colorScheme.primary,
                    ),
                    height: 30,
                    width: 50,
                    child: Center(child: Text("10")),
                  ),
                ],
              )),
          //copper
          Positioned(
              right: 20,
              bottom: 2,
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      "assets/image/crown3.png",
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Get.theme.colorScheme.primary,
                    ),
                    height: 30,
                    width: 50,
                    child: Center(child: Text("10")),
                  ),
                ],
              )),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: VerticalDivider(
                  width: 5,
                  thickness: 0,
                  indent: 2,
                  endIndent: 2,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: VerticalDivider(
                  width: 5,
                  thickness: 0,
                  indent: 2,
                  endIndent: 2,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
