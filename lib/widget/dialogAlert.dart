import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class dialog_alert extends StatefulWidget {
  const dialog_alert({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
  });
  final String asset;
  final double width;
  final double height;
  @override
  State<dialog_alert> createState() => _dialog_alertState();
}

class _dialog_alertState extends State<dialog_alert> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.asset,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.fill,
    );
  }
}
