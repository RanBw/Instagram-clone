import 'package:flutter/material.dart';
import 'package:instagram_clone_2/responsive/mobile.dart';
import 'package:instagram_clone_2/responsive/web.dart';

class Responsive extends StatefulWidget {
  final MobileScreen myMobileScreen;
  final WebScreen myWebScreen;
  const Responsive({
    super.key,
    required this.myMobileScreen,
    required this.myWebScreen,
  });

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
      if (boxConstraints.maxWidth < 600) {
        return widget.myMobileScreen;
      } else {
        return widget.myWebScreen;
      }
    });
  }
}
