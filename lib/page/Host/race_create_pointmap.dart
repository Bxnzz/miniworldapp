import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class RacePointMap extends StatefulWidget {
  const RacePointMap({super.key});

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
  late AttendService attendService;
  List<Marker> markerss = [];
  int id = 1;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  LatLng centerMap = const LatLng(16.245916, 103.252182);

  @override
  void initState() {
    // intilize();
    super.initState();
    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างการแข่งขัน'),
      ),
      body: raceMap(),
    );
  }

  raceMap() {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (LatLng latlng) {
                  Marker newmarker = Marker(
                    markerId: MarkerId('$id'),
                    position: LatLng(latlng.latitude, latlng.longitude),
                    infoWindow: InfoWindow(title: 'New place'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRose),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
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
                              ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('กรุณาเลือกประเภทภารกิจ'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('รัศมีแจ้งเตือนภารกิจ'),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: dropdownRadius())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  markerss.add(newmarker);
                  id = id + 1;
                  setState(() {});
                  log('Our lat and long is: $latlng');
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: centerMap,
                  zoom: 16,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: markerss.map((e) => e).toSet(),
                polylines: _polylines,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget dropdownRadius() {
    return SingleChildScrollView(
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                log(selectedValue.toString());
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
      ),
    );
  }
}
