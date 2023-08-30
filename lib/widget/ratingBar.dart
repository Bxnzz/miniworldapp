import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ratingBar extends StatefulWidget {
  const ratingBar(
      {super.key,
      required this.point,
      required this.size,
      required this.faIcon});

  final double point;
  final double size;
  final FaIcon faIcon;

  @override
  State<ratingBar> createState() => _ratingBarState();
}

class _ratingBarState extends State<ratingBar> {
  @override
  Widget build(BuildContext context) {
    return ratingBar();
  }

  RatingBar ratingBar() {
    return RatingBar.builder(
      glowColor: Colors.yellowAccent,
      glowRadius: 5,
      allowHalfRating: true,
      initialRating: widget.point,
      ignoreGestures: true,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: widget.size,
      itemBuilder: (context, _) => widget.faIcon,
      onRatingUpdate: (lating) {},
    );
  }
}
