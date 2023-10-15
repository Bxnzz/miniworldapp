import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:miniworldapp/model/race.dart';
import 'package:miniworldapp/page/General/Home.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:miniworldapp/page/Host/mission_create.dart';
import 'package:miniworldapp/service/race.dart';
import 'package:miniworldapp/widget/loadData.dart';
import 'package:miniworldapp/widget/textfieldDate.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/raceDTO.dart';
import '../../service/provider/appdata.dart';
import '../../widget/textfildTime.dart';

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
  TextEditingController TimeST = TextEditingController();
  TextEditingController TimeFN = TextEditingController();
  final keys = GlobalKey<FormState>();
  // final _formKey1 = GlobalKey<FormState>();
  // final _formKey2 = GlobalKey<FormState>();
  // final _formKey3 = GlobalKey<FormState>();
  late Race rases;
  // File? pickedFile;
  File? _image;
  UploadTask? uploadTask;
  bool isImage = true;
  String image = '';

  String img = '';

  DateTime dateTime = DateTime(2023, 03, 24, 5, 30);
  int idUser = 0;
  int idrace = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime eventDate = DateTime.now();
  TextEditingController TexttimeST = TextEditingController();
  TextEditingController TexttimeFN = TextEditingController();
  TextEditingController TexttimeDate = TextEditingController();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    singUpST.text = "";
    raceservice = RaceService(Dio(), baseUrl: context.read<AppData>().baseurl);

    idUser = context.read<AppData>().idUser;
    log(idUser.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => const Home());
        return true;
      },
      child: Scaffold(
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
          body: buildrace()),
    );
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
        child: Center(
            child: Stack(
                alignment: AlignmentDirectional.topCenter,
                clipBehavior: Clip.none,
                children: [
              Card(
                margin: EdgeInsets.fromLTRB(25, 75, 25, 5),
                //   color: Theme.of(context).primaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: upImg(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 328,
                          child: textField(raceName, 'ชื่อการแข่งขัน...',
                              'ชื่อการแข่งขัน', 'กรุณากรอกชื่อการแข่งขัน'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 328,
                          child: textField(raceLocation, 'สถานที่แข่งขัน...',
                              'สถานที่', 'กรุณากรอกสถานที่'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: 330,
                          child: textFieldteam(raceLimit, 'จำนวนทีม...',
                              'จำนวนทีม*', 'กรุณากรอกจำนวนทีม'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 8),
                            child: Text('วันที่เปิด-ปิดลงทะเบียน*'),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, left: 18),
                                child: SizedBox(
                                  width: 158,
                                  height: 40,
                                  child: TextFormField(
                                    controller: singUpST,
                                    readOnly: true,
                                    style: Get.textTheme.bodyLarge,
                                    decoration: InputDecoration(
                                      hintText: 'วันที่เปิด',
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          DateTime? dt = await selectDate(
                                              startDate, 'start');

                                          if (dt != null) {
                                            setState(() {
                                              startDate = dt;

                                              var formatter =
                                                  DateFormat.yMMMd();
                                              var dateInBuddhistCalendarFormat =
                                                  formatter
                                                      .formatInBuddhistCalendarThai(
                                                          startDate);
                                              singUpST.text =
                                                  dateInBuddhistCalendarFormat;

                                              TexttimeST.text =
                                                  '${startDate.toIso8601String()}Z';
                                              // context.read<AppData>().dates = dates ;
                                              log('stttt ' + TexttimeST.text);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.calendar),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, left: 8),
                                child: SizedBox(
                                  width: 158,
                                  height: 40,
                                  child: TextFormField(
                                    controller: singUpFN,
                                    readOnly: true,
                                    style: Get.textTheme.bodyLarge,
                                    decoration: InputDecoration(
                                      //  labelText: 'วันที่ปิดรับสมัคร',
                                      hintText: 'วันที่เปิด',
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          DateTime? dt =
                                              await selectDate(endDate, 'end');

                                          if (dt != null) {
                                            setState(() {
                                              endDate = dt;

                                              var formatter =
                                                  DateFormat.yMMMd();
                                              var dateInBuddhistCalendarFormat =
                                                  formatter
                                                      .formatInBuddhistCalendarThai(
                                                          endDate);
                                              singUpFN.text =
                                                  dateInBuddhistCalendarFormat;

                                              TexttimeFN.text =
                                                  '${endDate.toIso8601String()}Z';
                                              // context.read<AppData>().dates = dates ;
                                              log('Fnnn ' + TexttimeFN.text);
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.calendar),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 8),
                            child: Text('วันจัดการแข่งขัน*'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Center(
                              child: SizedBox(
                                width: 320,
                                height: 40,
                                child: TextFormField(
                                  controller: eventDatetime,
                                  readOnly: true,
                                  style: Get.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    hintText: 'วันจัดการแข่งขัน...',
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        DateTime? dt = await selectDate(
                                            eventDate, 'eventdate');

                                        if (dt != null) {
                                          setState(() {
                                            eventDate = dt;

                                            var formatter = DateFormat.yMMMd();
                                            var dateInBuddhistCalendarFormat =
                                                formatter
                                                    .formatInBuddhistCalendarThai(
                                                        eventDate);
                                            eventDatetime.text =
                                                dateInBuddhistCalendarFormat;

                                            TexttimeDate.text =
                                                '${eventDate.toIso8601String()}Z';
                                            // context.read<AppData>().dates = dates ;
                                            log('Fnnn ' + TexttimeDate.text);
                                          });
                                        }
                                      },
                                      icon:
                                          const Icon(FontAwesomeIcons.calendar),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Padding(
                            padding: EdgeInsets.only(left: 20, top: 8),
                            child: Text('เวลาเริ่ม-สิ้นสุดการแข่งขัน*'),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 18),
                                child: SizedBox(
                                    width: 158,
                                    child: SizedBox(
                                      child: TextFieldTime(
                                          controllers: raceTimeST,
                                          hintText: '00:00',
                                          labelText: 'เริ่ม',
                                          times: TimeST),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 8),
                                child: SizedBox(
                                    width: 158,
                                    child: SizedBox(
                                      child: TextFieldTime(
                                          controllers: raceTimeFN,
                                          hintText: '00:00',
                                          labelText: 'สิ้นสุด',
                                          times: TimeFN),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                            onPressed: () async {
                              startLoading(context);

                              if (raceLimit.text == "" &&
                                  raceName.text == "" &&
                                  raceLocation.text == "") {
                                // log("team fail");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('กรุณากรอกข้อมูลให้ครบถ้วน...')),
                                );
                                return;
                              }
                              if (raceTimeST.text == "" &&
                                  raceTimeFN.text == "" &&
                                  eventDatetime.text == "" &&
                                  singUpST.text == "" &&
                                  singUpFN.text == "") {
                                // log("team fail");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'กรุณาตรวจสอบวันที่และเวลาในการแข่งขัน...')),
                                );
                                return;
                              }
                              List<String> ddd = TexttimeDate.text.split('T');
                              //ddd [0] = date
                              List<String> st = TimeST.text.split(' ');
                              // st[1] = time
                              List<String> fn = TimeFN.text.split(' ');
                              // fn[1] = time
                              String timeST = '${ddd[0]}T${st[1]}Z';
                              log('time  ' + timeST);

                              String timeFN = '${ddd[0]}T${fn[1]}Z';
                              log('time  ' + timeFN);
                              //    if (keys.currentState!.validate()) {}
                              if (_image == null) {
                                // log("team fail");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('กรุณาใส่รูปภาพ...')),
                                );
                                return;
                              }

                              final path =
                                  'files/${_image?.path.split('/').last}';
                              final file = File(_image!.path);
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

                              img = urlDownload;

                              log('testt' +
                                  raceName.text +
                                  raceLocation.text +
                                  TexttimeST.text);

                              RaceDto dto = RaceDto(
                                raceName: raceName.text,
                                raceLocation: raceLocation.text,
                                raceLimitteam: int.parse(raceLimit.text),
                                raceImage: urlDownload,
                                signUpTimeSt: DateTime.parse(TexttimeST.text),
                                eventDatetime:
                                    DateTime.parse(TexttimeDate.text),
                                raceStatus: 1,
                                raceTimeFn: DateTime.parse(timeFN),
                                raceTimeSt: DateTime.parse(timeST),
                                userId: idUser,
                                signUpTimeFn: DateTime.parse(TexttimeFN.text),
                              );

                              var race = await raceservice.insertRaces(dto);
                              context.read<AppData>().idrace = race.data.raceId;
                              bool ispop = false;
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                headerAnimationLoop: false,
                                title: 'สร้างการแข่งขันสำเร็จ!!',
                                desc: 'ต้องการสร้างภารกิจต่อไปหรือไม่?',
                                btnOkText: "เอาไว้ก่อน",
                                btnCancelText: "สร้างภารกิจ",
                                btnOkOnPress: () async {
                                  ispop == false;
                                  log('message');
                                },
                                btnCancelColor: Colors.lightGreen,
                                btnOkColor: Colors.amber,
                                btnCancelOnPress: () async {
                                  ispop = true;
                                  Get.off(() => Missioncreate());

                                  context.read<AppData>().idrace =
                                      race.data.raceId;
                                },
                              ).show().then((value) {
                                if (ispop == false) {
                                  Navigator.of(context).pop();
                                }
                              });

                              // Get.defaultDialog(
                              //     title: 'สร้างการแข่งขันสำเร็จ!!',
                              //     content: Text('กรุณาสร้างภารกิจต่อไป'),
                              //     actions: [
                              //       TextButton(
                              //           onPressed: () async {
                              //             startLoading(context);
                              //             var race = await raceservice
                              //                 .insertRaces(dto);
                              //             context.read<AppData>().idrace =
                              //                 race.data.raceId;
                              //             Get.to(Missioncreate());
                              //             stopLoading();
                              //           },
                              //           child: Text('สร้างภารกิจ')),
                              //       TextButton(
                              //           onPressed: () async {
                              //             Navigator.of(context).pop();
                              //           },
                              //           child: Text('ยกเลิก')),
                              //     ]);

                              //race.data.raceName.toString();
                              // if (race.) {
                              //   log("race Successful");

                              //   //
                              //   return;
                              // } else {
                              //   // log("team fail");
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content: Text('race fail try agin!')),
                              //   );

                              //   return;
                              // }
                              stopLoading();
                            },
                            child: const Text("สร้างการแข่งขัน")),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 222, 72, 249),
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('สร้างการแข่งขัน',
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(labelText + '*'),
          ),
          TextFormField(
            style: Get.textTheme.bodyLarge,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: hintText,
            ),
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

  Future<DateTime?> selectDate(DateTime initDate, String mode) async {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now();
    if (mode == 'start') {
      // initDate = initDate;
      firstDate = firstDate.subtract(const Duration(days: 1));
      lastDate = initDate.add(const Duration(days: 365 * 3));
      log('stDate ' + startDate.toString());
    } else if (mode == 'end') {
      initDate = startDate;
      firstDate = startDate;
      lastDate = startDate.add(const Duration(days: 365 * 3));
      log(eventDate.isBefore(endDate).toString());
    } else if (mode == 'eventdate') {
      initDate = endDate;
      firstDate = endDate;
      lastDate = endDate.add(const Duration(days: 365 * 3));
    }

    return await showRoundedDatePicker(
      context: context,
      barrierDismissible: true,
      initialDate: initDate,
      firstDate: firstDate,
      imageHeader: AssetImage("assets/image/pink.jpg"),
      theme: ThemeData(
        fontFamily: GoogleFonts.notoSansThai().fontFamily,
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        decorationDateSelected: BoxDecoration(
            color: Get.theme.colorScheme.primary, shape: BoxShape.circle),
        textStyleDayOnCalendarSelected: Get.textTheme.bodyLarge!
            .copyWith(color: Get.theme.colorScheme.onError),
        textStyleCurrentDayOnCalendar: Get.textTheme.bodyMedium!.copyWith(
          color: Get.theme.colorScheme.primary,
        ),
        textStyleDayHeader: const TextStyle(
            fontSize: 24, color: Colors.white, backgroundColor: Colors.white),
        textStyleButtonPositive: Get.textTheme.bodyMedium,
        textStyleButtonNegative: Get.textTheme.bodyMedium,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
          textStyleYear:
              Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
          textStyleYearSelected: Get.textTheme.bodyMedium,
          backgroundPicker: Colors.white),
      height: 300,
      era: EraMode.BUDDHIST_YEAR,
    );
  }

  textFieldteam(final TextEditingController controller, String hintText,
      String labelText, String error) {
    return Form(
      //key: keys,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            labelText,
          ),
          TextFormField(
            style: Get.textTheme.bodyLarge,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(hintText: hintText),
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
                          FontAwesomeIcons.camera,
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
                      FontAwesomeIcons.camera,
                      size: 30,
                      color: Get.theme.colorScheme.onPrimary,
                    ))),
          );
  }
}
