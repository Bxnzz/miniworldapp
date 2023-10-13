import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';

class TextFieldDate extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String labelText;
  TextEditingController dates;
  String mode;

  TextFieldDate({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.dates,
    required this.mode
  });

  @override
  State<TextFieldDate> createState() => _TextFieldDateState();
}

class _TextFieldDateState extends State<TextFieldDate> {
  late DateTime dateTime;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  //late String dates;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: widget.controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: IconButton(
                onPressed: () async {
                  DateTime? dt = await selectDate(startDate, widget.mode);
                  DateTime? dte = await selectDate(endDate, widget.mode);
                  
                  if (dt != null) {
                    setState(() {
                      startDate = dt;
                      
                      var formatter = DateFormat.yMMMd();
                      var dateInBuddhistCalendarFormat =
                          formatter.formatInBuddhistCalendarThai(startDate);
                      widget.controller.text = dateInBuddhistCalendarFormat;

                     widget.dates.text = '${startDate.toIso8601String()}Z';
                   // context.read<AppData>().dates = dates ;
                     log(widget.dates.text);
                    });
                  }
                  // if (dte != null) {
                  //   setState(() {
                  //     endDate = dte;
                      
                  //     var formatter = DateFormat.yMMMd();
                  //     var dateInBuddhistCalendarFormat =
                  //         formatter.formatInBuddhistCalendarThai(endDate);
                  //     widget.controller.text = dateInBuddhistCalendarFormat;

                  //    widget.dates.text = '${endDate.toIso8601String()}Z';
                  //  // context.read<AppData>().dates = dates ;
                  //    log(widget.dates.text);
                  //   });
                  // }
                  
                  // CupertinoRoundedDatePicker.show(
                  //   context,

                  //   era: EraMode.BUDDHIST_YEAR,
                  //   // minimumYear: DateTime.now().year + 20,
                  //   // maximumYear: 20,
                  //   borderRadius: 16,
                  //   initialDatePickerMode: CupertinoDatePickerMode.date,
                  //   onDateTimeChanged: (newDateTime) {
                  //     setState(() => dateTime = newDateTime);
                  //     // var onlyBuddhistYear = dateTime.yearInBuddhistCalendar;
                  //    //   final DateFormat formatter1 = DateFormat('dd-MM-yyyy''T''Hms''z');

                  //     // final date = '${dateTime.toIso8601String()}Z';

                  //     var formatter = DateFormat.yMMMd();
                  //     var dateInBuddhistCalendarFormat =
                  //         formatter.formatInBuddhistCalendarThai(dateTime);
                  //     widget.controller.text = dateInBuddhistCalendarFormat;

                  //    widget.dates.text = '${dateTime.toIso8601String()}Z';
                  //  // context.read<AppData>().dates = dates ;
                  //    log(widget.dates.text);
                  //   },
                  // );
                },
                icon: const Icon(FontAwesomeIcons.calendar),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> selectDate(DateTime initDate, String mode) async {
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now();
    

    if (mode == 'start') {  
      firstDate = initDate.subtract(Duration(days: 0));
      lastDate = initDate.add(const Duration(days: 365 * 2));
    } else if (mode == 'end') {
      firstDate = startDate;
      lastDate = initDate.add(const Duration(days: 365 * 2));
    }else if (mode == 'startEnd') {
      firstDate = endDate;
      lastDate = initDate.add(const Duration(days: 365 * 2));
    }
    return await showRoundedDatePicker(
      barrierDismissible: true,
      initialDate: initDate,
      firstDate: firstDate,
      lastDate: lastDate,
      theme: ThemeData(
        
        fontFamily: GoogleFonts.notoSansThai().fontFamily,
        primaryColor: Colors.purple[200],
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
}
