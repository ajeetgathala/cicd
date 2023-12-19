import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/router/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class Utils {
  static String e401 = '401';
  static bool printData = true;

  static void showMessage(context, title, message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (title.trim() != '')
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black)),
                      ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: Text(message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black)),
                    ),
                    Container(
                        height: 40,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              backgroundColor: AppColors.blue,
                              minimumSize: const Size(88, 36),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                              ),
                            ),
                            child: Text(
                              AppStrings.ok,
                              style:
                                  const TextStyle(color: AppColors.whiteColor),
                            )))
                  ],
                ),
              ),
            ));
  }

  static void print(data) {
    debugPrint(data.toString());
  }

  void successMessage(String message) {
    try {
      snackBarMessage(AppStrings.successfully, message);
    } catch (e) {
      print(e);
    }
  }

  String appDateTime(dateTime) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  static void focusChange(
      BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static void snackBarPublic(String title, String message) async {
    Get.snackbar(title, message,
        messageText: Text(message,
            style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
                color: AppColors.whiteColor,
                fontSize: 15)),
        padding: const EdgeInsets.all(15),
        duration: const Duration(milliseconds: 2000),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.blueDarkTransparent,
        colorText: AppColors.whiteColor);
  }

  void snackBarMessage(String title, String message) async {
    Get.snackbar(title, message,
        messageText: Text(message,
            style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
                color: AppColors.whiteColor,
                fontSize: 15)),
        padding: const EdgeInsets.all(15),
        duration: const Duration(milliseconds: 2000),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.blueDarkTransparent,
        colorText: AppColors.whiteColor);
  }

  static Future<void> showCustomNotification(RemoteMessage event) async {
    String typeEPass = 'E-Pass';
    var message = event.notification;
    Get.snackbar(message!.title!, message.body!,
        messageText: Text(message.body!,
            style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
                color: AppColors.whiteColor,
                fontSize: 15)),
        padding: const EdgeInsets.all(15), onTap: (v) {
      if (typeEPass == event.data["TypeName"]) {
        Get.back();
        Get.toNamed(Routes.passDetail, arguments: [event.data["TypeId"]]);
      }
    },
        duration: const Duration(milliseconds: 5000),
        snackStyle: SnackStyle.FLOATING,
        icon: const Icon(
          Icons.ac_unit,
          size: 30,
          color: AppColors.whiteColor,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.blueDarkTransparent,
        colorText: AppColors.whiteColor);
  }

  static Widget showProgress() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.blue,
        strokeWidth: 5.0,
      ),
    );
  }

  static Widget showCenterMessage(String msg) {
    return Center(
      child: Text(
        msg,
        style: const TextStyle(
            fontSize: 18,
            color: AppColors.blueDark,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  static bool isEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static String formatDateTime(String date) {
    String formattedLocalTime;
    try {
      DateTime dateTime = DateTime.parse(date);
      DateFormat dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
      DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
          dateTime.day, dateTime.hour, dateTime.minute, dateTime.minute);
      DateTime localDateTime = utcDateTime.toLocal();
      formattedLocalTime = dateFormat.format(localDateTime);
    } catch (e) {
      formattedLocalTime = date;
    }
    return formattedLocalTime;
  }

  static String formatDate(date, bool toLocal) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute, dateTime.minute);
    DateTime localDateTime;
    if (toLocal) {
      localDateTime = utcDateTime.toLocal();
    } else {
      localDateTime = utcDateTime;
    }
    String formattedLocalTime = dateFormat.format(localDateTime);
    return formattedLocalTime;
  }

  static String formatDateApi(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(date.toUtc());
    return formattedDate;
  }

  static String formatDateApiNoUtc(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }

  static String formatDateApiLocal(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }

  static bool isMoreThanEPassTime(DateTime targetTime, int minutes) {
    DateTime currentTime = DateTime.now();
    DateTime minutesFromNow = currentTime.add(Duration(minutes: minutes));
    DateTime oneMinuteFromNow = currentTime.add(const Duration(minutes: -1));
    return targetTime.isAfter(minutesFromNow) ||
        targetTime.isBefore(oneMinuteFromNow);
  }

  static bool isPreviousTime(DateTime targetTime) {
    DateTime currentTime = DateTime.now();
    DateTime oneMinuteFromNow = currentTime.add(const Duration(minutes: -1));
    return targetTime.isBefore(oneMinuteFromNow);
  }

  static String formatTimeApi(DateTime date) {
    DateFormat dateFormat = DateFormat('HH:mm:ss');
    String formattedDate = dateFormat.format(date.toUtc());
    return formattedDate;
  }

  static String formatTimeApiLocal(DateTime date) {
    DateFormat dateFormat = DateFormat('HH:mm:ss');
    String formattedDate = dateFormat.format(date);
    return formattedDate;
  }

  static String formatDateTimeApi(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    String formattedDate = dateFormat.format(date.toUtc());
    return formattedDate;
  }

  static String formatTimeToTime(String date) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat outputFormat = DateFormat('hh:mm a');
    DateTime dateTime = inputFormat.parse(date);
    DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute, dateTime.minute);
    DateTime localDateTime = utcDateTime.toLocal();
    String formattedLocalTime = outputFormat.format(localDateTime);
    return formattedLocalTime;
  }

  static String formatOutTime(String date) {
    DateFormat inputFormat = DateFormat('yyyy/mm/dd hh:mm aa');
    DateFormat outputFormat = DateFormat('yyyy/mm/dd hh:mm aa');
    DateTime dateTime = inputFormat.parse(date);
    DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute, dateTime.minute);
    DateTime localDateTime = utcDateTime.toLocal();
    String formattedLocalTime = outputFormat.format(localDateTime);
    return formattedLocalTime;
  }

  static String formatTime(date, bool toLocal) {
    String formattedLocalTime = '';
    try {
      DateTime dateTime = DateTime.parse(date);
      DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
          dateTime.day, dateTime.hour, dateTime.minute, dateTime.minute);
      DateTime localDateTime;
      if (toLocal) {
        localDateTime = utcDateTime.toLocal();
      } else {
        localDateTime = utcDateTime;
      }
      formattedLocalTime = DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      Utils.print(e.toString());
    }
    return formattedLocalTime;
  }

  static double getMultiListHeight(int listLength) {
    return listLength < 6 ? listLength * 48 : 6 * 48;
  }

  static double getSingleDropHeight(int listLength) {
    return listLength < 8 ? listLength * 26 : 8 * 26;
  }

  static bool isDate30DaysOld(DateTime yourDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(yourDate);
    bool is30DaysOld = difference.inDays >= 30;
    return is30DaysOld;
  }

  static bool needToken(Object error) {
    return error.toString().split(' ')[0] == Utils.e401;
  }
}
