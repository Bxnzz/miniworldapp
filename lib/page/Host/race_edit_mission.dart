import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String lats = '';
  String longs = '';
  var square = 0;
  late MissionService missionService;
  List<Mission> missions = [];
  List<MissionDto> missionDtos = [];

  List<Marker> markerss = [];
  String idM = '';
  int idrace = 0;
  int id = 1;
  int sq = 0;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  LatLng centerMap = const LatLng(16.245916, 103.252182);
  late GoogleMap googleMap;

  late RaceResult misResults;
  late Future<void> loadDataMethod;
  
  @override
  void initState() {
    
    super.initState();

    idrace = context.read<AppData>().idrace;
    log('id'+idrace.toString());

    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    
     missionService.missionByraceID(raceID: idrace).then((value) {
      log(value.data.first.misName);
    });
    loadDataMethod = loadData();

    googleMap = GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    
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
        
        lats = position.target.latitude.toString();
        longs = position.target.longitude.toString();
        log('lat' + position.target.latitude.toString());
      },
    );
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
      var r = await missionService.missionByraceID(raceID: idrace);
      missions = r.data;
      log(r.data.first.misName);
      idM = r.data.first.raceId.toString();
      log(idM.toString());
      //raceName.txt = r.data.first.raceName;
      
    } catch (err) {
      log(err.toString());
    }
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
                  onPressed: () async {
                  
                   
                // setState(() {
                //   if(square == 2){
                //      square = 0;  
                //   } 
                //     });
                //   log('num '+square.toString());
                    // if(squarePlus < 0){
                    //   squarePlus ==  squarePlus++;
                    //   log('num '+squarePlus.toString());
                    // } 
                     if(lats ==''&&longs ==''){
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาหาจุดภารกิจ...')),
                      );
                     }
                    // MissionDto missionDto = MissionDto(
                    //     misName: nameMission.text,
                    //     misDiscrip: DescriptionMission.text,
                    //     misDistance: int.parse(selectedValue!),
                    //     misType: 0,
                    //     misSeq: 0,
                    //     misMediaUrl: '',
                    //     misLat: double.parse(lats),
                    //     misLng: double.parse(longs),
                    //     raceId: idrace);
                    // log(lats);
                    //print(double.parse('lat'+lats));
                    // var mission =
                    //     await missionService.insertMissions(missionDto);
                    // if (mission.response.statusCode == 200) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('mision Successful')),
                    //   );
                    //   log("race Successful");
                    //   Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const DetailMission(),
                    //         settings:
                    //             const RouteSettings(arguments: null),
                    //       ));
                    //   return;
                    // } else {
                    //   // log("team fail");
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('mission fail try agin!')),
                    //   );

                    //  return;
                    // }
                    
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
}


