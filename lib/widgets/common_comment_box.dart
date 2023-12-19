import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class CommonCommentBox extends StatelessWidget {
  final String? hint;
  final String? labelTextMain;
  final String errorText;
  final Color? textFieldColor;
  final Color? textColor;

  final TextEditingController? textFieldController;
  final int? spaceVal;
  final ValueChanged? onChanged;

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

  const CommonCommentBox({
    Key? key,
    this.hint = '',
    this.labelTextMain = '',
    this.errorText = '',
    this.textFieldColor,
    this.onChanged,
    this.textColor = AppColors.whiteColor,
    this.textFieldController,
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
    this.onFiledSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelTextMain == ''
                    ? AppStrings.commentOptional
                    : labelTextMain!,
                style: const TextStyle(
                    color: AppColors.mainLabelText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Container(
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
                        maxLines: 5,
                        focusNode: focusNode,
                        minLines: 3,
                        cursorColor: AppColors.black,
                        decoration: InputDecoration(
                          hintText:
                              hint!.isEmpty ? AppStrings.enterComment : hint,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                  ],
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
