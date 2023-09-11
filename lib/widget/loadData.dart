import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loadingIndicator(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: SizedBox(
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: 80,
                height: 80,
                child: LoadingIndicator(
                  indicatorType: Indicator.pacman,
                  colors: [
                    Get.theme.colorScheme.primary,
                    Colors.amber,
                    Colors.green,
                  ],
                  strokeWidth: 2.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'กำลังประมวลผล',
                style: TextStyle(color: Get.theme.colorScheme.primary),
              ),
            )
          ],
        ),
      ),
    );

Widget loading(BuildContext context) => SizedBox(
  width: 150,
  height: 150,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: SizedBox(
          width: 80,
          height: 80,
          child: LoadingIndicator(
            indicatorType: Indicator.ballBeat,
            colors: [
              Get.theme.colorScheme.primary,
              Colors.amber,
              Colors.green,
            ],
            strokeWidth: 2.0,
          ),
        ),
      ),
      
    ],
  ),
);


void startLoading(BuildContext context) {
  SmartDialog.showLoading(
    builder: (_) => loadingIndicator(context),
    animationType: SmartAnimationType.fade,
    maskColor: Colors.transparent,
  );
}

void stopLoading() {
  SmartDialog.dismiss();
}

void loadImg(BuildContext context){
  SmartDialog.showLoading(
    builder: (_) => loading(context),
    animationType: SmartAnimationType.fade,
    maskColor: Colors.transparent,
  );
}