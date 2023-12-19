import 'package:cicd/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TrHomeListItem extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String subText;
  final Color color;
  final String icon;

  const TrHomeListItem(
      {super.key,
      required this.onTap,
      required this.text,
      required this.color,
      required this.icon,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.moreGrayLight,
            border: Border.all(color: AppColors.moreGrayLight, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: color, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(7))),
              child: Image.asset(
                icon,
                width: 30,
                height: 30,
                // fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.blueDark),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subText,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grayLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
