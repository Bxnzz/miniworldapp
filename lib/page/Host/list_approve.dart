import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../model/missionComp.dart';
import '../../service/missionComp.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';

class ListApprove extends StatefulWidget {
  const ListApprove({super.key});

  @override
  State<ListApprove> createState() => _ListApproveState();
}

class _ListApproveState extends State<ListApprove> {
  late MissionCompService missionCompService;
  late List<MissionComplete> missionComp;
  int misID = 0; 
  List<Mission> missions = [];

  bool isLoaded = false;
  
  late Future<void> loadDataMethod;
  @override
  void initState() {
    super.initState();
    misID = context.read<AppData>().misID;

    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    
     loadDataMethod = loadData();
  }
  
   Future<void> loadData() async {
   startLoading(context);
    try {
      var a = await missionCompService.missionCompBymisId(misID: misID);
      missionComp = a.data;
      
      isLoaded = true;
    } catch (err) {
      isLoaded = false;
      log('Error:$err');
    }
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หลักฐานทั้งหมด')),
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
                                  trailing: FilledButton(
                                    child: Text('ตรวจสอบภารกิจ'),
                                    onPressed: () {
                                     Get.to(ListApprove());
                                     context.read<AppData>().misID = misID;
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Container();
            }
          }),
    );
    
  }
  
 
   }

