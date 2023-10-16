import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/model/DTO/missionDTO.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';

import 'package:miniworldapp/service/mission.dart';
import 'package:miniworldapp/service/race.dart';
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
  final List<String> items = ['10', '20', '30'];
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
  int lastNum = 0;
  int raceID = 0;
  int sqMis = 0;
  late MissionService missionService;
  late RaceService raceService;
  List<Mission> missions = [];
  List<MissionDto> missionDtos = [];
  final keys = GlobalKey<FormState>();

  List<Marker> markerss = [];
  int idrace = 0;
  int id = 1;
  int sq = 0;
  String cb1 = '';
  String cb2 = '';
  String cb3 = '';
  int fristMis = 0;
  bool isLoaded = false;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  TextEditingController discripText = TextEditingController();

  File? _image;
  UploadTask? uploadTask;
  bool isImage = true;
  String image = '';

  String img = '';
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
    missionService =
        MissionService(Dio(), baseUrl: context.read<AppData>().baseurl);

    raceService = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
    // googleMap =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 239, 150, 255),
        foregroundColor: Colors.white,
        title: const Text('สร้างภารกิจ'),
      ),
      body: raceMap(),
    );
  }

  raceMap() {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => DetailMission());
        return true;
      },
      child: FutureBuilder(
          future: loadDataMethod,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
            }
            return Scaffold(
                backgroundColor: Color.fromARGB(255, 239, 150, 255),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Stack(children: [
                          GoogleMap(
                            // myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            mapType: MapType.hybrid,
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer())
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentLatLng.latitude,
                                  currentLatLng.longitude),
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
                          ),
                          Positioned(
                              top: (300 / 2) - 32,
                              left:
                                  (MediaQuery.of(context).size.width / 2) - 16,
                              child: Column(
                                children: [
                                  Image.asset("assets/image/target.png"),
                                  // Text('Lat:'+lat+',Long:'+long),
                                ],
                              )),
                        ]),
                      ),
                      missionInput(),
                    ],
                  ),
                ));
          }),
    );
  }

  missionInput() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: upImg(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'ชื่อภารกิจ*',
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary),
              ),
            ),
            SizedBox(
              width: 340,
              child: TextFormField(
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onPrimary),
                controller: nameMission,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.white,
                    filled: true,
                    fillColor: Colors.purpleAccent,
                    hintText: 'ชื่อภารกิจ...',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('คำอธิบาย*',
                  style: Get.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onPrimary)),
            ),
            SizedBox(
              width: 340,
              child: TextFormField(
                controller: discripText,
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onPrimary),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Colors.purpleAccent,
                    hintText: 'คำอธิบาย...',
                    hintStyle: TextStyle(color: Colors.white)),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 4,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'รัศมีแจ้งเตือนภารกิจ*',
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: dropdownRadius(),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('กรุณาเลือกประเภทภารกิจ*',
              style: Get.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              fillColor: MaterialStateProperty.resolveWith(getColor),
              checkColor: Colors.white, // color of tick Mark
              value: _checkbox,
              onChanged: _checkbox2 == true
                  ? (value) {
                      setState(() {
                        _checkbox == false;
                      });
                    }
                  : (value) {
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
            Text('ข้อความ',
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary)),
            Checkbox(
              fillColor: MaterialStateProperty.resolveWith(getColor),
              checkColor: Colors.white, // color of tick Mark
              value: _checkbox1,
              onChanged: _checkbox2 == true
                  ? (value) {
                      setState(() {
                        _checkbox1 == false;
                      });
                    }
                  : (value) {
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
            Text('สื่อ',
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary)),
            Checkbox(
                value: _checkbox2,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                checkColor: Colors.white, // color of tick Mark
                //activeColor: Colors.amber,
                onChanged: _checkbox == true || _checkbox1 == true
                    ? (value) {
                        setState(() {
                          _checkbox2 == false;
                        });
                      }
                    : (value) {
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
                      }),
            Text('ไม่มีการส่ง',
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary)),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.amberAccent),
                  ),
                  child: Text('สร้างภารกิจ',
                      style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onPrimary)),
                  onPressed: () async {
                    sqnum = 0;
                    fristMis == 0;
                    setState(() {
                      if (sqnum == 2) {
                        sqnum = 0;
                      }
                    });
                    if (_image == null) {
                      // log("team fail");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กรุณาใส่รูปภาพ...')),
                      );
                      return;
                    }
                    final path = 'files/${_image?.path.split('/').last}';
                    final file = File(_image!.path);
                    final ref = FirebaseStorage.instance.ref().child(path);
                    log(ref.toString());

                    setState(() {
                      uploadTask = ref.putFile(file);
                    });
                    final snapshot = await uploadTask!.whenComplete(() {});

                    final urlDownload = await snapshot.ref.getDownloadURL();
                    log('Download Link:$urlDownload');

                    img = urlDownload;

                    fristMis = lastNum;
                    log('numold ' + fristMis.toString());

                    if (fristMis == 0) {
                      fristMis = fristMis + 1;
                    } else if (fristMis >= 1) {
                      fristMis++;
                    }
                    log('num ' + fristMis.toString());

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
                        misDiscrip: discripText.text,
                        misDistance: int.parse(selectedValue!),
                        misType: mType,
                        misSeq: sqMis,
                        misMediaUrl: urlDownload,
                        misLat: double.parse(lats),
                        misLng: double.parse(longs),
                        raceId: idrace);

                    log(lats);
                    //print(double.parse('lat'+lats));
                    startLoading(context);
                    var mission =
                        await missionService.insertMissions(missionDto);
                    stopLoading();
                    if (mission.response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('สร้างภารกิจสำเร็จ')),
                      );
                      Navigator.of(context).pop();
                      Get.off(() => DetailMission());

                      log("race Successful");

                      // if (fristMis == 0) {
                      //   Get.to(DetailMission());
                      // } else {
                      //   Navigator.of(context).pop();
                      // }
                      //  if()
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
          ),
        ),
      ],
    );
  }

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    File? img = File(image.path!);

    // img = await _cropImage(imageFile: img);
    _image = img;
    setState(() {});
    log(img.path);
  }

  upImg() {
    return _image != null
        ? Stack(
            children: [
              SizedBox(
                width: 320,
                height: 200,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    key: keys,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                          log('message');
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.images,
                          size: 25,
                        ))),
              )
            ],
          )
        : SizedBox(
            width: 250,
            height: 150,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 5),
                  color: Colors.purpleAccent,
                ),
                key: keys,
                child: IconButton(
                    onPressed: () async {
                      _pickImage(ImageSource.gallery);
                      log('message');
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.images,
                      size: 30,
                      color: Get.theme.colorScheme.onPrimary,
                    ))),
          );
  }

  Widget dropdownRadius() {
    return SingleChildScrollView(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              'รัศมี',
              style: Get.textTheme.bodyLarge!
                  .copyWith(color: Get.theme.colorScheme.onPrimary),
                  textAlign: TextAlign.center,
            ),
          ),
          alignment: Alignment.center, 
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyLarge!.copyWith(
                            color: Get.theme.colorScheme.onPrimary),
                            textAlign: TextAlign.center,
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
              width: 140,
             
              // padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                  border: Border.all(color: Colors.purpleAccent))),
          dropdownStyleData: DropdownStyleData(
            offset: Offset(0, 0),
            decoration: BoxDecoration(  

              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.amber;
    }
    return Colors.yellow;
  }

  Future<void> loadData() async {
    startLoading(context);
    try {
      log('aaaa');
      raceID = context.read<AppData>().idrace;

      //log('lasttt '+misID.toString());
      postion = await determinePosition();
      lastNum = context.read<AppData>().sqnum;
      var r = await missionService.missionByraceID(raceID: raceID);

      missions = r.data;
      log("length is ${missions.length}");
      sqMis = missions.length + 1;

      currentLatLng = LatLng(postion.latitude, postion.longitude);
      log('aaaa');
      isLoaded = true;
    } catch (err) {
      currentLatLng = const LatLng(16.24922394827912, 103.2505221260871);
      isLoaded = false;
      log('Error:$err');
    } finally {
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
