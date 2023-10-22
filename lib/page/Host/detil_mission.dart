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
import 'package:miniworldapp/page/General/Home.dart';
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
  String misType = '';

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
      //mType = a.data.first.misType.toString();

      // if (mType.contains('12')) {
      //   misType = 'ข้อความ,สื่อ';
      // } else if (misType.contains('1')) {
      //   misType = 'ข้อความ';
      // } else if (misType.contains('2')) {
      //   misType = 'รูป,คลิป';
      // } else if (misType.contains('3')) {
      //   misType = 'ไม่มีการส่ง';
      // } else {
      //   return;
      // }

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
        Get.to(() => Home());
        return true;
      },
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 243, 216, 248),
        appBar: AppBar(
          // Overide the default Back button
          // automaticallyImplyLeading: false,
          // leadingWidth: 100,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: FaIcon(
          //     FontAwesomeIcons.circleChevronLeft,
          //     color: Colors.yellow,
          //     size: 35,
          //   ),
          // ),
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
    mType = mis.misType.toString();

    if (mis.misType.isEqual(12)) {
      misType = 'ข้อความ,สื่อ';
      log('aaaa');
    } else if (mis.misType.isEqual(1)) {
      log('22222222');
      misType = 'ข้อความ';
    } else if (mis.misType.isEqual(2)) {
      log('3333333');
      misType = 'รูป,คลิป';
    } else if (mis.misType.isEqual(3)) {
      log('555555');
      misType = 'ไม่มีการส่ง';
    } else {
      log('asasasasas');
    }
    log('ประเภท ' + misType);
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
                            missions.removeWhere((element) {
                              return element.misId == mis.misId;
                            }); //go through the loop and match content to delete from list

                            for (var i = 0; i < missions.length; i++) {
                              MissionDto missionDto = MissionDto(
                                  misName: missions[i].misName,
                                  misDiscrip: missions[i].misDiscrip,
                                  misDistance: missions[i].misDistance,
                                  misType: missions[i].misType,
                                  misSeq: missions.indexOf(missions[i]) + 1,
                                  misMediaUrl: '',
                                  misLat: missions[i].misLat,
                                  misLng: missions[i].misLng,
                                  raceId: missions[i].raceId);
                              log(jsonEncode(missionDto));
                              // log('item ' + missions[i].misId.toString()+':'+i.toString());
                              var mission = await missionService.updateMis(
                                  missionDto, missions[i].misId.toString());
                            }

                            if (misRe.result == '1') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('ลบภารกิจสำเร็จ!!')),
                              );

                              // missions.removeWhere((element) {
                              //   return element.misId == mis.misId;
                              // }); //go through the loop and match content to delete from list

                              setState(() {});
                              Navigator.pop(context);
                              // log("race Successful");
                              return;
                            } else {
                              // log("team fail");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('ลบภารกิจไม่สำเร็จ!')),
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
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return const Dialog.fullscreen(
                  child: EditMission(),
                );
              },
            ).then((value) {
              setState(() {
                _buildVerticalLanguageList();
                loadDataMethod = loadData();
              });
            });
            context.read<AppData>().idMis = mis.misId;
          },
          icon: Icons.edit,
        ),
      ]),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                        height: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 300,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(mis.misMediaUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              //int sortn = mis.misSeq,
                              '# ${missions.indexOf(mis) + 1} ${mis.misName}',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('รายละเอียด: ',
                                style: textTheme.bodyLarge!),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              mis.misDiscrip,
                              style: textTheme.bodyLarge!,
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('ประเภท: ' + misType,
                                style: textTheme.bodyLarge!),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 10),
                            child: Text(
                                'ระยะภารกิจ: ' +
                                    mis.misDistance.toString() +
                                    ' เมตร',
                                style: textTheme.bodyLarge!),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 120,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(mis.misMediaUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          //int sortn = mis.misSeq,
                          '# ${missions.indexOf(mis) + 1} ${mis.misName}',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 10, right: 10),
                            child: FaIcon(FontAwesomeIcons.filePen),
                          ),
                          Container(
                            width: 180,
                            child: Text(
                              mis.misDiscrip,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyLarge!,
                              maxLines: 1,
                              // new),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('ประเภท ' + misType,
                            style: textTheme.bodyLarge!
                                .copyWith(color: Colors.grey)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Handle(
                    delay: Duration(milliseconds: 0),
                    capturePointer: true,
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
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
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog.fullscreen(
                        child: Missioncreate(),
                      );
                    },
                  ).then((value) {
                    setState(() {
                      _buildVerticalLanguageList();
                      loadDataMethod = loadData();
                    });
                  });

                  //final result = await Get.to(() => Missioncreate());
                  context.read<AppData>().lastMis = mis.last.misId;
                  context.read<AppData>().sqnum = missions.last.misSeq;
                  log('last' + mis.last.misId.toString());

                  // if (result != null && !missions.contains(result)) {
                  //   setState(() {
                  //     missions.add(result);
                  //   });
                  // }
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

  // void _openAddEntryDialog() {
  //   Navigator.of(context).push(new MaterialPageRoute<Null>(
  //       builder: (BuildContext context) {
  //         return new Missioncreate();
  //       },
  //       fullscreenDialog: true));
  // }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
