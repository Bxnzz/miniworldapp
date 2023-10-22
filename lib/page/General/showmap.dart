import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';

import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/model/result/rewardResult.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:miniworldapp/service/reward.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';
import 'package:http/http.dart' as http;

class ShowMapPage extends StatefulWidget {
  const ShowMapPage({super.key, required this.showAppbar});
  final bool showAppbar;
  @override
  State<ShowMapPage> createState() => ShowMapPageState();
}

class ShowMapPageState extends State<ShowMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng centerMap = const LatLng(16.245916, 103.252182);
//  List<LatlngDto> latlngDtos = [];
  late Future<void> loadDataMethod;
  List<AttendRace> attends = [];
  List<AttendRace> attendLatLng = [];
  List<AttendRace> teamAttends = [];
  List<RewardResult> rewards = [];
  late AttendService attendService;
  late RewardService rewardService;
  String imgUser = '';
  Set<Marker> markers = {};
  late BitmapDescriptor _markerIcon;
  late int atId;
  // late double lat;
  // late double lng;
  late int userId;
  late String datetime;
  int idrace = 0;
  Set<int> teamMe = {};
  Set<int> teamAllRegis = {};
  Set<int> teamRe = {};
  Set<int> all = {};
  int sum1 = 0;
  int sum2 = 0;
  int sum3 = 0;

  late int range = 0;
  bool showAppbar = true;
  @override
  void initState() {
    super.initState();
    idrace = context.read<AppData>().idrace;

    log('id' + idrace.toString());
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    rewardService =
        RewardService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
    // 2.2 async method
    if (context.read<AppData>().updateLocationTimer.isActive == false) {
      context.read<AppData>().updateLocationTimer =
          Timer.periodic(Duration(seconds: 3), (timer) {
        markers = {};
        _updateLocation().then((value) {
          log('aa');
          setState(() {});
          return null;
        });
      });
    }
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await attendService.attendByRaceID(raceID: idrace);
      attends = a.data;
      //  log('lat'+attends.first.lat.toString());
      // isLoaded = true;

      imgUser = attends.first.user.userImage;
      // for (var tm in attends) {
      //   log('tmmmm ' + tm.team.raceId.toString());
      //   teamMe.add(tm.team.raceId);
      //   //log('teamAll'+ tm.teamId.toString());
      //   teamAllRegis.add(tm.teamId);
      // }
      // log('teamAll' + teamAllRegis.toString());
      // log('raceteams ' + teamMe.toString());

      var re = await rewardService.rewardAll();
      rewards = re.data;
      sum1 = 0;
      sum2 = 0;
      sum3 = 0;
    } catch (err) {
      // isLoaded = false;
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future<void> _updateLocation() async {
    var latlngs = await attendService.attendByRaceID(raceID: idrace);
    attendLatLng = latlngs.data;
    debugPrint(attendLatLng.toList().toString());
    attendLatLng.map((e) {
      var marker = Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(e.atId.toString()),
          position: LatLng(e.lat.toDouble(), e.lng.toDouble()),
          infoWindow: InfoWindow(
              title: "${e.team.teamName}",
              snippet: "${e.user.userName}",
              onTap: () async {
                log('userrrrrrr ' + e.user.userId.toString());
                var t =
                    await attendService.attendByUserID(userID: e.user.userId);
                teamAttends = t.data;
                //  hostID = t.data.first

                //teamAttends = [];
                teamAllRegis = {};
                for (var tm in teamAttends) {
                  log(tm.team.raceId.toString());
                  teamMe.add(tm.team.raceId);
                  //log('teamAll'+ tm.teamId.toString());
                  teamAllRegis.add(tm.teamId);
                }
                log('teamAll' + teamAllRegis.toString());
                log('raceteams ' + teamMe.toString());

                sum1 = 0;
                sum2 = 0;
                sum3 = 0;
                all.clear();
                for (var element in rewards) {
                  //  log('RewardTeam'+element.teamId.toString());
                  teamRe.add(element.teamId);
                  var all = teamAllRegis.intersection(teamRe);
                  log('all$all');

                  if (all.contains(element.teamId)) {
                    log('Name ' +
                        element.team.teamName +
                        ' no. ' +
                        element.reType.toString());
                    log('sumAll ' + all.length.toString());
                    if (element.reType == 1) {
                      log('sum ' + all.length.toString());
                      sum1 = all.length;
                      log('sum1 ' + sum1.toString());
                    }
                    if (element.reType == 2) {
                      log('sum2 ' + all.length.toString());
                      sum2 = all.length;
                    }
                    if (element.reType == 3) {
                      log('sum3 ' + all.length.toString());
                      sum3 = all.length;
                    } else {}
                  }
                }
                AwesomeDialog(
                        customHeader: CircleAvatar(
                          radius: Get.width / 6,
                          backgroundImage: NetworkImage("${e.user.userImage}"),
                        ),
                        desc: "${e.user.userName}",
                        context: context,
                        showCloseIcon: true,
                        dismissOnBackKeyPress: true,
                        dialogType: DialogType.noHeader,
                        title: 'ภารกิจล้มเหลว!!!',
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("ชื่อในระบบ : ${e.user.userName}"),
                            Text("ชื่อจริง : ${e.user.userFullname}"),
                            Text("คำอธิบาย :${e.user.userDiscription}"),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/image/crown1.png",
                                    width: 50,
                                  ),
                                  Text(sum1.toString()),
                                  Image.asset(
                                    "assets/image/crown2.png",
                                    width: 50,
                                  ),
                                  Text(sum2.toString()),
                                  Image.asset(
                                    "assets/image/crown3.png",
                                    width: 50,
                                  ),
                                  Text(sum3.toString()),
                                ]),
                          ],
                        ),
                        closeIcon: FaIcon(FontAwesomeIcons.x))
                    .show();
                // SmartDialog.show(builder: (_) {
                //   return Dialog(
                //       child: Container(
                //     height: 200,
                //     width: 200,
                //     child: Column(
                //       children: [
                //         CircleAvatar(
                //           radius: 50,
                //           backgroundImage: NetworkImage("${e.user.userImage}"),
                //         ),
                //         Text("ชื่อ: ${e.user.userName}"),
                //       ],
                //     ),
                //   ));
                // });

                // Get.defaultDialog(title: 'ข้อมูลสมาชิก');
              }));

      markers.add(marker);
    }).toList();

    log('ma ' + markers.first.position.latitude.toString());
    //  setState(() {});

    // LatLng newMap = const LatLng(16.245916, 103.252182);
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newLatLngZoom(newMap, 16));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AppData>().updateLocationTimer.cancel();
        return true;
      },
      child: FutureBuilder(
          future: loadDataMethod,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
            }
            return DefaultTabController(
              initialIndex: 1,
              length: 3,
              child: Scaffold(
                  appBar: widget.showAppbar == true
                      ? AppBar(
                          title: Text("ตำแหน่งผู้แข่งขัน"),
                        )
                      : null,
                  body: GoogleMap(
                    markers: markers,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(attends.first.lat, attends.first.lng),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  )),
            );
          }),
    );
  }
}
