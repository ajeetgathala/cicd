import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_passes_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/circle_image.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:cicd/widgets/multi_select_dropdown_box.dart';
import 'package:cicd/widgets/small_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrPasses extends StatefulWidget {
  const TrPasses({super.key});

  @override
  State<TrPasses> createState() => _TrPassesState();
}

class _TrPassesState extends State<TrPasses> {
  var controller = Get.put(TrPassesModel());

  @override
  void initState() {
    controller.addFilterData();
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
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: TitleText(
            title: AppStrings.allPass,
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: RefreshIndicator(
              onRefresh: () => controller.getData(),
              child: Obx(
                () => controller.processing.value
                    ? Center(child: Utils.showProgress())
                    : controller.data.isEmpty
                        ? Center(
                            child:
                                Utils.showCenterMessage(AppStrings.noDataFound))
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                getStudentMultiDropDown(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.data.length,
                                    itemBuilder: (context, index) {
                                      return controller.showPass(index)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0.0, right: 0),
                                              child: InkWell(
                                                onTap: () async {
                                                  controller.selectMulti.value =
                                                      false;
                                                  await Get.toNamed(
                                                      Routes.passDetail,
                                                      arguments: [
                                                        controller
                                                            .data[index].id
                                                      ]);
                                                  controller.getData();
                                                },
                                                child: SizedBox(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 0,
                                                              top: 10,
                                                              bottom: 0),
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColors
                                                              .moreGrayLight,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: PassesStatus.getBackgroundColor(controller
                                                                                  .data[
                                                                                      index]
                                                                                  .status!),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(
                                                                                  10))),
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 2,
                                                                              bottom: 2,
                                                                              left: 5,
                                                                              right: 10),
                                                                          alignment: Alignment.center,
                                                                          child: Text(
                                                                              '${PassesStatus.getStatus(controller.data[index].status!)}${controller.data[index].status == 1 ? ' ${AppStrings.at} ${Utils.formatTime(controller.data[index].receivedTime.toString(), true)}' : controller.data[index].status == 3 ? ' ${AppStrings.at} ${Utils.formatTime(controller.data[index].approvedTime.toString(), true)}' : controller.data[index].status == 7 ? ' ${AppStrings.at} ${Utils.formatTime(controller.data[index].departedTime.toString(), true)}' : ''} ',
                                                                              textAlign: TextAlign.end,
                                                                              style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.w500, fontSize: 12))),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const CommonCircleImage(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        icon: Images
                                                                            .user,
                                                                        margin:
                                                                            10,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          PassDetailSmallWidgets.nameWidget(
                                                                              controller.data[index],
                                                                              controller.getBoxWidth(context, index)),
                                                                          PassDetailSmallWidgets.todayPassesText(
                                                                              controller.data[index]),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                      AppStrings
                                                                          .from,
                                                                      style: const TextStyle(
                                                                          color: AppColors
                                                                              .blueDark,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  const SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                            text: controller.getFromText(
                                                                                index),
                                                                            style: const TextStyle(
                                                                                color: AppColors.gray,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15)),
                                                                        if (controller.showOutTime(
                                                                            index))
                                                                          TextSpan(
                                                                              text: ' (${Utils.formatDateTime(controller.data[index].outTime.toString())})',
                                                                              style: const TextStyle(color: AppColors.black, fontSize: 15)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          AppStrings
                                                                              .to,
                                                                          style: const TextStyle(
                                                                              color: AppColors.blueDark,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 15),
                                                                          textAlign: TextAlign.center),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          children: <TextSpan>[
                                                                            TextSpan(
                                                                                text: controller.getToText(index),
                                                                                style: const TextStyle(color: AppColors.gray, fontWeight: FontWeight.w500, fontSize: 15)),
                                                                            if (controller.showInTime(index))
                                                                              TextSpan(text: ' (${Utils.formatDateTime(controller.data[index].inTime.toString())})', style: const TextStyle(color: AppColors.black, fontSize: 15)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            PassDetailSmallWidgets
                                                                .validationWidget(
                                                                    controller
                                                                            .data[
                                                                        index])
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
              )),
        ));
  }

  Widget getStudentMultiDropDown() {
    return Column(
      children: [
        MultiSelectDropdownBox(
          labelText: AppStrings.filter,
          isNotingSelected: controller.isNotingSelected(),
          errorText: '',
          list: controller.filterData,
          onItemRemove: (index) {
            controller.filterData[index].selected =
                !controller.filterData[index].selected!;
            controller.setSelected();
            controller.update();
          },
          onArrowTap: () {
            if (controller.filterData.isNotEmpty) {
              controller.selectMulti.value = !controller.selectMulti.value;
            }
          },
          error: false,
          showList: controller.selectMulti.value,
          onSearchTextChange: (text) {},
          search: false,
          isAllSelected: controller.isAllSelected(),
          onSelectAllCheck: (v) {},
          onListItemSelected: (index) {
            controller.filterData[index].selected =
                !controller.filterData[index].selected!;
            controller.setSelected();
            controller.setSelected();
            controller.update();
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
