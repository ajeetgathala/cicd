import 'package:cicd/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onPressed;
  final int? spaceVal;
  final double? textSize;
  final String assetIcon;
  final double? cornerRadius;
  final double? height;
  final bool isProcessing;

  const CommonButtonWidget(
      {Key? key,
      this.buttonText,
      this.buttonColor,
      this.textColor = AppColors.whiteColor,
      required this.onPressed,
      this.spaceVal,
      this.textSize,
      this.assetIcon = '',
      this.cornerRadius,
      this.height,
      this.isProcessing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius ?? 5)),
      ),
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
              height: height ?? 60,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonColor ?? AppColors.blue,
                borderRadius: BorderRadius.circular(cornerRadius ?? 5),
              ),
              child: isProcessing
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: textColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        assetIcon == ''
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  assetIcon,
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.fill,
                                ),
                              ),
                        Text(buttonText ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColor,
                              fontSize: textSize ?? 15,
                            )),
                      ],
                    ))),
    );
  }
}
