/*import 'dart:async';
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

  final Completer<GoogleMapController> _controller = Completer();
  LatLng centerMap = const LatLng(16.245916, 103.252182);
  List<LatlngDto> latlngDtos = [];   
   late Future<void> loadDataMethod;
  late AttendService attendService; 
  Set<Marker> markers = {};
  late int atId;
  late double lat;
  late double lng;
  late int userId;
  late String datetime;

  late int range = 0;
  
 

  Future _goToMarker() async {
    var latlngs = await attendService.attend();

    for (var latlng in latlngs.data) {
      var marker = Marker(
                markerId: MarkerId(latlng.atId.toString()),
                position: LatLng(latlng.lat!.toDouble(),latlng.lng!.toDouble()),);
                markers.add(marker);
    }
    setState(() {
      
    });



  
    // LatLng newMap = const LatLng(16.245916, 103.252182);
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newLatLngZoom(newMap, 16));
  }

  @override
  void initState() {
    super.initState();
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Map"), actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.airplanemode_active),
              onPressed: _goToMarker),
        ]),
        body: GoogleMap(          
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
}*/
