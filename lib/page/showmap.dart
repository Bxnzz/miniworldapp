import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/DTO/attendDTO.dart';

import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/model/result/attendRaceResult.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';
import '../widget/loadData.dart';

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

  Set<Marker> markers = {};
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
        markerId: MarkerId(latlng.atId.toString()),
        position: LatLng(latlng.lat.toDouble(), latlng.lng.toDouble()),
      );

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
                  appBar: AppBar(title: const Text("Map"), actions: <Widget>[]),
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
