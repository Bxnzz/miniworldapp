import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/missionComp.dart' as misComp;
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/player_race_start_menu.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:provider/provider.dart';

import '../../model/mission.dart';
import '../../service/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStartHint extends StatefulWidget {
  const PlayerRaceStartHint({super.key});

  @override
  State<PlayerRaceStartHint> createState() => _PlayerRaceStartHintState();
}

class _PlayerRaceStartHintState extends State<PlayerRaceStartHint> {
  late MissionCompService missionCompService;
  late MissionService missionService;

  late int teamID;
  late int raceID;
  late int misID;
  late int misDistance;
  late double lngDevice, latDevice;
  late double lat = 0;
  late double lng = 0;
  late double dis;
  List<Marker> markerss = [];
  late List<Mission> mission;
  late List<misComp.MissionComplete> missionComp;

  Set<Polyline> _polylines = Set<Polyline>();
  Completer<GoogleMapController> _controller = Completer();

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  late Future loadDataMethod;

  late StreamSubscription<Position> positionStream;
  @override
  void initState() {
    checkGps();
    teamID = context.read<AppData>().idTeam;
    raceID = context.read<AppData>().idrace;
    misID = context.read<AppData>().idMis;
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = LoadData();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    lngDevice = position.longitude;
    latDevice = position.latitude;

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      lngDevice = position.longitude;
      latDevice = position.latitude;

      setState(() {
        //refresh UI on update
      });
    });
  }

  Future<void> LoadData() async {
    try {
      var a = await missionCompService.missionCompByTeamId(teamID: teamID);

      var mis = await missionService.missionByraceID(raceID: raceID);

      missionComp = a.data;
      // mission = m.data;
      mission = mis.data;
      missionComp = a.data;
      lat = a.data.first.mcLat;
      lng = a.data.first.mcLng;
      misID = mis.data.first.misId;
      misDistance = mis.data.first.misDistance;
      log(" Latti ==== $latDevice long === $lngDevice");
    } catch (err) {
      log('Error:$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    String lats = '';
    String longs = '';

    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            for (int i = 0; i < mission.length; i++) {
              for (int j = 0; j < missionComp.length; j++) {
                if (missionComp[j].misId == mission[i].misId &&
                    missionComp[j].mcStatus == 2) {
                  log("pass ${mission[i].misId}");
                  if (i + 1 > mission.length - 1) {
                    log("next ${mission[i].misId}");
                  } else {
                    log("next ${mission[i + 1].misId}");
                    log("lat lng${mission[i + 1].misLat}${mission[i + 1].misLng}");

                    lat = mission[i + 1].misLat;
                    lng = mission[i + 1].misLng;
                    misID = mission[i + 1].misId;
                    misDistance = mission[i + 1].misDistance;
                    log("mis id = ${misID}");
                    log("distance = ${misDistance}");
                  }
                }
              }
            }

            return Column(
              children: [
                Text('แผนที่'),
                GMap(lats, longs, context),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dis = Geolocator.distanceBetween(
                              latDevice, lngDevice, lat, lng);
                        });
                        dis <= misDistance
                            ? showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('เจอแล้ว !!!'),
                                  content: Text(
                                    "อยู่ในบริเวณภารกิจแล้ว",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          misID = context.read<AppData>().idMis;

                                          Get.to(() => PlayerRaceStartMenu());
                                        },
                                        child: const Text('ดูรายละเอียด'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('ห่างจากภารกิจ'),
                                  content: Text(
                                    dis.toStringAsFixed(1) + "เมตร",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                      child: FaIcon(FontAwesomeIcons.question)),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Expanded GMap(String lats, String longs, BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: Get.height * 0.9,
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
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
                lats = position.target.latitude.toString();
                longs = position.target.longitude.toString();
                log('lat' + position.target.latitude.toString());
                log('lng' + position.target.longitude.toString());
              },
            ),
            Positioned(
                top: (Get.height / 2) - 125,
                left: (Get.width / 2) - 10,
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 32,
                      color: Colors.yellowAccent,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
