import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniworldapp/page/Host/approve_mission.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/missionComp.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';
import 'package:badges/badges.dart' as badges;

class ListApprove extends StatefulWidget {
  const ListApprove({super.key});

  @override
  State<ListApprove> createState() => _ListApproveState();
}

class _ListApproveState extends State<ListApprove> {
  late MissionCompService missionCompService;
  late List<MissionComplete> missionComp;
  int misID = 0;
  String misType = '';
  String type = '';
  List<Mission> missions = [];

  bool isLoaded = false;

  late Future<void> loadDataMethod;
  @override
  void initState() {
    super.initState();
    misID = context.read<AppData>().misID;
    log(misID.toString());

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await missionCompService.missionCompBymisId(misID: misID);
      missionComp = a.data;
      misType = a.data.first.mission.misType.toString();

      var splitT = misType.split('');

      List<String> substrings = splitT.toString().split(",");

      log(misType);
      if (misType.contains('12')) {
        type = 'ข้อความ,สื่อ';
      } else if (misType.contains('1')) {
        type = 'ข้อความ';
      } else if (misType.contains('2')) {
        type = 'สื่อ';
      } else if (misType.contains('3')) {
        type = 'ไม่มีการส่ง';
      } else {
        return;
      }
      isLoaded = true;
    } catch (err) {
      isLoaded = false;
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future refresh() async {
    setState(() {
      loadDataMethod = loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หลักฐานทั้งหมด')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: missionComp.map((element) {
                    final theme = Theme.of(context);
                    final textTheme = theme.textTheme;
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: element.mission.misType != 3 &&
                              element.mcStatus == 1
                          ? Card(
                              //  shadowColor: ,
                              clipBehavior: Clip.hardEdge,

                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.0),
                                splashColor: Colors.blue.withAlpha(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      // For testing different size item. You can comment this line
                                      padding: element.misId == element.misId
                                          ? const EdgeInsets.symmetric(
                                              vertical: 16.0)
                                          : EdgeInsets.zero,
                                      child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ทีม : ${element.team.teamName}',
                                                style: textTheme.bodyText2
                                                    ?.copyWith(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'ประเภท : ${type}',
                                                style: textTheme.bodyText2
                                                    ?.copyWith(
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                          trailing: FilledButton(
                                            child: Text('ตรวจสอบ'),
                                            onPressed: () {
                                              showDialog<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog.fullscreen(
                                                    child: ApproveMission(
                                                      IDmc: element.mcId,
                                                    ),
                                                  );
                                                },
                                              ).then((value) {
                                                setState(() {
                                                  loadDataMethod = loadData();
                                                });
                                              });

                                              //  context.read<AppData>().misID = element.misId;
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
