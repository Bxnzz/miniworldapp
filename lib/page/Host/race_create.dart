import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
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
        appBar: AppBar(
          title: Text('สร้างการแข่งขัน'),
        ),
        body: buildrace());
  }

  Widget buildrace() {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Stack(
                alignment: AlignmentDirectional.topCenter,
                clipBehavior: Clip.none,
                children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'ชื่อการแข่งขัน',
                          icon: Icon(Icons.stadium_outlined),
                        ),
                        controller: raceName),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'สถานที่',
                          icon: Icon(Icons.location_city_outlined),
                        ),
                        controller: raceLocation),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'จำนวนทีม',
                          icon: Icon(Icons.person),
                        ),
                        controller: raceLimit),
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
                            signUpTimeSt: DateTime.parse("2002-03-14T00:00:00Z"),
                            eventDatetime: DateTime.parse("2002-03-14T00:00:00Z"),
                            raceStatus: 0,
                            raceTimeFn: DateTime.parse("2002-03-14T00:00:00Z"),
                            raceTimeSt: DateTime.parse("2002-03-14T00:00:00Z"),
                            userId: 2,
                            signUpTimeFn: DateTime.parse("2002-03-14T00:00:00Z"),
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
                                    builder: (context) =>  RacePointMap( idrace:race.data.raceId),
                                    settings: RouteSettings(arguments: null),
                                  ));
                              return;
                            } else {
                             // log("team fail");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('race fail try agin!')),
                              );

                              return;
                            }
                            
                        },
                        child: Text("สร้าง")),
                        
                  ),
                ],
              ),
            ])),
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
}
