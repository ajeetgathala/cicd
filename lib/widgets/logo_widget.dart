import 'package:cicd/constants/const_assets.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const LogoWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppIcon.logo,
      width: height,
      height: width,
    );
  }
}
