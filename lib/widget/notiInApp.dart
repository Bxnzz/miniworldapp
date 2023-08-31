import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class NotificationBody extends StatelessWidget {
  

  NotificationBody({
    Key? key,
       required this.mission,
      required this.team,
  }) : super(key: key);

  final String mission;
  final String team;
  @override
  Widget build(BuildContext context) {
    // final minHeight = math.min(
    //  this.minHeight,
    //   MediaQuery.of(context).size.height,
    // );
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 50),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 12,
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 1.4,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [  
                           const FaIcon(FontAwesomeIcons.solidBell,size: 35,),
                          Padding(
                            padding: const EdgeInsets.only(left:0),
                            child: Text(
                              'มีหลักฐานที่ต้องตรวจสอบ?',
                              style: Get.theme.textTheme.titleMedium!
                                                .copyWith(fontWeight: FontWeight.bold,color:Colors.black),
                            ),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronDown,size: 15,),
                        ],
                      ),
                      Text(
                        'ภารกิจ: '+mission +' '+'ทีม: '+team,
                        style: Get.theme.textTheme.bodyMedium!
                                          .copyWith(color:Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}