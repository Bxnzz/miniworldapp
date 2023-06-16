import 'dart:developer';
import 'dart:io';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/raceDTO.dart';
import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/textfieldDate.dart';
import '../../widget/textfildTime.dart';

class EditRace extends StatefulWidget {
  const EditRace({super.key});

  @override
  State<EditRace> createState() => _EditRaceState();
}

class _EditRaceState extends State<EditRace> {
  late RaceService raceservice;
  bool shadowColor = false;
  TextEditingController raceName = TextEditingController();
  TextEditingController raceLocation = TextEditingController();
  TextEditingController raceLimit = TextEditingController();
  TextEditingController raceImage = TextEditingController();

  TextEditingController singUpST = TextEditingController();
  TextEditingController singUpFN = TextEditingController();
  TextEditingController raceTimeST = TextEditingController();
  TextEditingController raceTimeFN = TextEditingController();
  TextEditingController eventDatetime = TextEditingController();
  
  final keys = GlobalKey<FormState>();

  File? pickedFile;
  UploadTask? uploadTask;
  bool isImage = true;
  String image = '';

  String img = '';

  DateTime dateTime = DateTime(2023, 03, 24, 5, 30);
  int idUser = 0;
  int idrace = 0;
  String idR = '';
  String UrlImg = '';
 
  TextEditingController TexttimeST = TextEditingController();
  TextEditingController TexttimeFN = TextEditingController();
  TextEditingController TexttimeDate = TextEditingController();
  
