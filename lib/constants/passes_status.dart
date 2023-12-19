import 'dart:ui';

import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/models/common_models/value_text_model.dart';

abstract class PassesStatus {
  static List<ValueTextModel> data = [];

  static String to = 'To';
  static String from = 'From';

  static int received = 1;
  static int raised = 2;
  static int approved = 3;
  static int alert = 4;
  static int completed = 5;
  static int rejected = 6;
  static int departed = 7;

  static String getStatus(int id) {
    String status = 'Pending';
    for (int i = 0; i < data.length; i++) {
      if (id == data[i].value) {
        status = data[i].text!;
        break;
      }
    }
    return status;
  }

  static Color getBackgroundColor(int id) {
    Color color = AppColors.pendingColor;
    if (id == 1) {
      color = AppColors.receivedColor;
    } else if (id == 2) {
      color = AppColors.pendingColor;
    } else if (id == 3) {
      color = AppColors.approvedColor;
    } else if (id == 4) {
      color = AppColors.alertColor;
    } else if (id == 5) {
      color = AppColors.completedColor;
    } else if (id == 6) {
      color = AppColors.rejectedColor;
    } else if (id == 7) {
      color = AppColors.departedColor;
    }
    return color;
  }
}
