import 'dart:async';

import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/comments_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  var controller = Get.put(CommentsModel());

  @override
  void initState() {
    controller.getData(Get.arguments[0]);
    controller.refreshOnNotification();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton:
          !UserType.isStudent() && PrivilegeFirstFlags.canViewEPassCommentList()
              ? FloatingActionButton.small(
                  onPressed: () async {
                    showMyDialog(Get.arguments[0]);
                  },
                  backgroundColor: AppColors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.whiteColor,
                  ),
                )
              : null,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: TitleText(
          title: AppStrings.teacherNotes,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blueDark,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Obx(
            () => controller.processing.value
                ? Utils.showProgress()
                : controller.data.isEmpty
                    ? Utils.showCenterMessage(AppStrings.noNoteFound)
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: controller.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0.0, right: 0),
                                    child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 8),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppColors.moreGrayLight,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    controller
                                                        .data[index].creator
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.blueDark,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      size: 20,
                                                      color: AppColors.gray,
                                                    ),
                                                    Text(
                                                        Utils.formatDateTime(
                                                            controller
                                                                .data[index]
                                                                .creationDate
                                                                .toString()),
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.gray,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    controller
                                                        .data[index].comment
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: AppColors.gray,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          )),
    );
  }

  Future<void> showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            // title: const Text('AlertDialog Title'),
            elevation: 20,
            contentPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.postANote,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: AppColors.mainLabelText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.blueLight),
                      ),
                      child: TextFormField(
                        focusNode: controller.commentFocus.value,
                        controller: controller.commentController.value,
                        maxLines: 5,
                        minLines: 3,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 13),
                        cursorColor: AppColors.black,
                        decoration: InputDecoration(
                          counterText: "",
                          hintStyle: const TextStyle(
                            color: AppColors.gray,
                          ),
                          hintText: AppStrings.pleaseEnterANote,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          value = value;
                        },
                      ),
                    ),
                    if (controller.commentError.value)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error,
                              color: AppColors.red,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Flexible(
                              child: Text(
                                AppStrings.pleaseEnterANote,
                                style: const TextStyle(
                                    color: AppColors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 0),
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 0, left: 0, right: 0),
                            width: 100,
                            child: CommonButtonWidget(
                              onPressed: () {
                                controller.commentError.value = false;
                                controller.commentFocus.value.unfocus();
                                Get.back();
                              },
                              height: 40,
                              buttonText: AppStrings.cancel,
                              cornerRadius: 5,
                              buttonColor: AppColors.grayLight,
                              assetIcon: '',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 0),
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 0, left: 0, right: 0),
                            width: 100,
                            child: CommonButtonWidget(
                              onPressed: () {
                                controller.commentFocus.value.unfocus();
                                controller.postComment(id);
                              },
                              height: 40,
                              buttonText: AppStrings.send,
                              cornerRadius: 5,
                              buttonColor: AppColors.blue,
                              isProcessing: controller.sendingComment.value,
                              assetIcon: '',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )));
      },
    );
  }
}