  late RaceResult raceResults;
  List<Race> races = [];
  late Future<void> loadDataMethod;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    singUpST.text = "";
    raceservice = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    idrace = context.read<AppData>().idrace;
    log("idRace: $idrace");
    raceservice.racesByraceID(raceID: idrace).then((value) {
      log(value.data.first.raceName);
    });
    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.circleChevronLeft,
              color: Colors.yellow,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: buildrace());
  }

  Future<void> loadData() async {
    try {
      var r = await raceservice.racesByraceID(raceID: idrace);
      races = r.data;
      log(r.data.first.raceName);
      idR = r.data.first.raceId.toString();
      log(idR.toString());
      raceName.text = r.data.first.raceName;
      raceLocation.text = r.data.first.raceLocation;
      raceLimit.text = r.data.first.raceLimitteam.toString();
      String formattedDate01 = DateFormat.Hm().format(r.data.first.raceTimeSt);
      raceTimeST.text = formattedDate01;
      String formattedDate02 = DateFormat.Hm().format(r.data.first.raceTimeSt);
      raceTimeFN.text = formattedDate02;
      var formatter = DateFormat.yMMMd();
      var dateFormat01 =
          formatter.formatInBuddhistCalendarThai(r.data.first.signUpTimeSt);
      var dateFormat02 =
          formatter.formatInBuddhistCalendarThai(r.data.first.signUpTimeFn);
      var dateFormat03 =
          formatter.formatInBuddhistCalendarThai(r.data.first.eventDatetime);
      singUpST.text = dateFormat01;
      singUpFN.text = dateFormat02;
      eventDatetime.text = dateFormat03;

      UrlImg = r.data.first.raceImage;
      log(UrlImg);
    } catch (err) {
      log(err.toString());
    }
  }

  Widget buildrace() {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: FutureBuilder(
        future: loadDataMethod,
        builder: (context,snapshot) {
          if(snapshot.connectionState != ConnectionState.done){
            return Container();
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.purpleAccent,
                  Colors.blue,
                ])),
            child: SingleChildScrollView(
              child: Center(
                  child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                    Card(
                      margin: EdgeInsets.fromLTRB(32, 95, 32, 32),
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: upImg(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 240,
                                child: textField(raceName, 'ชื่อการแข่งขัน...',
                                    'ชื่อการแข่งขัน', 'กรุณากรอกชื่อการแข่งขัน'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 240,
                                child: textField(raceLocation, 'สถานที่แข่งขัน...',
                                    'สถานที่', 'กรุณากรอกสถานที่'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: textField(raceLimit, 'จำนวนทีม...',
                                        'จำนวนทีม', 'กรุณากรอกจำนวนทีม'),
                                  ),
                                  Text('ทีม')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                    width: 240,
                                    child: SizedBox(
                                      child: TextFieldDate(
                                          controller: singUpST,
                                          hintText: '00/00/0000',
                                          labelText: 'วันที่เปิดรับสมัคร',
                                          dates: TexttimeST),
                                          
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                    width: 240,
                                    child: SizedBox(
                                      child: TextFieldDate(
                                          controller: singUpFN,
                                          hintText: '00/00/0000',
                                          labelText: 'วันที่ปิดรับสมัคร',
                                          dates: TexttimeFN),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                    width: 240,
                                    child: SizedBox(
                                      child: TextFieldDate(
                                          controller: eventDatetime,
                                          hintText: '00/00/0000',
                                          labelText: 'วันจัดการแข่งขัน',
                                          dates: TexttimeDate,
                                          ),
                                    )),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SizedBox(
                                        width: 120,
                                        child: SizedBox(
                                          child: TextFieldTime(
                                              controller: raceTimeST,
                                              hintText: '00:00',
                                              labelText: 'เวลาเริ่มแข่งขัน',
                                            ),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SizedBox(
                                        width: 120,
                                        child: SizedBox(
                                          child: TextFieldTime(
                                              controller: raceTimeFN,
                                              hintText: '00:00',
                                              labelText: 'เวลาจบแข่งขัน'),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                       if (keys.currentState!.validate()) {}
                                    if (raceLimit.text == "") {
                                      // log("team fail");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'กรุณากรอกข้อมูลให้ครบถ้วน...')),
                                      );

                                      return;
                                    }
                                    final path =
                                        'files/${pickedFile?.path.split('/').last}';
                                    final file = File(pickedFile!.path);
                                    final ref =
                                        FirebaseStorage.instance.ref().child(path);
                                    log(ref.toString());

                                    setState(() {
                                      uploadTask = ref.putFile(file);
                                    });
                                    final snapshot =
                                        await uploadTask!.whenComplete(() {});

                                    final urlDownload =
                                        await snapshot.ref.getDownloadURL();
                                    log('Download Link:$urlDownload');

                                    img = '';
                                    log("name"+raceName.text);
                                    log('date '+TexttimeST.text);
                                    log('date '+TexttimeFN.text);
                                    log('date '+TexttimeDate.text);
                                    RaceDto dto = RaceDto(
                                      raceName: raceName.text,
                                      raceLocation: raceLocation.text,
                                      raceLimitteam: int.parse(raceLimit.text),
                                      raceImage: urlDownload,
                                      signUpTimeSt:
                                          DateTime.parse("2002-03-14T00:00:00Z"),
                                      eventDatetime:
                                          DateTime.parse("2002-03-14T00:00:00Z"),
                                      raceStatus: 0,
                                      raceTimeFn:
                                          DateTime.parse("2002-03-14T00:00:00Z"),
                                      raceTimeSt:
                                          DateTime.parse("2002-03-14T00:00:00Z"),
                                      userId: idUser,
                                      signUpTimeFn:
                                          DateTime.parse("2002-03-14T00:00:00Z"),
                                    );
                                   var race = await raceservice.updateRaces(dto,idR);
                                  // log('raceee'+race.data.raceName);
                                   raceResults =race.data;
                                    if (raceResults.result == "1") {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('race Successful')),                                    
                                      );
                                      
                                      log("race Successful");
                                      
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => RacePointMap(
                                      //           idrace: race.data.raceId),
                                      //       settings:
                                      //           RouteSettings(arguments: null),
                                      //     ));
                                    return;
                                    } else {
                                      // log("team fail");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('race fail try agin!')),
                                      );

                                      return;
                                     }
                                  },
                                  child: const Text("แก้ไข")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 222, 72, 249),
                            border: Border.all(color: Colors.white, width: 3),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text('แก้ไขการแข่งขัน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18)),
                        ),
                      ),
                    )
                  ])),
            ),
          );
        }
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  textField(final TextEditingController controller, String hintText,
      String labelText, String error) {
    return Form(
      //key: keys,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration:
                InputDecoration(hintText: hintText, labelText: labelText),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return error;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    File file;
    PlatformFile platFile;
    if (result == null) return;
    platFile = result.files.single;
    file = File(platFile.path!);
    pickedFile = file;

    log(result.files.single.toString());
    log(platFile.extension.toString());
    if (platFile.extension == 'jpg' || platFile.extension == 'png') {
      setState(() {
        isImage = true;
      });
    } else {
      isImage = false;
    }
  }

  upImg() {
    return GestureDetector(
        onTap: () {
          selectFile();
          log('message');
        },
        child: pickedFile != null
            ? CircleAvatar(
                key: keys,
                radius: 35.0,
                backgroundImage: FileImage(pickedFile!))
            : CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(UrlImg),
                child: GestureDetector(
                  onTap: () {
                    selectFile();
                    log('message');
                  },
                  // child: FaIcon(FontAwesomeIcons.images),
                )));
  }
}
