import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

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
  const ShowMapPage({Key? key}) : super(key: key);

  @override
  State<ShowMapPage> createState() => ShowMapPageState();
}

class ShowMapPageState extends State<ShowMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng centerMap = const LatLng(16.245916, 103.252182);
//  List<LatlngDto> latlngDtos = [];
  late Future<void> loadDataMethod;
  List<AttendRace> attends = [];
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

    for (var latlng in latlngs.data) {
      var marker = Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(latlng.atId.toString()),
          position: LatLng(latlng.lat.toDouble(), latlng.lng.toDouble()),
          infoWindow: InfoWindow(
              title: "${latlngs.data.first.team.teamName}",
              snippet: "${latlngs.data.first.user.userName}",
              onTap: () {
                attends.map(
                  (e) {
                    return SmartDialog.show(builder: (_) {
                      return Dialog(
                          child: Container(
                        width: 150,
                        height: 100,
                        child: Text("ชื่อ: ${e.user.userName}"),
                      ));
                    });
                  },
                ).toList();

                // Get.defaultDialog(title: 'ข้อมูลสมาชิก');
              }));

      markers.add(marker);
    }
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
                  appBar: AppBar(
                    title: Text("ตำแหน่งผู้แข่งขัน"),
                  ),
                  body: GoogleMap(
                    markers: markers,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: centerMap,
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
