import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/page/Host/race_edit_mission.dart';

import 'package:provider/provider.dart';

import '../../model/DTO/missionDTO.dart';
import '../../model/mission.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../widget/box.dart';
import '../../widget/loadData.dart';

class DetailMission extends StatefulWidget {
  const DetailMission({
    Key? key,
  }) : super(key: key);

  @override
  _DetailMissionState createState() => _DetailMissionState();
}

class _DetailMissionState extends State<DetailMission> {
  // final List<Language> selectedLanguages = [
  //   english,
  //   german,
  //   spanish,
  //   french,
  // ];
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

  void onReorderFinished(List<Mission> newItems) {
    scrollController.jumpTo(scrollController.offset);
    setState(() {
      inReorder = false;
      // missions
      //   ..clear()
      //   ..addAll(newItems);
      remission(newItems);
    });
  }

  Future<void> remission(List<Mission> newItems) async {
    int idx = -1;
    int newoder = 0;

    //loop หาว่าลำดับใดถูกเปลี่ยน
    for (var i = 0; i < newItems.length - 1; i++) {
      //  for(var j = 0;j < missions.length;j++){
      if (newItems[i].misId == missions[i].misId) {
        continue;
      } else {
        idx = i;
        break;
      }
    }

    //idx = -1 idx sq ไม่เปลี่ยน
    if (idx == -1) {
      return;
    }
    //idx = 3 newoder = 4
    newoder = idx + 1;
    log('new ' + newoder.toString() + ' ' + idx.toString());
    //loop ที่เปลี่ยน
    for (var i = idx; i < newItems.length; i++) {
      //update newItems ตัวที่ i ให้เป็น newoder
      MissionDto missionDto = MissionDto(
          misName: newItems[i].misName,
          misDiscrip: newItems[i].misDiscrip,
          misDistance: newItems[i].misDistance,
          misType: newItems[i].misType,
          misSeq: newoder,
          misMediaUrl: '',
          misLat: newItems[i].misLat,
          misLng: newItems[i].misLng,
          raceId: newItems[i].raceId);
      log(jsonEncode(missionDto));
      // log('item ' + missions[i].misId.toString()+':'+i.toString());
      var mission = await missionService.updateMis(
          missionDto, newItems[i].misId.toString());
      misResults = mission.data;
      newoder = newoder + 1;
      log(misResults.result);

   
    }
    setState(() {
      startLoading(context);
      loadDataMethod = loadData();
    });
    stopLoading();
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

  Future refresh() async {
    setState(() {
      _buildVerticalLanguageList();
      loadDataMethod = loadData();
      // onReorderFinished(newItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Get.to(() => const DetailMission());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // Overide the default Back button
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(
              FontAwesomeIcons.circleChevronLeft,
              color: Colors.yellow,
              size: 35,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 238, 145, 255),
          // other stuff
          title: Text(
            'จัดการภารกิจ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: FutureBuilder(
            future: loadDataMethod,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  controller: scrollController,
                  // Prevent the ListView from scrolling when an item is
                  // currently being dragged.
                  padding: const EdgeInsets.only(bottom: 24),
                
                  children: [
                    const Divider(height: 0),
                    const Padding(padding: EdgeInsets.only(bottom: 8)),
                    // _buildHeadline(),
                    _buildVerticalLanguageList(),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  // * An example of a vertically reorderable list.
  Widget _buildVerticalLanguageList() {
    final theme = Theme.of(context);

    Reorderable buildReorderable(
      Mission mis,
      Widget Function(Widget tile) transition,
    ) {
      return Reorderable(
        key: ValueKey(mis),
        builder: (context, dragAnimation, inDrag) {
          final tile = Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(height: 0),
                  _buildTile(mis),
                  const Divider(height: 0),
                ],
              ),
            ),
          );

          return AnimatedBuilder(
            animation: dragAnimation,
            builder: (context, _) {
              final t = dragAnimation.value;
              final color = Color.lerp(Colors.white, Colors.grey.shade100, t);

              return Material(
                color: color,
                elevation: lerpDouble(0, 8, t)!,
                child: transition(tile),
              );
            },
          );
        },
      );
    }

    return ImplicitlyAnimatedReorderableList<Mission>(
      items: missions,
      shrinkWrap: true,
      reorderDuration: const Duration(milliseconds: 200),
      liftDuration: const Duration(milliseconds: 300),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
      onReorderStarted: (item, index) => setState(() => inReorder = true),
      onReorderFinished: (movedMission, from, to, newItems) {
        // Update the underlying data when the item has been reordered!
        onReorderFinished(newItems);
      },
      itemBuilder: (context, itemAnimation, mis, index) {
        return buildReorderable(mis, (tile) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: itemAnimation,
            child: tile,
          );
        });
      },
      updateItemBuilder: (context, itemAnimation, mis) {
        return buildReorderable(mis, (tile) {
          return FadeTransition(
            opacity: itemAnimation,
            child: tile,
          );
        });
      },
      footer: _buildFooter(context, theme.textTheme, missions),
    );
  }

