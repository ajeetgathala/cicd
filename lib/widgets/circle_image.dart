import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CommonCircleImage extends StatelessWidget {
  final double? height;
  final double? width;
  final double? margin;
  final double? padding;
  final String icon;
  final String url;
  final String uri;

  const CommonCircleImage(
      {this.padding,
      required this.icon,
      this.margin,
      this.width,
      this.height,
      this.url = '',
      this.uri = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width ?? 50,
      padding: EdgeInsets.all(padding ?? 0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(height ?? 50))),
      margin: EdgeInsets.all(margin ?? 0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(height ?? 50)),
          child: url.isNotEmpty
              ? Image(
                  image: NetworkImage(url),
                  fit: BoxFit.fill,
                  errorBuilder: (context, exception, stackTrace) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: Image.asset(
                        icon,
                        fit: BoxFit.fill,
                        color: AppColors.blueDark,
                      ),
                    );
                  },
                )
              : uri.isNotEmpty
                  ? Image.file(
                      File(uri),
                      fit: BoxFit.fill,
                      errorBuilder: (context, exception, stackTrace) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Image.asset(
                            icon,
                            fit: BoxFit.fill,
                            color: AppColors.blueDark,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      icon,
                      fit: BoxFit.fill,
                      errorBuilder: (context, exception, stackTrace) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Image.asset(
                            icon,
                            fit: BoxFit.fill,
                            color: AppColors.blueDark,
                          ),
                        );
                      },
                    )),
    );
  }
}
