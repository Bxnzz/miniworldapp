import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loadingIndicator(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: SizedBox(
        width: 120,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [Theme.of(context).colorScheme.onPrimaryContainer],
                strokeWidth: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'กำลังประมวลผล',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
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