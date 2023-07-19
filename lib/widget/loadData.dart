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
        width: Get.width / 3 + 30,
        height: Get.height / 4 - 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: LoadingIndicator(
                indicatorType: Indicator.pacman,
                colors: [Get.theme.colorScheme.primary],
                strokeWidth: 2.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'กำลังประมวลผล',
                style: TextStyle(
                    color: Get.theme.colorScheme.primary),
              ),
            )
          ],
        ),
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
