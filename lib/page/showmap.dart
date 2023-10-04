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
import 'package:miniworldapp/service/attend.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';
import '../widget/loadData.dart';
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
  late AttendService attendService;
  String imgUser = '';
  Set<Marker> markers = {};
  late BitmapDescriptor _markerIcon;
  late int atId;
  // late double lat;
  // late double lng;
  late int userId;
  late String datetime;
  int idrace = 0;

  late int range = 0;
  bool showAppbar = true;
  @override
  void initState() {
    super.initState();
    idrace = context.read<AppData>().idrace;

    log('id' + idrace.toString());
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);

    // 2.2 async method
    loadDataMethod = loadData();
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      var a = await attendService.attendByRaceID(raceID: idrace);
      attends = a.data;
      //  log('lat'+attends.first.lat.toString());
      // isLoaded = true;
      imgUser = attends.first.user.userImage;
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
              onTap: () {
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
                            Text("คำอธิบาย :${e.user.userDiscription}")
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
                //         Text("${e.user.userName}"),
                //         CircleAvatar(
                //           radius: Get.width / 6,
                //           backgroundImage: NetworkImage("${e.user.userImage}"),
                //         ),
                //         Text("${e.user.userFullname}"),
                //         Text("${e.user.userDiscription}")
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
