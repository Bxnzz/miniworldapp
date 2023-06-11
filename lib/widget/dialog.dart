import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:loading_indicator/loading_indicator.dart';

class DialogRace extends StatefulWidget {
  const DialogRace({super.key});

  @override
  State<DialogRace> createState() => _DialogRaceState();
}

class _DialogRaceState extends State<DialogRace> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // elevation: 0.0,
      // backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: 50,
                child: ElevatedButton(onPressed: () {}, child: const Text('ภารกิจ'))),
              SizedBox(height: 24.0),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
