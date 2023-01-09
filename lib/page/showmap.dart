import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/attend.dart';
import 'package:miniworldapp/service/attend.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';

class ShowMapPage extends StatefulWidget {
  const ShowMapPage({Key? key}) : super(key: key);

  @override
  State<ShowMapPage> createState() => ShowMapPageState();
}

class ShowMapPageState extends State<ShowMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatlngDto> latlngDtos = [];
  late int atId;
  late double lat;
  late double lng;
  late int userId;
  late String datetime;
  late Future<void> loadDataMethod;
  late AttendService attendService;
  late int range = 0;
  LatLng centerMap = LatLng(16.245916, 103.252182);
  Set<Marker> markers = {};

  Future _goToSuwannabhumiAirport() async {
    var latlngs = await attendService.attend();

    for (var latlng in latlngs.data) {
      var marker = Marker(
                markerId: MarkerId(latlng.atId.toString()),
                position: LatLng(latlng.lat!.toDouble(),latlng.lng!.toDouble()),);
                markers.add(marker);
    }
    setState(() {
      
    });

    // log(jsonEncode(latlng.data));
    // range=int.parse(jsonEncode(latlng.data.length));
    // log(range.toString());

  
    LatLng newMap = LatLng(16.245916, 103.252182);
    // LatlngDto dto = LatlngDto(
    //   atId: atId, lat: lat, lng: lng, userId: userId, datetime: datetime);

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngZoom(newMap, 16));
  }

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Map"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.airplanemode_active),
              onPressed: _goToSuwannabhumiAirport),
        ]),
        body: GoogleMap(
          myLocationEnabled: true,
          markers:  markers,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: centerMap,
            zoom: 16,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
