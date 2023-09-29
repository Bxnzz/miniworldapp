

import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TextFieldTime extends StatefulWidget {
   TextEditingController controllers; String hintText; String labelText;TextEditingController times; 
   TextFieldTime({super.key,required this.controllers, required this.hintText, required this.labelText,required this.times});

  @override
  State<TextFieldTime> createState() => _TextFieldTimeState();
}

class _TextFieldTimeState extends State<TextFieldTime> {
  late DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 33,
          child: TextFormField(
            controller: widget.controllers,
            readOnly: true,
            decoration: InputDecoration(
              
              // enabled: false,
              labelText: widget.labelText,
              hintText:  widget.hintText,
              suffixIcon: IconButton(
                onPressed: () {
                  CupertinoRoundedDatePicker.show(
                    context,
                    locale: Locale('th','TH'),
                    era: EraMode.BUDDHIST_YEAR,
                   // minimumYear: DateTime.now().year + 20,
                   // maximumYear: 20,
                    borderRadius: 16,
                    initialDatePickerMode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (newDateTime) {
                      setState(() => dateTime = newDateTime);
                     // var onlyBuddhistYear = dateTime.yearInBuddhistCalendar;
                      //  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      // var formatter = DateFormat.yMMMd();
                      // var dateInBuddhistCalendarFormat =
                      //     formatter.formatInBuddhistCalendarThai(dateTime);
                      String formattedDate = DateFormat.Hm().format(newDateTime);
                      widget.controllers.text = formattedDate;
                       widget.times.text = newDateTime.toString();
                      log(widget.times.text);
                    },
                  );
                },
                icon: const Icon(FontAwesomeIcons.clock),
              ),
            ),
          ),
        ),
      ],
    );
  }
}