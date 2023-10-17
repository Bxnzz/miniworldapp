import 'dart:developer';
import 'dart:io';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:miniworldapp/model/result/raceResult.dart';
import 'package:miniworldapp/page/General/detil_race_host.dart';
import 'package:miniworldapp/page/General/home_all.dart';
import 'package:provider/provider.dart';

import '../../model/DTO/raceDTO.dart';
import '../../model/race.dart';
import '../../service/provider/appdata.dart';
import '../../service/race.dart';
import '../../widget/loadData.dart';
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
  TextEditingController TimeST = TextEditingController();
  TextEditingController TimeFN = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime eventDate = DateTime.now();

  final keys = GlobalKey<FormState>();

  // File? pickedFile;
  String urlDownload = '';
  File? _image;
  UploadTask? uploadTask;
  bool isImage = true;
  String image = '';

  String img = '';

  DateTime dateTime = DateTime(2023, 03, 24, 5, 30);
  int idUser = 0;
  int idrace = 0;
  String idR = '';
  String UrlImg = '';
  String dateFormat01 = '';
  String dateFormat02 = '';
  String dateFormat03 = '';
  String formattedDate01 = '';
  String formattedDate02 = '';

  late DateTime datest;
  late DateTime datefn;
  late DateTime datetime;
  late DateTime timest;
  late DateTime timefn;

  TextEditingController TexttimeST = TextEditingController();
  TextEditingController TexttimeFN = TextEditingController();
  TextEditingController TexttimeDate = TextEditingController();

  late RaceResult raceResult;
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
    startLoading(context);
    try {
      var r = await raceservice.racesByraceID(raceID: idrace);
      races = r.data;
      log(r.data.first.raceName);
      idR = r.data.first.raceId.toString();
      log(idR.toString());
      if (raceName.text == '' &&
          raceLocation.text == '' &&
          raceLimit.text == '') {
        raceName.text = r.data.first.raceName;
        raceLocation.text = r.data.first.raceLocation;
        raceLimit.text = r.data.first.raceLimitteam.toString();
      }
      if (TexttimeST.text == '' &&
          TexttimeFN.text == '' &&
          TexttimeDate.text == '' &&
          TimeST.text == '' &&
          TimeFN.text == '') {
        TexttimeST.text = r.data.first.signUpTimeSt.toString();
        TexttimeFN.text = r.data.first.signUpTimeFn.toString();
        TexttimeDate.text = r.data.first.eventDatetime.toString();
        TimeST.text = r.data.first.raceTimeSt.toString();
        TimeFN.text = r.data.first.raceTimeFn.toString();

        formattedDate01 = DateFormat.Hm().format(r.data.first.raceTimeSt);
        raceTimeST.text = formattedDate01;
        formattedDate02 = DateFormat.Hm().format(r.data.first.raceTimeFn);
        raceTimeFN.text = formattedDate02;
        var formatter = DateFormat.yMMMd();
        dateFormat01 =
            formatter.formatInBuddhistCalendarThai(r.data.first.signUpTimeSt);
        dateFormat02 =
            formatter.formatInBuddhistCalendarThai(r.data.first.signUpTimeFn);
        dateFormat03 =
            formatter.formatInBuddhistCalendarThai(r.data.first.eventDatetime);
        singUpST.text = dateFormat01;
        singUpFN.text = dateFormat02;
        eventDatetime.text = dateFormat03;
      } else {}

      UrlImg = r.data.first.raceImage;
      log(UrlImg);
    } catch (err) {
      log(err.toString());
    } finally {
      stopLoading();
    }
  }

  Widget buildrace() {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/image/NewBG.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                    Card(
                      margin: EdgeInsets.fromLTRB(25, 75, 25, 5),
                      elevation: 0,
                      color: Colors.white,
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
                                child: textField(
                                    raceName,
                                    'ชื่อการแข่งขัน...',
                                    'ชื่อการแข่งขัน',
                                    'กรุณากรอกชื่อการแข่งขัน'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 328,
                                child: textField(
                                    raceLocation,
                                    'สถานที่แข่งขัน...',
                                    'สถานที่',
                                    'กรุณากรอกสถานที่'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 330,
                                child: textFieldteam(raceLimit, 'จำนวนทีม...',
                                    'จำนวนทีม', 'กรุณากรอกจำนวนทีม'),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 8, left: 18),
                                      child: SizedBox(
                                        width: 158,
                                        height: 40,
                                        child: TextFormField(
                                          controller: singUpST,
                                          readOnly: true,
                                          style: Get.textTheme.bodyLarge,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
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
                                                    log('stttt ' +
                                                        TexttimeST.text);
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
                                      padding: const EdgeInsets.only(
                                          bottom: 8, left: 8),
                                      child: SizedBox(
                                        width: 158,
                                        height: 40,
                                        child: TextFormField(
                                          controller: singUpFN,
                                          readOnly: true,
                                          style: Get.textTheme.bodyLarge,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            //  labelText: 'วันที่ปิดรับสมัคร',
                                            hintText: 'วันที่เปิด',
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                DateTime? dt = await selectDate(
                                                    endDate, 'end');

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
                                                    log('Fnnn ' +
                                                        TexttimeFN.text);
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
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'วันจัดการแข่งขัน...',
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              DateTime? dt = await selectDate(
                                                  eventDate, 'eventdate');

                                              if (dt != null) {
                                                setState(() {
                                                  eventDate = dt;

                                                  var formatter =
                                                      DateFormat.yMMMd();
                                                  var dateInBuddhistCalendarFormat =
                                                      formatter
                                                          .formatInBuddhistCalendarThai(
                                                              eventDate);
                                                  eventDatetime.text =
                                                      dateInBuddhistCalendarFormat;

                                                  TexttimeDate.text =
                                                      '${eventDate.toIso8601String()}Z';
                                                  // context.read<AppData>().dates = dates ;
                                                  log('Fnnn ' +
                                                      TexttimeDate.text);
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
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 18),
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
                                        padding: const EdgeInsets.only(
                                            bottom: 8, left: 8),
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
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: 250,
                                child: FilledButton(
                                    onPressed: () async {
                                      //  if (keys.currentState!.validate()) {}
                                      startLoading(context);
                                      log(TexttimeDate.text);
                                      List<String> ddd =
                                          TexttimeDate.text.split('T');

                                      if (TexttimeDate.text.contains(' ')) {
                                        log('aaaaaaa');
                                        ddd = TexttimeDate.text.split(' ');
                                      }
                                      //ddd [0] = date
                                      List<String> st = TimeST.text.split(' ');
                                      // st[1] = time
                                      List<String> fn = TimeFN.text.split(' ');
                                      // fn[1] = time
                                      log('st' + st.toString());
                                      log('fn' + fn.toString());

                                      String timeST = '';

                                      String timeFN = '';

                                      timeST = '${ddd[0]}T${st[1]}Z';
                                      timeFN = '${ddd[0]}T${fn[1]}Z';
                                      if (timeST.contains('ZZ') ||
                                          timeFN.contains('ZZ')) {
                                        log('aaaaaaa');
                                        timeST = timeST.replaceAll('ZZ', 'Z');
                                        timeFN = timeFN.replaceAll('ZZ', 'Z');
                                      } else {
                                        log('bbbbbb');
                                      }
                                      log('time  $timeST');
                                      log('time  $timeFN' +
                                          '' +
                                          timeFN.contains('ZZ').toString());

                                      if (raceLimit.text == "") {
                                        // log("team fail");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'กรุณากรอกข้อมูลให้ครบถ้วน...')),
                                        );

                                        return;
                                      }
                                      log(UrlImg);
                                      if (UrlImg != '') {
                                        urlDownload = UrlImg;
                                      } else {
                                        final path =
                                            'files/${_image?.path.split('/').last}';
                                        final file = File(_image!.path);
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child(path);
                                        log(ref.toString());

                                        setState(() {
                                          uploadTask = ref.putFile(file);
                                        });
                                        final snapshot = await uploadTask!
                                            .whenComplete(() {});

                                        urlDownload =
                                            await snapshot.ref.getDownloadURL();
                                        log('Download Link:$urlDownload');

                                        img = '';
                                      }

                                      log("allll " +
                                          raceName.text +
                                          ' ' +
                                          raceLimit.text +
                                          ' ' +
                                          TimeST.text +
                                          ' ' +
                                          TexttimeDate.text);

                                      RaceDto dto = RaceDto(
                                        raceName: raceName.text,
                                        raceLocation: raceLocation.text,
                                        raceLimitteam:
                                            int.parse(raceLimit.text),
                                        raceImage: urlDownload,
                                        signUpTimeSt:
                                            DateTime.parse(TexttimeST.text),
                                        eventDatetime:
                                            DateTime.parse(TexttimeDate.text),
                                        raceStatus: 1,
                                        raceTimeFn: DateTime.parse(timeFN),
                                        raceTimeSt: DateTime.parse(timeST),
                                        userId: idUser,
                                        signUpTimeFn:
                                            DateTime.parse(TexttimeFN.text),
                                      );
                                      var race = await raceservice.updateRaces(
                                          dto, idR);

                                      //   log('raceee'+race.response.statusCode.toString());
                                      raceResult = race.data;
                                      stopLoading();
                                      if (raceResult.result == '1') {
                                        // log("race Successful");
                                        Get.to(DetailHost());
                                        Get.defaultDialog(title: 'แก้ไขสำเร็จ');
                                        // context.read<AppData>().idrace =
                                        //     race.data.raceId;
                                        return;
                                      } else {
                                        // log("team fail");
                                        Get.defaultDialog(
                                            title: 'กรุณาตรวจสอบอีกครั้ง');

                                        return;
                                      }
                                    },
                                    child: const Text("แก้ไข")),
                              ),
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
                          child: Text('แก้ไขการแข่งขัน',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18)),
                        ),
                      ),
                    )
                  ])),
            );
          }),
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
            padding: const EdgeInsets.only(right: 18),
            child: Text(labelText + '*'),
          ),
          TextFormField(
            style: Get.textTheme.bodyLarge,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
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
        : Stack(
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
                    child: Image.network(
                      UrlImg,
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
      barrierDismissible: true,
      initialDate: initDate,
      firstDate: firstDate,
      lastDate: lastDate,
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
        textStyleButtonPositive: Get.textTheme.bodyMedium,
        textStyleButtonNegative: Get.textTheme.bodyMedium,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        textStyleYear: Get.textTheme.bodyMedium,
        textStyleYearSelected: Get.textTheme.bodyMedium,
      ),
      context: context,
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
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Text(labelText + '*'),
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
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
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
}
