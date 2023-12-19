import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_passes_list_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StPassesList extends StatefulWidget {
  const StPassesList({Key? key}) : super(key: key);

  @override
  State<StPassesList> createState() => _StPassesListState();
}

class _StPassesListState extends State<StPassesList> {
  var args = Get.arguments;

  var controller = Get.put(StPassesListModel());

  @override
  void initState() {
    controller.getData();
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
        body: RefreshIndicator(
            onRefresh: () => controller.getData(),
            child: Obx(() => controller.processing.value
                ? Utils.showProgress()
                : controller.data.isEmpty
                    ? Utils.showCenterMessage(AppStrings.noDataFound)
                    : Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: ListView.builder(
                            itemCount: controller.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  await Get.toNamed(Routes.passDetail,
                                      arguments: [controller.data[index].id]);
                                  controller.getData();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: const BoxDecoration(
                                      color: AppColors.moreGrayLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: PassesStatus
                                                        .getBackgroundColor(
                                                            controller
                                                                .data[index]
                                                                .status!),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                padding: const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                    left: 5,
                                                    right: 10),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    '${PassesStatus.getStatus(controller.data[index].status!)}${controller.data[index].status == 1 ? ' AT ${Utils.formatTime(controller.data[index].receivedTime.toString(), true)}' : controller.data[index].status == 3 ? ' AT ${Utils.formatTime(controller.data[index].approvedTime.toString(), true)}' : controller.data[index].status == 7 ? ' AT ${Utils.formatTime(controller.data[index].departedTime.toString(), true)}' : ''} ',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12))),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              AppStrings.from,
                                              style: const TextStyle(
                                                  color: AppColors.blueDark,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                                child: Text(AppStrings.to,
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.blueDark,
                                                        fontWeight:
                                                            FontWeight.w600)))
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.blueBg24,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CommonCircleImage(
                                                      margin: 10,
                                                      icon: controller
                                                          .getFromIcon(index),
                                                      url: controller
                                                          .getFromImage(index),
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            controller
                                                                .getFromText(
                                                                    index),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .blueDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          if (controller
                                                              .showFromSubTitle(
                                                                  index))
                                                            Text(
                                                              controller
                                                                  .data[index]
                                                                  .departingTeacherName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 2,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .grayLight,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 25,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.blueBg24,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CommonCircleImage(
                                                      margin: 10,
                                                      icon: controller
                                                          .getToIcon(index),
                                                      url: controller
                                                          .getToImage(index),
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            controller
                                                                .getToText(
                                                                    index),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .blueDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          if (controller
                                                              .showToSubTitle(
                                                                  index))
                                                            Text(
                                                              controller
                                                                  .data[index]
                                                                  .destinationTeacherName
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 2,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .grayLight,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (controller.showOutTime(index))
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                AppStrings.outTime,
                                                style: const TextStyle(
                                                    color: AppColors.blueDark,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      Utils.formatTime(
                                                          controller.data[index]
                                                              .outTime
                                                              .toString(),
                                                          true),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.grayLight,
                                                        fontSize: 12,
                                                      )))
                                            ],
                                          ),
                                        if (controller.showOutTime(index))
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        if (controller.showInTime(index))
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                AppStrings.finalTimeIn,
                                                style: const TextStyle(
                                                    color: AppColors.blueDark,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      Utils.formatTime(
                                                          controller.data[index]
                                                              .inTime
                                                              .toString(),
                                                          true),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.grayLight,
                                                        fontSize: 12,
                                                      )))
                                            ],
                                          ),
                                        if (controller.showDiffTime(index))
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        if (controller.showDiffTime(index))
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                AppStrings.totalTime,
                                                style: const TextStyle(
                                                    color: AppColors.blueDark,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      controller
                                                          .data[index].diffTime
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.grayLight,
                                                        fontSize: 12,
                                                      )))
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ))));
  }
}
