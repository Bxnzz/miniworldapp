import 'dart:async';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miniworldapp/model/DTO/attendLatLngDTO.dart';
import 'package:miniworldapp/model/missionComp.dart' as misComp;
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/General/home_join_detail.dart';
import 'package:miniworldapp/page/Player/player_race_start_menu.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.dart';
import 'package:miniworldapp/page/Player/player_race_start_mission.detail.dart';
import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:animated_button/animated_button.dart' as anm;

import '../../model/DTO/missionCompDTO.dart';
import '../../model/mission.dart';
import '../../service/attend.dart';
import '../../service/missionComp.dart';
import '../../service/provider/appdata.dart';

class PlayerRaceStartHint extends StatefulWidget {
  const PlayerRaceStartHint({super.key, required this.controller});

  final PersistentTabController controller;
  @override
  State<PlayerRaceStartHint> createState() => _PlayerRaceStartHintState();
}

class _PlayerRaceStartHintState extends State<PlayerRaceStartHint> {
  late MissionCompService missionCompService;
  late MissionService missionService;
  late AttendService attendService;

  late int teamID;
  late int raceID;
  late int misID;
  late int misDistance = 0;
  int misSeq = 0;
  int indexpage = 1;
  int idAttend = 0;

  late double lngDevice, latDevice;
  late double lat = 0;
  late double lng = 0;
  late double latplot = 0;
  late double lngplot = 0;
  late double dis = 0;
  late String misName;
  late String misDescrip;
  late String misType = '';
  late String type = '';
  String dateTime = "";
  bool lastmisComp = false;

  late List<Marker> markerss = [];
  late List<Mission> mission;
  late List<misComp.MissionComplete> missionComp;

  Set<Polyline> _polylines = Set<Polyline>();
  Completer<GoogleMapController> _controller = Completer();

  bool servicestatus = false;
  bool haspermission = false;
  bool disableGmap = true;
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
    idAttend = context.read<AppData>().idAt;
    missionCompService =
        MissionCompService(Dio(), baseUrl: context.read<AppData>().baseurl);
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    attendService =
        AttendService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = LoadData();
    log("team id = $teamID");
    log("$lat $lng");
    log("AttendID = $idAttend");
    //showAlertDialog();

