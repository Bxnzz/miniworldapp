import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/DTO/missionDTO.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../service/attend.dart';
import '../../service/provider/appdata.dart';

class Missioncreate extends StatefulWidget {
  Missioncreate({super.key});

  @override
  State<Missioncreate> createState() => _MissioncreateState();
}

class _MissioncreateState extends State<Missioncreate> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController nameMission = TextEditingController();
  TextEditingController DescriptionMission = TextEditingController();
  final List<String> items = [
    '5',
    '10',
    '15',
  ];
  String? selectedValue;
  late Future<void> loadDataMethod;

  bool _checkbox = false;
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  late LatLng currentLatLng;
  late Position postion;
  String longs = '';
  String lats = '';
  String cb = '';
  int mType = 0;
  int square = 0;
  int sqnum = 0; 
  late MissionService missionService;
  List<Mission> missions = [];
  List<MissionDto> missionDtos = [];

  List<Marker> markerss = [];
  int idrace = 0;
  int id = 1;
  int sq = 0;
  String cb1 = '';
  String cb2 = '';
  String cb3 = '';
  bool isLoaded = false;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  //LatLng centerMap = const LatLng(16.245916, 103.252182);
  // late GoogleMap googleMap;

  @override
  void initState() {
    // intilize();
    super.initState();
    sqnum = context.read<AppData>().sqnum;
    log('lastja ' + sqnum.toString());

    idrace = context.read<AppData>().idrace;
    log('id' + idrace.toString());

    loadDataMethod = loadData();

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // googleMap =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างภารกิจ'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailMission(),
                      settings: const RouteSettings(arguments: null),
                    ));
              },
              icon: const FaIcon(FontAwesomeIcons.flagCheckered))
        ],
      ),
      body: raceMap(),
    );
  }

  raceMap() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return Scaffold(
              body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(children: [
                    GoogleMap(
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
                        target: LatLng(
                            currentLatLng.latitude, currentLatLng.longitude),
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
                        log('lat' + position.target.latitude.toString());
                      },
                    ),
                    Positioned(
                        top: (300 / 2) - 32,
                        left: (MediaQuery.of(context).size.width / 2) - 16,
                        child: Column(
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
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
        });
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ชื่อภารกิจ'),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    controller: nameMission,
                    decoration: const InputDecoration(
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('คำอธิบาย'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: DescriptionMission,
                      decoration: const InputDecoration(
                        hintText: 'คำอธิบาย...',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('กรุณาเลือกประเภทภารกิจ'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
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
                      if (_checkbox == true) {
                        cb1 = '1';
                      } else {
                        cb1 = '';
                        return;
                      }
                      log('cc1: ' + cb1);
                    });
                  },
                ),
                const Text('ข้อความ'),
                Checkbox(
                  value: _checkbox1,
                  onChanged: (value) {
                    setState(() {
                      _checkbox1 = !_checkbox1;

                      if (_checkbox1 == true) {
                        cb2 = '2';
                      } else {
                        cb2 = '';
                        return;
                      }
                      log('cc2: ' + cb2.toString());
                    });
                  },
                ),
                const Text('สื่อ'),
                Checkbox(
                  value: _checkbox2,
                  onChanged: (value) {
                    setState(() {
                      _checkbox2 = !_checkbox2;
                      //   log(_checkbox2.toString());
                      if (_checkbox2 == true) {
                        cb3 = '3';
                      } else {
                        cb3 = '';
                        return;
                      }
                      log('cc3: ' + cb3.toString());
                    });
                  },
                ),
                const Text('ไม่มีการส่ง'),
              ],
            ),
            Center(
              child: ElevatedButton(
                  child: const Text('สร้างภารกิจ'),
                  onPressed: () async {
                    // setState(() {
                      // if(sqnum == 2){
                      //    sqnum = 0;
                      // }
                    //     });
                   //    log('num '+square.toString());
                   if(sqnum == 0){
                     sqnum = sqnum + 1;
                   }
                   if(sqnum == sqnum){
                     sqnum++;
                    } 
                    log('num '+sqnum.toString());

                    if (lats == '' && longs == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาหาจุดภารกิจ...')),
                      );
                    }

                    cb = cb1 + cb2 + cb3;
                    log('ch ' + cb);
                    mType = int.parse(cb);
                    log('ty: ' + mType.toString());
               

                    MissionDto missionDto = MissionDto(
                        misName: nameMission.text,
                        misDiscrip: DescriptionMission.text,
                        misDistance: int.parse(selectedValue!),
                        misType: mType,
                        misSeq: sqnum,
                        misMediaUrl: '',
                        misLat: double.parse(lats),
                        misLng: double.parse(longs),
                        raceId: idrace);
                    log(lats);
                    //print(double.parse('lat'+lats));
                    var mission =
                        await missionService.insertMissions(missionDto);
                    if (mission.response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('mision Successful')),
                      );
                      log("race Successful");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailMission(),
                            settings: const RouteSettings(arguments: null),
                          ));
                      return;
                    } else {
                      // log("team fail");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('mission fail try agin!')),
                      );

                      return;
                    }
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
          hint: Center(
            child: Text(
              'รัศมี',
              style: TextStyle(
                //  fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
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
          buttonStyleData: ButtonStyleData(
              height: 30,
              width: 70,
              // padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.purpleAccent))),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
     startLoading(context);
    try { 
      postion = await determinePosition();
      currentLatLng = LatLng(postion.latitude, postion.longitude);
      isLoaded = true;
    } catch (err) {
      currentLatLng = const LatLng(16.24922394827912, 103.2505221260871);
       isLoaded = false;
      log('Error:$err');
    }
    finally {
      stopLoading();
    }
    
  }

   Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('เกิดข้อผิดพลาด', 'ไม่ได้เปิดระบบระบุพิกัดตำแหน่ง',
          duration: const Duration(seconds: 5),
          colorText: Theme.of(context).colorScheme.onErrorContainer,
          backgroundColor: Theme.of(context).colorScheme.errorContainer);
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('เกิดข้อผิดพลาด', 'ไม่ได้รับอนุญาติให้เข้าถึงพิกัดตำแหน่ง',
            duration: const Duration(seconds: 5),
            colorText: Theme.of(context).colorScheme.onErrorContainer,
            backgroundColor: Theme.of(context).colorScheme.errorContainer);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('เกิดข้อผิดพลาด', 'ไม่ได้รับอนุญาติให้เข้าถึงพิกัดตำแหน่ง',
          duration: const Duration(seconds: 5),
          colorText: Theme.of(context).colorScheme.onErrorContainer,
          backgroundColor: Theme.of(context).colorScheme.errorContainer);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }
    return await Geolocator.getCurrentPosition();
  }
}
