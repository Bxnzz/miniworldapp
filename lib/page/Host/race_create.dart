import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/page/Host/race_create_pointmap.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/raceDTO.dart';
import '../../service/provider/appdata.dart';

class RaceCreatePage extends StatefulWidget {
  const RaceCreatePage({super.key});

  @override
  State<RaceCreatePage> createState() => _RaceCreatePageState();
}

class _RaceCreatePageState extends State<RaceCreatePage> {
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

  DateTime dateTime = DateTime(2023, 03, 24, 5, 30);
  int idUser = 0;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    singUpST.text = "";
    raceservice = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    idUser = context.read<AppData>().idUser;
    // log(idUser.toString());
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

  Widget buildrace() {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: Container(
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
                     child: uploadImage(),
                    ), 
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: SizedBox(
                          width: 240,
                          child: textField(raceName, 'ชื่อการแข่งขัน...', 'ชื่อการแข่งขัน'),
                        ),
                     ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                     child: SizedBox(
                        width: 240,
                        child: textField(raceLocation, 'สถานที่แข่งขัน...', 'สถานที่'),
                      ),
                    ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 140,
                        child: textField(raceLimit, 'จำนวนทีม...', 'จำนวนทีม'),
                      ),
                      Text('ทีม')
                    ],
                   ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: singUpST,
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            pickDateTime();
                          });
                          singUpST.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
                        },
                        decoration: InputDecoration(
                            icon: Icon(Icons.dangerous_outlined),
                            label: Text('enter date time')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: singUpFN,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'วันที่ปิดรับสมัคร',
                          icon: Icon(Icons.dangerous_outlined),
                        ),
                        onTap: () {
                          setState(() {
                            pickDateTime();
                          });
                          singUpFN.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'เวลาเริ่มการแข่งขัน',
                          icon: Icon(Icons.timer),
                        ),
                        controller: raceTimeST,
                        onTap: () {
                          setState(() {
                            pickDateTime();
                          });
                          raceTimeST.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: raceTimeFN,
                        decoration: const InputDecoration(
                          hintText: 'เวลาสิ้นสุดการแข่งขัน',
                          icon: Icon(Icons.timer_off),
                        ),
                        onTap: () {
                          setState(() {
                            pickDateTime();
                          });
                          raceTimeFN.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: eventDatetime,
                        decoration: const InputDecoration(
                          hintText: 'วันจัดการแข่งขัน',
                          icon: Icon(Icons.date_range_outlined),
                        ),
                        onTap: () {
                          setState(() {
                            pickDateTime();
                          });
                          eventDatetime.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            RaceDto dto = RaceDto(
                              raceName: raceName.text,
                              raceLocation: raceLocation.text,
                              raceLimitteam: int.parse(raceLimit.text),
                              raceImage: '',
                              signUpTimeSt:
                                  DateTime.parse("2002-03-14T00:00:00Z"),
                              eventDatetime:
                                  DateTime.parse("2002-03-14T00:00:00Z"),
                              raceStatus: 0,
                              raceTimeFn:
                                  DateTime.parse("2002-03-14T00:00:00Z"),
                              raceTimeSt:
                                  DateTime.parse("2002-03-14T00:00:00Z"),
                              userId: 2,
                              signUpTimeFn:
                                  DateTime.parse("2002-03-14T00:00:00Z"),
                            );
                            var race = await raceservice.Races(dto);
                            race.data.raceName.toString();
                          
                            //print(race.response.statusCode.toString());
                            if (race.response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('race Successful')),
                              );
                              // log("race Successful");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RacePointMap(
                                        idrace: race.data.raceId),
                                    settings: RouteSettings(arguments: null),
                                  ));
                              return;
                            } else {
                              // log("team fail");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('race fail try agin!')),
                              );
                          
                              return;
                            }
                          },
                          child: Text("สร้าง")),
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
                  border:
                      Border.all(color: Colors.white, width: 3),
                  shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.circular(100),
                ),
                child:  Text('สร้างการแข่งขัน',
                 style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18)),
              ),
            ),
          )
          ])),
        ),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      this.dateTime = dateTime;
      singUpST.text;
      singUpFN.text;
      raceTimeST.text;
      raceTimeFN.text;
      eventDatetime.text;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));


  textField(
      final TextEditingController controller, String hintText, String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText
          ),
        ),
      ],
    );
  }
  Widget uploadImage(){
    return Stack(
      children: const <Widget>[
        CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.grey,
           child: FaIcon(FontAwesomeIcons.camera,size: 25),
        ),
        Positioned(
          bottom: 3.0,
          right: 3.0, 
          
          child: FaIcon(FontAwesomeIcons.circlePlus,size: 25,color: Colors.purpleAccent),
        ),
      ],
    );
  }
}
