import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/General/static_create.dart';
import 'package:miniworldapp/page/General/static_join.dart';

class Static extends StatefulWidget {
  const Static({super.key});

  @override
  State<Static> createState() => _StaticState();
}

class _StaticState extends State<Static> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'สถิติการแข่งขัน',
                style: Get.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                        colors: [
                          Colors.purpleAccent,
                          Color.fromARGB(255, 144, 64, 255),
                        ])),
              ),
              elevation: 0,
              bottom: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: double.minPositive,
                  unselectedLabelColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 255, 22, 100),
                      Color.fromARGB(255, 227, 5, 72)
                    ]),
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.redAccent,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        width:  120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "ที่สร้าง",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "ที่เข้าร่วม",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                        
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            body: TabBarView(children: [
              Static_create(),
              Static_join(),
            ]),
          )),
    );
  }
}
