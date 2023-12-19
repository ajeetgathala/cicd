import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/all_models/passes_list_model.dart';
import 'package:flutter/cupertino.dart';

class PassDetailSmallWidgets {
  static Widget todayPassesText(PassesListModel object) {
    return Row(
      children: [
        Text(AppStrings.has,
            style: TextStyle(
                color: AppColors.gray.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        const SizedBox(
          width: 5,
        ),
        Container(
          // width: 18,
          padding: const EdgeInsets.only(left: 7, right: 7),
          // height: 18,
          decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Text(object.todayCount.toString(),
                  style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14))),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(AppStrings.passesToday,
            style: TextStyle(
                color: AppColors.gray.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
      ],
    );
  }

  static Widget nameWidget(PassesListModel object, width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Text(object.studentName.toString(),
              style: const TextStyle(
                  color: AppColors.blueDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
        ),
        if (object.diffTime.toString() != '' &&
            object.diffTime.toString() != 'null')
          SizedBox(
            width: 150,
            child: Text(object.diffTime ?? '',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: AppColors.yellowDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          )
      ],
    );
  }

  static Widget validationWidget(PassesListModel object) {
    return object.validationText.toString() != "null" &&
            object.validationText != ''
        ? Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.redMoreLight,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(object.validationText!,
                textAlign: TextAlign.start,
                style: const TextStyle(color: AppColors.red, fontSize: 12)),
          )
        : Container();
  }
}
