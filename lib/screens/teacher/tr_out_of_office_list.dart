import 'package:cicd/app_flags/constraint_permissions.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_out_of_office_list_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrOutOfOfficeList extends StatefulWidget {
  const TrOutOfOfficeList({super.key});

  @override
  State<TrOutOfOfficeList> createState() => _TrOutOfOfficeListState();
}

class _TrOutOfOfficeListState extends State<TrOutOfOfficeList> {
  var controller = Get.put(TrOutOfOfficeListModel());

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
        backgroundColor: AppColors.whiteColor,
        floatingActionButton: ConstraintFlags.canCreateOutOfOffice()
            ? FloatingActionButton.small(
                onPressed: () async {
                  await Get.toNamed(Routes.trOutOfOffice, arguments: [0]);
                  controller.getData();
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
            title: AppStrings.outOfOffice,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(Icons.arrow_back),
              )),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () => controller.getData(),
            child: Obx(() => controller.processing.value
                ? Utils.showProgress()
                : controller.data.isEmpty
                    ? Utils.showCenterMessage(AppStrings.noDataFound)
                    : Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: ListView.builder(
                            itemCount: controller.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: AppColors.moreGrayLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                    controller
                                                        .data[index].teacherName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.blueDark,
                                                        // fontWeight: FontWeight.w600,
                                                        fontSize: 18)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: Icon(
                                                  Icons.calendar_month,
                                                  size: 18,
                                                  color: AppColors.grayLight,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                controller.showTime(index),
                                                style: const TextStyle(
                                                  color: AppColors.grayLight,
                                                  // color: AppColors.grayColorLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppStrings.hashOfTimesTriggered,
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  // color: AppColors.grayColorLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                controller
                                                    .data[index].repetition
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  // color: AppColors.grayColorLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (controller
                                              .data[index].reason!.isNotEmpty)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  AppStrings.reason,
                                                  style: const TextStyle(
                                                    color: AppColors.black,
                                                    // color: AppColors.grayColorLight,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    controller
                                                        .data[index].reason
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      color: AppColors.black,
                                                      // color: AppColors.grayColorLight,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppStrings.status,
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  // color: AppColors.grayColorLight,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    decoration: const BoxDecoration(
                                                        color: AppColors
                                                            .greenMoreLight,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7))),
                                                    child: Text(
                                                      controller
                                                          .data[index].status
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .greenColor,
                                                        // color: AppColors.grayColorLight,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  if (ConstraintFlags
                                                      .canOverrideSOutOfOffice())
                                                    InkWell(
                                                      onTap: () async {
                                                        await Get.toNamed(
                                                            Routes
                                                                .trOutOfOffice,
                                                            arguments: [
                                                              controller
                                                                  .data[index]
                                                                  .id
                                                            ]);
                                                        controller.getData();
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                right: 8),
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .moreGrayLight,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7)),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .greenColor)),
                                                        child: Text(
                                                          AppStrings.edit,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .greenColor,
                                                            // color: AppColors.grayColorLight,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            })))));
  }
}
