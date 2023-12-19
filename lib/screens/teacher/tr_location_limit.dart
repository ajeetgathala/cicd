import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_location_limit_model.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/date_time_widget.dart';
import 'package:cicd/widgets/multi_select_dropdown_box.dart';
import 'package:cicd/widgets/text_value_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrLocationLimit extends StatefulWidget {
  const TrLocationLimit({Key? key}) : super(key: key);

  @override
  State<TrLocationLimit> createState() => _TrLocationLimitState();
}

class _TrLocationLimitState extends State<TrLocationLimit> {
  var controller = Get.put(TrLocationLimitModel());

  @override
  void initState() {
    controller.getLocationLimits();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrLocationLimitModel>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            title: Text(
              AppStrings.locationLimit,
              style: const TextStyle(
                  color: AppColors.blueDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
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
                controller.selectMulti.value = false;
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
                  child: SingleChildScrollView(
                    child: getView(),
                  ))));
    });
  }

  Widget getView() {
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MultiSelectDropdownBox(
              labelText: AppStrings.selectLocations,
              isNotingSelected: controller.isNotingSelected(),
              errorText: AppStrings.pleaseSelectLocationLimits,
              list: controller.locationsList,
              onItemRemove: (index) {
                controller.locationsList[index].selected =
                    !controller.locationsList[index].selected!;
                controller.update();
              },
              onArrowTap: () {
                if (controller.locationsList.isNotEmpty) {
                  controller.selectMulti.value = !controller.selectMulti.value;
                }
              },
              error: controller.locationStatusError.value,
              showList: controller.selectMulti.value,
              searchController: controller.searchController.value,
              onSearchTextChange: (text) {
                controller.filterLocations();
              },
              isAllSelected: controller.isAllSelected(),
              onSelectAllCheck: (v) {
                controller.selectAll.value = v!;
                if (controller.selectAll.value) {
                  for (int i = 0; i < controller.locationsList.length; i++) {
                    controller.locationsList[i].selected = true;
                  }
                  controller.selectMulti.value = false;
                } else {
                  for (int i = 0; i < controller.locationsList.length; i++) {
                    controller.locationsList[i].selected = false;
                  }
                }
                controller.update();
              },
              onListItemSelected: (index) {
                controller.locationsList[index].selected =
                    !controller.locationsList[index].selected!;
                controller.update();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextValueDropDown(
              items: controller.limitsList,
              selectedValue: (value) {
                controller.limit = value;
                controller.update();
              },
              errorText: AppStrings.pleaseSelectLimit,
              hint: AppStrings.selectLimit,
              title: AppStrings.limit,
              isInvalid: controller.limitError.value,
              selectedItem: controller.limit,
              onCancel: () {
                controller.limit = ValueTextModel(
                    value: -1, text: '', type: '', selected: false);
                controller.update();
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: DateTimeWidget(
                labelTextMain: AppStrings.expiryDate,
                labelText: controller.selectedDate.value,
                hintTextColor: controller.dateColor,
                isInvalid: controller.dateError.value,
                errorText: AppStrings.pleaseSelectExpiryDate,
                onTap: () {
                  controller.selectDate(context);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.width / 3), bottom: 80),
              child: CommonButtonWidget(
                onPressed: () {
                  controller.validations();
                },
                buttonText: AppStrings.save,
                buttonColor: AppColors.blue,
                textSize: 15,
                assetIcon: '',
                isProcessing: controller.processing.value,
              ),
            )
          ],
        ));
  }
}
