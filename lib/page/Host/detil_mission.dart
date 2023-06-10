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
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/page/Host/race_edit_mission.dart';

import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../widget/box.dart';
import '../../widget/language.dart';

class DetailMission extends StatefulWidget {
  const DetailMission({
    Key? key,
  }) : super(key: key);

  @override
  _DetailMissionState createState() => _DetailMissionState();
}

class _DetailMissionState extends State<DetailMission>
     {
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
  late MissionService missionService;

  bool inReorder = false;

  ScrollController scrollController = ScrollController();
   
   void onReorderFinished(List<Mission> newItems) {
    scrollController.jumpTo(scrollController.offset);
    setState(() {
      inReorder = false;
      
      // for(;;){
          missions
        ..clear()
        ..addAll(newItems);
     // }
    
        
    });
  }
 
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
    try {
      var a = await missionService.missionByraceID(raceID: idrace);
      missions = a.data;
    } catch (err) {
      log('Error:$err');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: FaIcon(
        //       FontAwesomeIcons.circleChevronLeft,
        //       color: Colors.yellow,
        //       size: 30,
        //     ),
        //    // onPressed: () => Navigator.of(context).pop(),
        //   ),
        title: const Center(child: Text('ภารกิจ' ,style: TextStyle(color: Colors.white),)),
        
        backgroundColor: Color.fromARGB(255, 238, 145, 255),
      ),
      body: FutureBuilder(
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
                Padding(padding: EdgeInsets.only(bottom: 8)),
               // _buildHeadline(),
                 _buildVerticalLanguageList(),
               ],

          
        );
          }else {
              return const CircularProgressIndicator();
            }
         }, 
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
            padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
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
      footer: _buildFooter(context, theme.textTheme,missions),
    );
  }

  Widget _buildTile(Mission mis) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final number = <int>[mis.misSeq];
    return Slidable(
      endActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          label: 'ลบ',
          backgroundColor: Colors.redAccent,
          onPressed: (BuildContext context) {
           showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                title: Center(child: Text('ลบภารกิจ?')),
                content: Text('คุณต้องการจะลบภารกิจนี้หรือไม่?'),
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
                            log('misID' +mis.misId.toString());
                         
                            var missionsD = await missionService
                                .deleteMissons(mis.misId.toString());
                            log(missionsD.toString());
                            misRe = missionsD.data;
                            if (misRe.result == '1') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('delete Successful')),
                              );
                               missions.removeWhere((element){
                                          return element.misId == mis.misId;
                                    }); //go through the loop and match content to delete from list
                                     
                              setState(() {
                                
                              });
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
          label: 'แก้ไข',
          backgroundColor: Colors.blueAccent,
          onPressed: (BuildContext context) {
            Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditMission()));
            context.read<AppData>().idMis = mis.misId;
          },
          icon: Icons.edit,
        ),
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
                '${mis.misSeq}',
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

    Widget _buildHeadline() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget buildDivider() => Container(
          height: 2,
          color: Colors.grey.shade300,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
      //  buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'ลำดับ',
                style: textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ชื่อภารกิจ',
                style: textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'เลื่อน',
                style: textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      //  buildDivider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, TextTheme textTheme,List<Mission> mis) {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context,snapshot) {
         if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
        return Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: Card(
            child: Box(
              color: Color.fromARGB(255, 233, 117, 253),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Missioncreate(),
                  ),
                );
                   context.read<AppData>().sqnum = missions.last.misSeq;
                   log('last' + missions.last.misSeq.toString());
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
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ),
                  const Divider(height: 0),
                ],
              ),
            ),
          ),
        );
        
      }
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  
 
}
