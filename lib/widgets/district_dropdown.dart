import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/all_models/district_data_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DistrictDropDown extends StatefulWidget {
  final String? title;
  final List<DistrictDataModel> items;
  final bool isInvalid;
  final int? selectedIndex;
  final DistrictDataModel selectedItem;
  final Function(DistrictDataModel) selectedValue;

  const DistrictDropDown({
    super.key,
    this.title = '',
    required this.items,
    this.isInvalid = false,
    this.selectedIndex,
    required this.selectedItem,
    required this.selectedValue,
  });

  @override
  State<DistrictDropDown> createState() => _DistrictDropDownState();
}

class _DistrictDropDownState extends State<DistrictDropDown> {
  bool select = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? AppStrings.district,
            style: const TextStyle(
              color: AppColors.mainLabelText,
              fontSize: 12,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                select = !select;
                for (int i = 0; i < widget.items.length; i++) {
                  widget.items[i].search = true;
                }
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.blueLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width - 110,
                    child: Text(
                      widget.selectedItem.name ?? AppStrings.select,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: widget.selectedItem.name!.isEmpty
                              ? AppColors.gray
                              : AppColors.blueDark),
                    ),
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 30,
                        color: AppColors.grayLight,
                      )),
                ],
              ),
            ),
          ),
          if (select)
            Card(
              elevation: 10,
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: AppStrings.search,
                        ),
                        onChanged: (v) {
                          setState(() {
                            for (int i = 0; i < widget.items.length; i++) {
                              if (v.trim() == '') {
                                widget.items[i].search = true;
                              } else {
                                if (widget.items[i].name!
                                    .toLowerCase()
                                    .contains(v.toLowerCase())) {
                                  widget.items[i].search = true;
                                } else {
                                  widget.items[i].search = false;
                                }
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.blueDark,
                    ),
                    SizedBox(
                      height: Utils.getSingleDropHeight(widget.items.length),
                      child: ListView.builder(
                          itemCount: widget.items.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return widget.items[index].search
                                ? Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          widget.selectedValue(
                                              widget.items[index]);
                                          setState(() {
                                            select = false;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: const BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.items[index].name!,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: .1,
                                        color: AppColors.blueDark,
                                      )
                                    ],
                                  )
                                : Container();
                          }),
                    )
                  ],
                ),
              ),
            ),
          if (widget.isInvalid)
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
                    AppStrings.pleaseSelectDistrict,
                    style: const TextStyle(color: AppColors.red, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
