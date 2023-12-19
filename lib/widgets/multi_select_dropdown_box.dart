import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class MultiSelectDropdownBox extends StatelessWidget {
  final String labelText;
  final bool isNotingSelected;
  final String errorText;
  final List<ValueTextModel> list;
  final Function(int) onItemRemove;
  final Function() onArrowTap;
  final bool error;
  final bool showList;
  final TextEditingController? searchController;
  final Function(String) onSearchTextChange;
  final bool isAllSelected;
  final Function(bool?) onSelectAllCheck;
  final Function(int) onListItemSelected;
  final bool search;

  const MultiSelectDropdownBox(
      {Key? key,
      required this.labelText,
      required this.isNotingSelected,
      required this.errorText,
      required this.list,
      required this.onItemRemove,
      required this.onArrowTap,
      required this.error,
      required this.showList,
      this.searchController,
      required this.onSearchTextChange,
      required this.isAllSelected,
      required this.onSelectAllCheck,
      required this.onListItemSelected,
      this.search = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: const TextStyle(
                color: AppColors.mainLabelText,
                fontSize: 12,
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isNotingSelected
                      ? Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 80,
                          child: ListView.builder(
                              itemCount: list.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return list[index].selected!
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, bottom: 10, left: 10),
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        decoration: const BoxDecoration(
                                          color: AppColors.moreGrayLight,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              list[index].text!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                onItemRemove(index);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .blueLight),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 20,
                                                  )),
                                            )
                                          ],
                                        ))
                                    : Container();
                              }))
                      : Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            AppStrings.select,
                            style: const TextStyle(color: AppColors.gray),
                          )),
                  InkWell(
                    onTap: onArrowTap,
                    child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                          color: AppColors.grayLight,
                        )),
                  )
                ],
              ),
            ),
            if (error)
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
                    Text(
                      AppStrings.pleaseSelectStudents,
                      style:
                          const TextStyle(color: AppColors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (showList)
          Card(
            elevation: 10,
            child: SizedBox(
              child: Column(
                children: [
                  if (search)
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: searchController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: AppStrings.search,
                          hintStyle: const TextStyle(
                            color: AppColors.gray,
                          ),
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onChanged: onSearchTextChange,
                      ),
                    ),
                  if (search)
                    if (searchController!.value.text.trim().isEmpty)
                      Row(
                        children: [
                          Checkbox(
                            value: isAllSelected,
                            onChanged: onSelectAllCheck,
                            checkColor: AppColors.whiteColor,
                            activeColor: AppColors.blue,
                          ),
                          Text(AppStrings.selectAll)
                        ],
                      ),
                  if (search)
                    Container(
                      height: 1,
                      color: AppColors.blueDark,
                    ),
                  SizedBox(
                    height: Utils.getMultiListHeight(list.length),
                    child: ListView.builder(
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return list[index].search!
                              ? InkWell(
                                  onTap: () {
                                    onListItemSelected(index);
                                  },
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: list[index].selected,
                                            onChanged: (v) {
                                              onListItemSelected(index);
                                            },
                                            checkColor: AppColors.whiteColor,
                                            activeColor: AppColors.blue,
                                          ),
                                          Flexible(
                                            child: Text(
                                              list[index].text!,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              : Container();
                        }),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
