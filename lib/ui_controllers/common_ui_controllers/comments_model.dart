import 'dart:async';

import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/pass_comments_data_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsModel extends GetxController {
  List<PassCommentsDataModel> data = <PassCommentsDataModel>[].obs;

  RxBool processing = true.obs;
  var repository = getIt<Repositories>();
  var commentFocus = FocusNode().obs;

  final commentController = TextEditingController().obs;
  RxBool commentError = false.obs;
  RxBool sendingComment = false.obs;

  var utils = getIt<Utils>();

  Future<void> getData(id) async {
    await repository.getCommentsList(id).then((value) async {
      data = (value as List)
          .map((i) => PassCommentsDataModel.fromJson(i))
          .toList();
      processing.value = true;
      processing.value = false;
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getData(id));
      } else {
        processing.value = false;
      }
    });
  }

  void refreshOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (Get.currentRoute == Routes.comments) {
        getData(Get.arguments[0]);
      }
    });
  }

  Future<void> postComment(id) async {
    commentError.value = false;
    if (commentController.value.text.isEmpty) {
      commentError.value = true;
    } else {
      var request = {"ePassId": id, "comment": commentController.value.text};
      sendingComment.value = true;
      await repository.postComment(request).then((value) async {
        sendingComment.value = false;
        Get.back();
        utils.successMessage(AppStrings.commentPosted);
        getData(id);
        commentController.value.text = '';
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await repository.tokenRefreshApi().then((value) => postComment(id));
        } else {
          sendingComment.value = false;
        }
      });
    }
  }
}
