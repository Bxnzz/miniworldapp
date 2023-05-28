import 'dart:convert';
import 'dart:developer';
//import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/page/General/history_create.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';

class Static_create extends StatefulWidget {
  const Static_create({super.key});

  @override
  State<Static_create> createState() => _Static_createState();
}

class _Static_createState extends State<Static_create> {
  // 1. กำหนดตัวแปร
  List<Race> races = [];

  late Future<void> loadDataMethod;
  late RaceService raceService;

  

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    raceService.races().then((value) {
      log(value.data.first.raceName);
    });
    // 2.2 async method
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: races.map((element) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                       child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                         Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const History_create()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("ชื่อ: "+element.raceName),
                            Text("เวลา: "+element.raceTimeSt.toString()),
                            Text("สถานที่: "+element.raceLocation),
                            Text("# "+element.raceId.toString()),
                          ],
                        ),
                      ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Future<void> loadData() async {
    try {
      var a = await raceService.races();
      races = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
}
