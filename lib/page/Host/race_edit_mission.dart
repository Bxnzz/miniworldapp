import 'dart:async';

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miniworldapp/page/Host/detil_mission.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/missionDTO.dart';
import '../../model/mission.dart';
import '../../model/result/raceResult.dart';
import '../../service/mission.dart';
import '../../service/provider/appdata.dart';
import '../../widget/loadData.dart';

class EditMission extends StatefulWidget {
  const EditMission({super.key});

  @override
  State<EditMission> createState() => _EditMissionState();
}

class _EditMissionState extends State<EditMission> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController nameMission = TextEditingController();
  TextEditingController DescriptionMission = TextEditingController();
  final List<String> items = ['10', '20', '30'];
  String? selectedValue;

  bool _checkbox = false;
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _cbN1 = true;
  String lats = '';
  String longs = '';
  String mType = '';
  int mTypeCast = 0;
  final keys = GlobalKey<FormState>();

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
  String UrlImg = '';
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
  File? _image;
  UploadTask? uploadTask;
  bool isImage = true;
  String image = '';

  String img = '';

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
        backgroundColor:Color.fromARGB(255, 232, 147, 247),
        foregroundColor: Colors.white,
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
              icon: FaIcon(FontAwesomeIcons.flagCheckered,color: Colors.white,))
        ],
      ),
      body: raceMap(),
    );
  }

  Future<void> loadData() async {
    startLoading(context);
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
      UrlImg = r.data.first.misMediaUrl;
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
    } finally {
      stopLoading();
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
              backgroundColor: Color.fromARGB(255, 232, 147, 247),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Stack(children: [
                        GoogleMap(
                          //  myLocationEnabled: true,
                          // myLocationButtonEnabled: true,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer())
                          },
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
                ),
              ));
        });
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
                controller: DescriptionMission,
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
              child: dropdownRadius(dd),
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
          child: SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                 style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.amberAccent),
                      ),
                  child: Text('แก้ไขภารกิจ',
                          style: Get.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onPrimary)),
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
                width: 250,
                height: 150,
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
        : Stack(
            children: [
              SizedBox(
                width: 250,
                height: 150,
                child: UrlImg != ''
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                        key: keys,
                        child: Image.network(
                          UrlImg,
                          fit: BoxFit.cover,
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white, width: 5),
                            color: Colors.purpleAccent),
                        key: keys,
                        child: IconButton(
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                              log('message');
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.images,
                              size: 25,
                              color: Colors.white,
                            ))),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: UrlImg != ''
                    ? Container(
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
                            )))
                    : Container(),
              )
            ],
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

  Widget dropdownRadius(String radius) {
    return SingleChildScrollView(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Text(
                'รัศมี',
                style: Get.textTheme.bodyLarge!
                    .copyWith(color: Get.theme.colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          alignment: Alignment.center,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyLarge!
                            .copyWith(color: Get.theme.colorScheme.onPrimary),
                        textAlign: TextAlign.center,
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
}