    context.read<AppData>().updateLocationTimerPlayer =
        Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateLocation();
    });
    log('Start Timer');
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
    log('xxxxxxx' + position.longitude.toString()); //Output: 80.24599079
    log(position.latitude.toString()); //Output: 29.6593457

    lngDevice = position.longitude;
    latDevice = position.latitude;

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position position) {
    //   print(position.longitude); //Output: 80.24599079
    //   print(position.latitude); //Output: 29.6593457

    //   lngDevice = position.longitude;
    //   latDevice = position.latitude;

    //   setState(() {
    //     //refresh UI on update
    //   });
    // });
  }

  Future<void> LoadData() async {
    startLoading(context);
    try {
      checkGps();
      var a = await missionCompService.missionCompByTeamId(teamID: teamID);

      var mis = await missionService.missionByraceID(raceID: raceID);

      missionComp = a.data;
      // mission = m.data;
      mission = mis.data;
      missionComp = a.data;

      misID = mis.data.first.misId;
      misName = mis.data.first.misName;
      misDescrip = mis.data.first.misDiscrip;
      misType = mis.data.first.misType.toString();
      misDistance = mis.data.first.misDistance;

      log("lastmisComp" + lastmisComp.toString());
      log("msi id = ${misID}");
    } catch (err) {
      log('Error:$err');
    } finally {
      stopLoading();
    }
  }

  Future refresh() async {
    setState(() {
      loadDataMethod = LoadData();
    });
  }

  Future<void> _updateLocation() async {
    log("LAT $latDevice");
    AttendLatLngDto atDto = AttendLatLngDto(lat: latDevice, lng: lngDevice);

    try {
      var a = await attendService.updateLatLngattendByAtID(atDto, idAttend);
    } catch (e) {
      log('abc ' + (e as DioError).response!.data.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            log("dis ${dis}");
            for (int i = 0; i < mission.length; i++) {
              //first mis
              if (i == 0) {
                log("first Mis");
                lat = mission[0].misLat;
                lng = mission[0].misLng;

                misID = mission[0].misId;
                misSeq = mission[0].misSeq;
                misName = mission[0].misName;
                misDistance = mission[0].misDistance;
                misDescrip = mission[0].misDiscrip;
                misType = mission[0].misType.toString();
                if (misType.contains('12')) {
                  type = 'ข้อความ,สื่อ';
                } else if (misType.contains('1')) {
                  type = 'ข้อความ';
                } else if (misType.contains('2')) {
                  type = 'สื่อ';
                } else if (misType.contains('3')) {
                  type = 'ไม่มีการส่ง';
                }
              }

              for (int j = 0; j < missionComp.length; j++) {
                if (missionComp[j].misId == mission[i].misId &&
                    missionComp[j].mcStatus == 2) {
                  log("pass ${mission[i].misId}");

                  if (i + 1 > mission.length - 1) {
                    log("next ${mission[i].misId}");

                    lastmisComp = true;

                    if (lastmisComp == true) {
                      disableGmap = false;
                    }
                    // showAlertDialog();
                  } else {
                    log("next ${mission[i + 1].misId}");
                    log("lat lng${mission[i + 1].misLat}${mission[i + 1].misLng}");

                    lat = mission[i + 1].misLat;
                    lng = mission[i + 1].misLng;

                    log("lat $lat");
                    log("lng $lng");
                    misID = mission[i + 1].misId;
                    misName = mission[i + 1].misName;
                    misSeq = mission[i + 1].misSeq;
                    misDistance = mission[i + 1].misDistance;
                    misDescrip = mission[i + 1].misDiscrip;
                    misType = mission[i + 1].misType.toString();
                    if (misType.contains('12')) {
                      type = 'ข้อความ\,สื่อ';
                    } else if (misType.contains('1')) {
                      type = 'ข้อความ';
                    } else if (misType.contains('2')) {
                      type = 'สื่อ';
                    } else if (misType.contains('3')) {
                      type = 'ไม่มีการส่ง';
                    }
                    log("mis id = ${misID}");
                    log("distance = ${misDistance}");
                    // if (i == mission.length) {
                    //   log("message");
                    // }
                  }
                } else {
                  log("not match;");
                }
              }
            }
            return RefreshIndicator(
              onRefresh: refresh,
              child: SafeArea(
                child: Stack(
                  children: [
                    GMap(context),
                    lastmisComp == false
                        ? misType == '3'
                            //mission type = 3
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: antBTN3(context)))
                            //mission type 1
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: antBTN(context)))
                        : Container(),
                    lastmisComp == true
                        ? Positioned(
                            top: (Get.height / 2) - 125,
                            left: 20,
                            right: 20,
                            child: AlertDialog(
                              shadowColor: Colors.black,
                              title: Text("ยินดีด้วย !!!"),
                              content: Text("ทีมคุณผ่านภารกิจทั้งหมดแล้ว"),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  antBTN(BuildContext context) {
    return Container(
        height: 130,
        child: anm.AnimatedButton(
          shape: BoxShape.circle,
          height: 120,
          color: Colors.amber,
          onPressed: () {
            checkGps();

            dis = Geolocator.distanceBetween(latDevice, lngDevice, lat, lng);
            dis <= misDistance
                ? AwesomeDialog(
                    transitionAnimationDuration:
                        const Duration(milliseconds: 100),
                    context: context,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.infoReverse,
                    title: 'เจอแล้ว !!!',
                    desc:
                        'ภารกิจลำดับที่ :$misSeq\nชื่อภารกิจ : $misName \nรายละเอียด : $misDescrip \nประเภทภารกิจ : $type',
                    btnOkText: 'ดูรายละเอียด',
                    btnOkOnPress: () {
                      context.read<AppData>().idMis = misID;
                      context.read<AppData>().idTeam = teamID;
                      context.read<AppData>().latMiscomp = latDevice;
                      context.read<AppData>().lngMiscomp = lngDevice;

                      setState(() {
                        loadDataMethod = LoadData();
                      });
                      widget.controller.index = 0;
                      context.read<AppData>().isSubmit = false;
                      setState(() {});
                      Get.to(() => PlayerRaceStMisDetail(),
                          fullscreenDialog: true);
                    },
                  ).show()
                : AwesomeDialog(
                    transitionAnimationDuration: Duration(milliseconds: 100),
                    context: context,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.question,
                    title: 'ห่างจากภารกิจ ',
                    desc: '${dis.toStringAsFixed(1)} เมตร',
                    btnOkText: 'ตกลง',
                    btnOkOnPress: () {
                      dis = Geolocator.distanceBetween(
                          latDevice, lngDevice, lat, lng);
                    },
                  ).show();
          },
          child: Text(
            "ค้นหา",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ));
  }

  antBTN3(BuildContext context) {
    return Container(
      height: 130,
      child: anm.AnimatedButton(
        shape: BoxShape.circle,
        height: 120,
        color: Colors.amber,
        onPressed: () {
          checkGps();
          dis = Geolocator.distanceBetween(latDevice, lngDevice, lat, lng);
          dis <= misDistance
              ? AwesomeDialog(
                  transitionAnimationDuration: Duration(milliseconds: 100),
                  context: context,
                  headerAnimationLoop: false,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.infoReverse,
                  title: 'เจอแล้ว !!!',
                  desc:
                      'ภารกิจลำดับที่ : $misSeq\nชื่อภารกิจ : $misName \nรายละเอียด : $misDescrip \nประเภทภารกิจ : $type',
                  btnOkText: 'สำเร็จ',
                  btnOkOnPress: () async {
                    final now = DateTime.now();
                    dateTime = '${now.toIso8601String()}Z';
                    MissionCompDto mdto = MissionCompDto(
                        mcDatetime: DateTime.parse(dateTime),
                        mcLat: latDevice,
                        mcLng: lngDevice,
                        mcMasseage: '',
                        mcPhoto: '',
                        mcStatus: 2,
                        mcText: '',
                        mcVideo: '',
                        misId: misID,
                        teamId: teamID);
                    var missionComp =
                        await missionCompService.insertMissionComps(mdto);
                    context.read<AppData>().latMiscomp = latDevice;
                    context.read<AppData>().lngMiscomp = lngDevice;
                    context.read<AppData>().isSubmit = false;
                    setState(() {
                      loadDataMethod = LoadData();
                    });

                    loadDataMethod = LoadData();
                  },
                ).show()
              : AwesomeDialog(
                  transitionAnimationDuration: Duration(milliseconds: 100),
                  context: context,
                  headerAnimationLoop: false,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.question,
                  title: 'ห่างจากภารกิจ ',
                  desc: '${dis.toStringAsFixed(1)} เมตร',
                  btnOkText: 'ตกลง',
                  btnOkOnPress: () {
                    dis = Geolocator.distanceBetween(
                        latDevice, lngDevice, lat, lng);
                  },
                ).show();
        },
        child: Text(
          "ค้นหา",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  btnMisType1_2(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await getLocation();
          dis = Geolocator.distanceBetween(latDevice, lngDevice, lat, lng);
          dis <= misDistance
              ? showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(child: const Text('เจอแล้ว !!!')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#$misID"),
                        Text(
                          "ชื่อภารกิจ : $misName",
                          textAlign: TextAlign.center,
                        ),
                        Text("รายละเอียด : $misDescrip"),
                        Text("ประเภทภารกิจ : " + type)
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          context.read<AppData>().idMis = misID;
                          context.read<AppData>().idTeam = teamID;
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           const PlayerRaceStartMenu(),
                          //     ));
                        },
                        child: const Text('ดูรายละเอียด'),
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
                          onPressed: () {
                            dis = Geolocator.distanceBetween(
                                latDevice, lngDevice, lat, lng);

                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                );
        },
        child: FaIcon(FontAwesomeIcons.question));
  }

  btnMisType3(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            dis = Geolocator.distanceBetween(latDevice, lngDevice, lat, lng);
          });
          //distance of mission
          dis <= misDistance
              ? showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('เจอแล้ว ไปต่อได้!!!'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#$misID"),
                        Text(
                          "ชื่อภารกิจ : $misName",
                          textAlign: TextAlign.center,
                        ),
                        Text("รายละเอียด : $misDescrip"),
                        Text("ประเภทภารกิจ : $type")
                      ],
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            dateTime = '${now.toIso8601String()}Z';
                            MissionCompDto mdto = MissionCompDto(
                                mcDatetime: DateTime.parse(dateTime),
                                mcLat: latDevice,
                                mcLng: lngDevice,
                                mcMasseage: '',
                                mcPhoto: '',
                                mcStatus: 2,
                                mcText: '',
                                mcVideo: '',
                                misId: misID,
                                teamId: teamID);
                            var missionComp = await missionCompService
                                .insertMissionComps(mdto);

                            setState(() {
                              dis = Geolocator.distanceBetween(
                                  latDevice, lngDevice, lat, lng);
                              loadDataMethod = LoadData();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('สำเร็จ'),
                        ),
                      ),
                    ],
                  ),
                )
              : showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('ห่างจากภารกิจ '),
                    content: Text(
                      dis.toStringAsFixed(1) + "เมตร",
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              dis = Geolocator.distanceBetween(
                                  latDevice, lngDevice, lat, lng);
                              loadDataMethod = LoadData();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                );
        },
        child: FaIcon(FontAwesomeIcons.question));
  }

  GMap(BuildContext context) {
    return GoogleMap(
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,

      zoomGesturesEnabled: disableGmap,
      scrollGesturesEnabled: disableGmap,
      tiltGesturesEnabled: disableGmap,
      rotateGesturesEnabled: disableGmap,
      zoomControlsEnabled: disableGmap,

      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16,
      ),
      // onMapCreated: (GoogleMapController controller) {
      //   _controller.complete(controller);
      // },
      //  markers: markerss.map((e) => e).toSet(),

      // onCameraMove: (position) {
      //   // lat = position.target.latitude;
      //   // lng = position.target.longitude;
      //   log('lat' + position.target.latitude.toString());
      //   log('lng' + position.target.longitude.toString());
      // },
    );
  }
}
