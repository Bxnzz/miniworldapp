import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    // TODO: implement initState

    singUpST.text = "";
    raceservice = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: Text('สร้างการแข่งขัน'),
      ),
      body: Column(children: [
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'ชื่อการแข่งขัน',
              icon: Icon(Icons.stadium_outlined),
            ),
            controller: raceName),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'สถานที่',
              icon: Icon(Icons.location_city_outlined),
            ),
            controller: raceLocation),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'จำนวนทีม',
              icon: Icon(Icons.person),
            ),
            controller: raceLimit),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'รูปภาพ',
              icon: Icon(Icons.image),
            ),
            controller: raceImage),
        TextField(
          controller: singUpST,
          readOnly: true,
          onTap: () {
            setState(() {
              pickDateTime();
            });
            singUpST.text =
                '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes';
            ;
          },
          decoration: InputDecoration(label: Text('enter date time')),
        ),

        TextFormField(
            decoration: const InputDecoration(
              hintText: 'วันที่ปิดรับสมัคร',
              icon: Icon(Icons.dangerous_outlined),
            ),
            controller: singUpFN),

        ElevatedButton(
          child: Text(
              '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes'),
          onPressed: pickDateTime,
        ),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'เวลาเริ่มการแข่งขัน',
              icon: Icon(Icons.timer),
            ),
            controller: raceTimeST),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'เวลาสิ้นสุดการแข่งขัน',
              icon: Icon(Icons.timer_off),
            ),
            controller: raceTimeFN),
        TextFormField(
            decoration: const InputDecoration(
              hintText: 'วันจัดการแข่งขัน',
              icon: Icon(Icons.date_range_outlined),
            ),
            controller: eventDatetime),
        ElevatedButton(
            onPressed: () async {
              // RaceDto dto = RaceDto(
              //                     raceName: raceName.text,
              //                     raceLocation: raceLocation.text,
              //                      raceLimitteam: int.parse(raceLimit.text),
              //                      raceImage: raceImage.text,
              //                       signUpTimeSt: ,

              //                   );
              // var race = await raceservice.Races(dto);
            },
            child: Text("สร้าง")),
        // ElevatedButton(
        //   child: Text('${dateTime.year}/${dateTime.month}/${dateTime.day}'),
        //   onPressed: () async {
        //     final date = await pickDate();
        //     if (date == null) return;
        //     final newDateTime = DateTime(date.year, date.month, date.day,
        //         dateTime.hour, dateTime.minute);

        //     setState(() => dateTime = newDateTime);
        //   },
        // ),
        // ElevatedButton(
        //   child: Text('$hours:$minutes'),
        //   onPressed: () async {
        //     final time = await pickTime();
        //     if (time == null) return;
        //     final newDateTime = DateTime(
        //       dateTime.year,
        //       dateTime.month,
        //       dateTime.day,
        //       time.hour,
        //       time.minute,
        //     );
        //     setState(() => dateTime = newDateTime);
        //   },

        // ),
      ]),
    );
  }

  // dateTimePickerWidget(BuildContext context) {
  //   return DatePicker.showDatePicker(
  //     context,
  //     dateFormat: 'dd MMMM yyyy HH:mm',
  //     initialDateTime: DateTime.now(),
  //     minDateTime: DateTime(2000),
  //     maxDateTime: DateTime(3000),
  //     onMonthChangeStartWithFirstDate: true,
  //     onConfirm: (dateTime, List<int> index) {
  //       DateTime selectdate = dateTime;
  //       final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
  //       print(selIOS);
  //     },
  //   );
  // }

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
