import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapPage extends StatefulWidget {
  const ShowMapPage({Key? key}) : super(key: key);

  @override
  State<ShowMapPage> createState() => ShowMapPageState();
}
class ShowMapPageState extends State<ShowMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng centerMap = LatLng(13.7650836, 100.5379664);
  LatLng newMap = LatLng(16.245916, 103.252182);
    Future _goToSuwannabhumiAirport() async {
    final GoogleMapController controller = await _controller.future;
    
    controller.animateCamera(CameraUpdate.newLatLngZoom(newMap,16));    
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: Text("Map"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.airplanemode_active),
            onPressed: _goToSuwannabhumiAirport),
            
      ]),
             
      body: GoogleMap(
        
        myLocationEnabled: true,
        markers: {
            Marker(
                markerId: MarkerId("1"),
                position: centerMap,
                infoWindow: InfoWindow(title: "อนุสารีย์ชัยสมรภูมิ")),
                Marker(
                markerId: MarkerId("2"),
                position: newMap,
                infoWindow: InfoWindow(title: "มมส.")),
          },
        
        
        mapType: MapType.normal,
        
        initialCameraPosition: CameraPosition(
          target: centerMap,
          zoom: 16,
        ),
        
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )
    );
  }
}