import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../service/provider/appdata.dart';

class TextFieldDate extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  String labelText;
  
 
  TextFieldDate(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText, 
     });

  @override
  State<TextFieldDate> createState() => _TextFieldDateState();
}

class _TextFieldDateState extends State<TextFieldDate> {
  late DateTime dateTime;
  late String dates;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 33,
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              // enabled: false,
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIcon: IconButton(
                onPressed: () {
                  CupertinoRoundedDatePicker.show(
                    context,

                    era: EraMode.BUDDHIST_YEAR,
                    // minimumYear: DateTime.now().year + 20,
                    // maximumYear: 20,
                    borderRadius: 16,
                    initialDatePickerMode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (newDateTime) {
                      setState(() => dateTime = newDateTime);
                      // var onlyBuddhistYear = dateTime.yearInBuddhistCalendar;
                     //   final DateFormat formatter1 = DateFormat('dd-MM-yyyy''T''Hms''z');
   
                      // final date = '${dateTime.toIso8601String()}Z';
                    

                      var formatter = DateFormat.yMMMd();
                      var dateInBuddhistCalendarFormat =
                          formatter.formatInBuddhistCalendarThai(dateTime);
                      widget.controller.text = dateInBuddhistCalendarFormat;
                      
                     dates = '${dateTime.toIso8601String()}Z';
                   // context.read<AppData>().dates = dates ;
                    //  log(widget.controller.text);
                    },
                  );
                },
                icon: const Icon(FontAwesomeIcons.calendar),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}
