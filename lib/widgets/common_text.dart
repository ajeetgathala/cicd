import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CommonText extends StatelessWidget {
  final String? text;
  final String? title;
  final String errorText;
  final Color? textFieldColor;
  final Color? textColor;

  final TextEditingController? textFieldController;
  final VoidCallback? onChange;
  final ValueChanged? value;
  final int? spaceVal;
  final int? maxLength;
  final TextInputType? textInputType;
  final bool? isInvalid;
  final bool? isPassword;
  final bool? enabled;
  final bool? obscureText;
  final VoidCallback? onEyeClick;

  const CommonText(
      {Key? key,
      this.text,
      this.title,
      required this.errorText,
      this.textFieldColor,
      this.textColor = AppColors.whiteColor,
      this.textFieldController,
      this.onChange,
      this.value,
      this.spaceVal,
      this.maxLength,
      this.textInputType,
      this.isInvalid,
      this.isPassword,
      this.obscureText,
      this.enabled,
      this.onEyeClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: const TextStyle(
            color: AppColors.mainLabelText,
            fontSize: 12,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.blueLight),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  text ?? '',
                  style: const TextStyle(color: AppColors.blueDark),
                ),
              ),
              if (isPassword == true)
                InkWell(
                  onTap: onEyeClick,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          obscureText ?? false
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
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
                Text(
                  errorText,
                  style: const TextStyle(color: AppColors.red, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
