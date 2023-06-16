import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';

class CheckMission extends StatefulWidget {
  const CheckMission({super.key});

  @override
  State<CheckMission> createState() => _CheckMissionState();
}

class _CheckMissionState extends State<CheckMission> {
  late RaceResult misRe;
  int idrace = 0;
  List<Mission> missions = [];

  final seq = <int>[];
  late Future<void> loadDataMethod;
  late RaceResult misResults;
  late MissionService missionService;
  String type1 = '';
  String type2 = '';
  String type3 = '';
  String mType = '';
  String types = '';

  bool isLoaded = false;

  bool inReorder = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    idrace = context.read<AppData>().idrace;
    log('id' + idrace.toString());
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    // idUser = context.read<AppData>().idUser;
    // log("id:" + idUser.toString());

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService.missionByraceID(raceID: idrace).then((value) {
      //    log(value.data.first.misName);
    });

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await missionService.missionByraceID(raceID: idrace);
      missions = a.data;
      mType = a.data.first.misType.toString();

      isLoaded = true;
    } catch (err) {
      isLoaded = false;
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'ภารกิจ',
          //  style: TextStyle(color: Colors.white),
        )),
      ),
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                padding: EdgeInsets.only(top: 10),
                children: missions.map((element) {
                  final theme = Theme.of(context);
                  final textTheme = theme.textTheme;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Card(
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
                              padding: element.misName == element.misName
                                  ? const EdgeInsets.symmetric(vertical: 16.0)
                                  : EdgeInsets.zero,
                              child: ListTile(
                                title: Text(
                                  element.misName,
                                  style: textTheme.bodyText2?.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              
                                leading: SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Center(
                                    child: Text(
                                      //int sortn = mis.misSeq,
                                      '${missions.indexOf(element) + 1}',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: Colors.purple,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: FilledButton(child: Text('ตรวจสอบภารกิจ'),onPressed: (){},)
                              ),
                            ),
                          ],
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
}