  Widget _buildTile(Mission mis) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final number = <int>[mis.misSeq];

    return Slidable(
      endActionPane: ActionPane(motion: const BehindMotion(), children: [
        SlidableAction(
          flex: 3,
          label: 'ลบ',
          backgroundColor: Colors.redAccent,
          onPressed: (BuildContext context) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                title: const Center(child: Text('ลบภารกิจ?')),
                content: const Text('คุณต้องการจะลบภารกิจนี้หรือไม่?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('ยกเลิก',
                        style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () async {
                            log('misID' + mis.misId.toString());

                            var missionsD = await missionService
                                .deleteMissons(mis.misId.toString());
                            log(missionsD.toString());
                            misRe = missionsD.data;
                            if (misRe.result == '1') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('delete Successful')),
                              );
                              missions.removeWhere((element) {
                                return element.misId == mis.misId;
                              }); //go through the loop and match content to delete from list

                              setState(() {});
                              Navigator.pop(context);
                              // log("race Successful");
                              return;
                            } else {
                              // log("team fail");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('delete fail try agin!')),
                              );

                              return;
                            }
                          },
                          child: const Text(
                            'ลบ',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            );
          },
          icon: Icons.delete,
        ),
        SlidableAction(
          flex: 4,
          label: 'แก้ไข',
          backgroundColor: Colors.amberAccent,
          onPressed: (BuildContext context) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditMission()));
            context.read<AppData>().idMis = mis.misId;
          },
          icon: Icons.edit,
        ),
        // SlidableAction(
        //   flex: 3,
        //   label: 'ดู',
        //   backgroundColor: Colors.blueAccent,
        //   onPressed: (BuildContext context) {
        //     setState(() {
        //       mType = mis.misType.toString();
        //       var splitT = mType.split('');
        //       //   //   log(splitT.toString());
        //       List<String> substrings = splitT.toString().split(",");
        //       //   //   //substrings = splitT.toString().substring("[");
        //       log('sub' + splitT.toString());
        //       //   // if(substrings[0] == '1'){
        //       //   //   _checkbox == true;
        //       //   // }
        //       if (splitT.contains('1') == true) {
        //         type1 = 'ข้อความ';
        //         log(type1);
        //       }
        //       if (splitT.contains('2') == true) {
        //         type1 = 'สื่อ';
        //         log(type1);

        //         ;
        //       }
        //       if (splitT.contains('3') == true) {
        //         type1 = 'ไม่มีการส่ง';
        //         log(type1);
        //       } else {
        //         return;
        //       }
        //     });
        //     String tt = type1;
        //     log('tt' + tt);
        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         backgroundColor: Colors.white,
        //         title: Center(
        //             child: Text(
        //           'รายละเอียดภารกิจ',
        //           style: textTheme.headlineSmall?.copyWith(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         )),
        //         content: SizedBox(
        //           height: 150,
        //           child: Column(
        //             children: [
        //               Center(
        //                   child: Text(
        //                 mis.misName,
        //                 style: textTheme.bodyText1?.copyWith(),
        //               )),
        //               const Divider(),
        //               Padding(
        //                 padding: const EdgeInsets.only(right: 8, bottom: 4),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   children: [
        //                     const FaIcon(
        //                       FontAwesomeIcons.fileLines,
        //                       size: 18,
        //                       color: Colors.grey,
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.only(left: 13),
        //                       child: Text(mis.misDiscrip),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               const Divider(),
        //               Padding(
        //                 padding: const EdgeInsets.only(right: 8, bottom: 4),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   children: [
        //                     const FaIcon(
        //                       FontAwesomeIcons.listCheck,
        //                       size: 18,
        //                       color: Colors.grey,
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.only(left: 13),
        //                       //     child: Text(itemstr),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         actions: <Widget>[
        //           TextButton(
        //             onPressed: () => Navigator.pop(context, 'Cancel'),
        //             child: const Text('ยกเลิก',
        //                 style: TextStyle(color: Colors.black)),
        //           ),
        //           SizedBox(
        //               width: 120,
        //               child: ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                       backgroundColor: Colors.redAccent),
        //                   onPressed: () async {
        //                     log('misID' + mis.misId.toString());

        //                     var missionsD = await missionService
        //                         .deleteMissons(mis.misId.toString());
        //                     log(missionsD.toString());
        //                     misRe = missionsD.data;
        //                     if (misRe.result == '1') {
        //                       ScaffoldMessenger.of(context).showSnackBar(
        //                         const SnackBar(
        //                             content: Text('delete Successful')),
        //                       );
        //                       missions.removeWhere((element) {
        //                         return element.misId == mis.misId;
        //                       }); //go through the loop and match content to delete from list

        //                       setState(() {});
        //                       Navigator.pop(context);
        //                       // log("race Successful");
        //                       return;
        //                     } else {
        //                       // log("team fail");
        //                       ScaffoldMessenger.of(context).showSnackBar(
        //                         const SnackBar(
        //                             content: Text('delete fail try agin!')),
        //                       );

        //                       return;
        //                     }
        //                   },
        //                   child: const Text(
        //                     'ลบ',
        //                     style: TextStyle(color: Colors.white),
        //                   )))
        //         ],
        //       ),
        //     );
        //   },
        //   icon: Icons.remove_red_eye,
        // ),
      ]),
      child: Container(
        alignment: Alignment.center,
        // For testing different size item. You can comment this line
        padding: mis.misName == mis.misName
            ? const EdgeInsets.symmetric(vertical: 16.0)
            : EdgeInsets.zero,
        child: ListTile(
          title: Text(
            mis.misDiscrip,
            style: textTheme.bodyText2?.copyWith(
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            mis.misName,
            style: textTheme.bodyText1?.copyWith(
              fontSize: 15,
            ),
          ),
          leading: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Text(
                //int sortn = mis.misSeq,
                '${missions.indexOf(mis) + 1}',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.purple,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          trailing: const Handle(
            delay: Duration(milliseconds: 0),
            capturePointer: true,
            child: Icon(
              Icons.drag_handle,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, TextTheme textTheme, List<Mission> mis) {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Card(
              child: Box(
                color: const Color.fromARGB(255, 233, 117, 253),
                onTap: () async {
                  final result = await Get.to(()=>Missioncreate());
                  context.read<AppData>().lastMis = mis.last.misId;
                  context.read<AppData>().sqnum = missions.last.misSeq;
                  log('last' + mis.last.misId.toString());

                  if (result != null && !missions.contains(result)) {
                    setState(() {
                      missions.add(result);
                    });
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const SizedBox(
                        height: 36,
                        width: 36,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      title: Text(
                        'เพิ่มภารกิจ',
                        style: textTheme.bodyLarge
                            ?.copyWith(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
