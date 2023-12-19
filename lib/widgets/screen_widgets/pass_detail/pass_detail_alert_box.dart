import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:flutter/material.dart';

class PassDetailAlertBox extends StatelessWidget {
  final Function() onTap;

  const PassDetailAlertBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppStrings.alertMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.red,
                size: 18,
              )
            ],
          )),
    );
  }
}
