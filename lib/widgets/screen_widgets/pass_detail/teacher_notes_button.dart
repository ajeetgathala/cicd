import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:flutter/material.dart';

class TeacherNotesButton extends StatelessWidget {
  final Function() onTap;

  const TeacherNotesButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          // width: 150,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: AppColors.blue,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(80),
                  blurRadius: 20.0,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      width: 15,
                      height: 15,
                      child: Icon(
                        Icons.comment,
                        size: 16,
                        color: AppColors.whiteColor,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppStrings.teacherNotes,
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
