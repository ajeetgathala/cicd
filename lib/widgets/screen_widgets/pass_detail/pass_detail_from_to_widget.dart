import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/pass_detail_validations.dart';
import 'package:cicd/widgets/circle_image.dart';
import 'package:flutter/material.dart';

class PassDetailFroToWidget extends StatelessWidget {
  final dynamic controller;
  final PassValidations passValidations;

  const PassDetailFroToWidget(
      {super.key, this.controller, required this.passValidations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                AppStrings.from,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.blueDark, fontWeight: FontWeight.w500),
              )),
              const SizedBox(
                width: 60,
              ),
              Expanded(
                  child: Text(AppStrings.to,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.blueDark,
                          fontWeight: FontWeight.w500)))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    CommonCircleImage(
                      margin: 10,
                      icon: passValidations.getFromIcon(),
                      url: passValidations.getFromImage(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            passValidations.getFromText(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (passValidations.showFromSubTitle())
                          SizedBox(
                              width: 80,
                              child: Text(
                                controller
                                    .stPassesListDataModel.departingTeacherName
                                    .toString(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.grayLight,
                                ),
                              ))
                      ],
                    )
                  ],
                ),
              )),
              const Icon(
                Icons.arrow_forward,
                size: 25,
                color: AppColors.blueDark,
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10),
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    CommonCircleImage(
                      margin: 10,
                      icon: passValidations.getToIcon(),
                      url: passValidations.getToImage(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            passValidations.getToText(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (passValidations.showToSubTitle())
                          SizedBox(
                              width: 80,
                              child: Text(
                                controller.stPassesListDataModel
                                    .destinationTeacherName
                                    .toString(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.grayLight,
                                ),
                              ))
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
