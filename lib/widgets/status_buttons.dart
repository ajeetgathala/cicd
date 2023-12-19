import 'package:cicd/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StatusButtons extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Color color;
  final String icon;

  const StatusButtons(
      {super.key,
      required this.title,
      required this.onTap,
      required this.color,
      this.icon = ''});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 25,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  if (icon != '')
                    SizedBox(
                        width: 14,
                        height: 14,
                        child: Image.asset(
                          icon,
                          color: AppColors.whiteColor,
                        )),
                  if (icon != '')
                    const SizedBox(
                      width: 5,
                    ),
                  Text(title,
                      style: const TextStyle(color: AppColors.whiteColor),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
