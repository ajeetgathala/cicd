import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? labelTextMain;
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
  final FocusNode? focusNode;
  final dynamic validator;
  final dynamic onFiledSubmitted;

  const CommonTextFieldWidget(
      {Key? key,
      this.labelText,
      this.labelTextMain,
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
      this.onEyeClick,
      this.focusNode,
      this.validator,
      this.onFiledSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelTextMain!,
          style: const TextStyle(color: AppColors.mainLabelText),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.blueLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: textFieldController,
                  maxLines: 1,
                  focusNode: focusNode,
                  validator: validator,
                  keyboardType: textInputType,
                  cursorColor: AppColors.black,
                  obscureText: obscureText ?? false,
                  obscuringCharacter: '*',
                  enabled: enabled,
                  onFieldSubmitted: onFiledSubmitted,
                  decoration: InputDecoration(
                    hintText: labelText,
                  ),
                  onChanged: value,
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
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
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
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.red, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
