import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DateTimeWidget extends StatelessWidget {
  final String? labelText;
  final String? labelTextMain;
  final String errorText;
  final Color? textFieldColor;
  final Color? hintTextColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final int? spaceVal;
  final int? maxLength;
  final TextInputType? textInputType;
  final bool? isInvalid;
  final VoidCallback? onEyeClick;

  const DateTimeWidget(
      {Key? key,
      this.labelText,
      this.labelTextMain,
      required this.errorText,
      this.textFieldColor,
      this.hintTextColor,
      this.textColor = AppColors.whiteColor,
      this.onTap,
      this.spaceVal,
      this.maxLength,
      this.textInputType,
      this.isInvalid,
      this.onEyeClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelTextMain!,
          style: const TextStyle(
            color: AppColors.mainLabelText,
            fontSize: 12,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.blueLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      labelText ?? '',
                      maxLines: 1,
                      style: TextStyle(
                        color: hintTextColor ?? AppColors.gray,
                      ),
                    )),
                InkWell(
                  onTap: onEyeClick,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: AppColors.blueLight,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isInvalid == true)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.red,
                  size: 16,
                ),
                const SizedBox(
                  width: 2,
                ),
                Flexible(
                  child: Text(
                    errorText,
                    style: const TextStyle(color: AppColors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
