import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class PassDetailStatusText extends StatelessWidget {
  final dynamic controller;

  const PassDetailStatusText({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
            decoration: BoxDecoration(
                color: PassesStatus.getBackgroundColor(
                    controller.stPassesListDataModel.status!),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Text(
              '${PassesStatus.getStatus(controller.stPassesListDataModel.status!)} ${controller.stPassesListDataModel.status == PassesStatus.received ? 'AT ${Utils.formatTime(controller.stPassesListDataModel.receivedTime.toString(), true)}' : controller.stPassesListDataModel.status == PassesStatus.approved ? 'AT ${Utils.formatTime(controller.stPassesListDataModel.approvedTime.toString(), true)}' : controller.stPassesListDataModel.status == PassesStatus.departed ? 'AT ${Utils.formatTime(controller.stPassesListDataModel.departedTime.toString(), true)}' : ''}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor),
            ),
          ),
        ),
      ],
    );
  }
}
