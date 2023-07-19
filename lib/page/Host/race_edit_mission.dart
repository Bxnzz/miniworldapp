import 'dart:async';

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/missionDTO.dart';
import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';

class EditMission extends StatefulWidget {
  const EditMission({super.key});

  @override
  State<EditMission> createState() => _EditMissionState();
}

class _EditMissionState extends State<EditMission> {
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
  bool _cbN1 = true;
  String lats = '';
  String longs = '';
  String mType = '';
  int mTypeCast = 0;

  late MissionService missionService;
  List<Mission> missions = [];
  List<MissionDto> missionDtos = [];

  List<Marker> markerss = [];
  String idM = '';
  int idrace = 0;
  int id = 1;
  int sq = 0;
  int misID = 0;
  double lat = 0.0;
  double lng = 0.0;
  String dd = '';
  String cb = '';
  String cb1 = '';
  String cb2 = '';
  String cb3 = '';
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  // LatLng centerMap = const LatLng(16.245916, 103.252182);
  late GoogleMap googleMap;
//  LatLng centerMap = const LatLng(16.245916, 103.252182);
  late RaceResult misResults;
  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();

    misID = context.read<AppData>().idMis;
    log('id ' + misID.toString());

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();

    missionService.missionBymisID(misID: misID).then((value) {
      log(value.data.first.misName);
      // log('lat '+lat.toString() +' lng '+lng.toString());
    });
    // googleMap =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขการแข่งขัน'),
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

  Future<void> loadData() async {
    try {
      var r = await missionService.missionBymisID(misID: misID);
      missions = r.data;
      log(r.data.first.misName);
      // idM = r.data.first.misName.toString();
      nameMission.text = r.data.first.misName.toString();
      DescriptionMission.text = r.data.first.misDiscrip.toString();
      // log(idM.toString());
      mType = r.data.first.misType.toString();
      dd = r.data.first.misDistance.toString();
      lat = r.data.first.misLat;
      lng = r.data.first.misLng;
      sq = r.data.first.misSeq;
      log('lat ' + lat.toString() + lng.toString());

      var splitT = mType.split('');
      log(splitT.toString());
      List<String> substrings = splitT.toString().split(",");
      //substrings = splitT.toString().substring("[");
      log('sub ' + splitT.contains('0').toString());

      if (splitT.contains('1') == true) {
        setState(() {
          _checkbox = true;
          if (_checkbox == true) {
            cb1 = '1';
            log('cc ' + cb1);
          } else {
            cb1 = '';
            return;
          }
        });
      }
      if (splitT.contains('2') == true) {
        setState(() {
          _checkbox1 = true;
          if (_checkbox1 == true) {
            cb2 = '2';
            log('cc ' + cb2);
          } else {
            cb2 = '';
            return;
          }
        });
      }
      if (splitT.contains('3') == true) {
        setState(() {
          _checkbox2 = true;
          if (_checkbox2 == true) {
            cb3 = '3';
            log('cc ' + cb3);
          } else {
            cb3 = '';
            return;
          }
        });
      } else {
        return;
      }
      //raceName.txt = r.data.first.raceName;
      // lat = r.data.first.misLat;
      // lng = r.data.first.misLng;
      // log('lat '+lat.toString() +'lng '+lng.toString());
    } catch (err) {
      log(err.toString());
    }
  }

  raceMap() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return Scaffold(
              body: Column(
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
                      target: LatLng(lat, lng),
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
                        children: [
                            Image.asset("assets/image/target.png"),
                        ],
                      )),
                ]),
              ),
              missionInput(),
            ],
          ));
        });
  }

  missionInput() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
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
                    padding: const EdgeInsets.all(8.0),
                    child: dropdownRadius(dd))
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

                        //  _checkbox = true;
                      });
                    }),
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
                  child: Text('แก้ไขภารกิจ'),
                  onPressed: () async {
                    cb = cb1 + cb2 + cb3;
                    log('ch ' + cb);
                    mTypeCast = int.parse(cb);
                    log('ty: ' + mTypeCast.toString());

                    if (lats == '' && longs == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาหาจุดภารกิจ...')),
                      );
                    }

                    MissionDto missionDto = MissionDto(
                        misName: nameMission.text,
                        misDiscrip: DescriptionMission.text,
                        misDistance: int.parse(selectedValue!),
                        misType: mTypeCast,
                        misSeq: sq,
                        misMediaUrl: '',
                        misLat: double.parse(lats),
                        misLng: double.parse(longs),
                        raceId: idrace);
                    // log(jsonEncode(missionDto));
                    log(('lat' + lats));
                    var mission = await missionService.updateMis(
                        missionDto, misID.toString());
                    misResults = mission.data;
                    if (misResults.result == "1") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('update Successful')),
                      );
                      log("mission Successful");
                     Navigator.of(context).pop();
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

  Widget dropdownRadius(String radius) {
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
          value: selectedValue == null ? selectedValue = dd : selectedValue,
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
}
