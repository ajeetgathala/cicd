import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:flutter/material.dart';

class PassDetailCommentBox extends StatelessWidget {
  final dynamic controller;

  const PassDetailCommentBox({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.comment,
                      color: AppColors.blueDark,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      AppStrings.commentDot,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  controller.stPassesListDataModel.comment.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.blueDark,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
