import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/DTO/missionDTO.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';
import 'package:miniworldapp/page/Host/race_edit_mission.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class RacePointMap extends StatefulWidget {
  late int idrace;
   RacePointMap({super.key,required this.idrace});

  @override
  State<RacePointMap> createState() => _RacePointMapState();
}

class _RacePointMapState extends State<RacePointMap> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController nameMission = TextEditingController();
  TextEditingController DescriptionMission = TextEditingController();
  final List<String> items = [
    '5',
    '10',
    '15',
  ];
  String? selectedValue;

  bool _checkbox = false;
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  String lats = '';
  String longs = '';
  late MissionService missionService;
  List<Mission> missions = [];
  List<MissionDto> missionDtos = [];

  List<Marker> markerss = [];
  int idrace = 0;
  int id = 1;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  LatLng centerMap = const LatLng(16.245916, 103.252182);
  late GoogleMap googleMap;

  @override
  void initState() {
    // intilize();
    super.initState();
   log(widget.idrace.toString());
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    googleMap = GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      // onTap: (LatLng latlng) {
      //   Marker newmarker = Marker(
      //     markerId: MarkerId('$id'),
      //     position: LatLng(latlng.latitude, latlng.longitude),
      //     infoWindow: InfoWindow(title: 'New place'),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(
      //         BitmapDescriptor.hueRose),
      //     onTap: () {},
      //   );
      //   markerss.add(newmarker);
      //   id = id + 1;
      //   setState(() {});
      //   log('Our lat and long is: $latlng');
      // },
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: centerMap,
        zoom: 16,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: markerss.map((e) => e).toSet(),
      polylines: _polylines,
      onCameraMove: (position) {
        // latitude = position.target.latitude.toInt();
        // lat = int.tryParse(lats.toString().split('.')[3]);
        // longstitude = position.target.latitude.toInt();
        // long = int.tryParse(lats.toString().split('.')[3]);
        // log('xxxx ' +
        //     position.target.latitude.toString() +
        //     ' ' +
        //     position.target.longitude.toString());
        // Text(position.target.latitude.toString());
        lats = position.target.latitude.toString();
        longs = position.target.longitude.toString();
        //log('lat' + lats + longs);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างการแข่งขัน'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailMission(),
                      settings: RouteSettings(arguments: null),
                    ));
              },
              icon: FaIcon(FontAwesomeIcons.flagCheckered))
        ],
      ),
      body: raceMap(),
    );
  }

  raceMap() {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(children: [
              googleMap,
              Positioned(
                  top: (300 / 2) - 32,
                  left: (MediaQuery.of(context).size.width / 2) - 16,
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.mapPin,
                        size: 32,
                        color: Colors.yellowAccent,
                      ),
                      // Text('Lat:'+lat+',Long:'+long),
                    ],
                  )),
            ]),
          ),
          missionInput(),
        ],
      ),
    ));
  }

  missionInput() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('สร้างภารกิจ'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ชื่อภารกิจ'),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    controller: nameMission,
                    decoration: InputDecoration(
                      hintText: 'ชื่อภารกิจ',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('คำอธิบาย'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: DescriptionMission,
                      decoration: InputDecoration(
                        hintText: 'คำอธิบาย...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('กรุณาเลือกประเภทภารกิจ'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('รัศมีแจ้งเตือนภารกิจ'),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0), child: dropdownRadius())
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _checkbox,
                  onChanged: (value) {
                    setState(() {
                      _checkbox = !_checkbox;
                    });
                  },
                ),
                Text('ข้อความ'),
                Checkbox(
                  value: _checkbox1,
                  onChanged: (value) {
                    setState(() {
                      _checkbox1 = !_checkbox1;
                      log(_checkbox1.toString());
                    });
                  },
                ),
                Text('สื่อ'),
                Checkbox(
                  value: _checkbox2,
                  onChanged: (value) {
                    setState(() {
                      _checkbox2 = !_checkbox2;
                    });
                  },
                ),
                Text('ไม่มีการส่ง'),
              ],
            ),
            Center(
              child: ElevatedButton(
                  child: Text('สร้างภารกิจ'),
                  onPressed: () {
                    MissionDto missionDto = MissionDto(
                        misName: nameMission.text,
                        misDiscrip: DescriptionMission.text,
                        misDistance: int.parse(selectedValue!),
                        misType: 0,
                        misSeq: 0,
                        misMediaUrl: '',
                        misLat: double.parse(lats),
                        misLng: double.parse(longs),
                        raceId: widget.idrace);
                    print(double.parse('lat'+lats));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdownRadius() {
    return SingleChildScrollView(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            'รัศมี',
            style: TextStyle(
              //  fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          //  fontSize: 14,
                          ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;

              //    log('radi'+selectedValue.toString());
            });
          },
          buttonStyleData: const ButtonStyleData(
            height: 30,
            width: 60,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
          ),
        ),
      ),
    );
  }
}
