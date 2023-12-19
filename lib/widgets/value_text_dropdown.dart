import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';

class ValueTextDropDown extends StatefulWidget {
  final String? title;
  final String? hint;
  final String errorText;
  final List<ValueTextModel> items;
  final bool isInvalid;
  final ValueTextModel selectedItem;
  final int compareItemId;
  final Function(ValueTextModel) selectedValue;
  final Function(bool) onTap;
  final Function() onCancel;
  final bool search;
  final Color titleColor;
  final Color borderColor;
  final bool whiteHint;
  final double width;
  final bool enabled;
  final bool select;

  const ValueTextDropDown(
      {super.key,
      this.title = '',
      this.hint = '',
      this.errorText = '',
      required this.items,
      this.isInvalid = false,
      required this.selectedItem,
      this.compareItemId = 0,
      required this.selectedValue,
      required this.onTap,
      required this.onCancel,
      this.search = true,
      this.titleColor = AppColors.mainLabelText,
      this.borderColor = AppColors.blueLight,
      this.whiteHint = false,
      this.width = 0,
      this.enabled = true,
      this.select = false});

  @override
  State<ValueTextDropDown> createState() => _TextValueDropDownState();
}

class _TextValueDropDownState extends State<ValueTextDropDown> {
  // bool select = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          widget.width == 0 ? MediaQuery.of(context).size.width : widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? AppStrings.student,
            style: TextStyle(
              color: widget.titleColor,
              fontSize: 12,
            ),
          ),
          InkWell(
            onTap: () {
              widget.onTap(widget.select);
              setState(() {
                if (widget.enabled) {
                  // select = !select;
                  for (int i = 0; i < widget.items.length; i++) {
                    widget.items[i].search = true;
                  }
                }
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: widget.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    width: widget.width == 0
                        ? MediaQuery.of(context).size.width - 130
                        : widget.width - 90,
                    child: Text(
                      widget.selectedItem.text?.isNotEmpty ?? false
                          ? widget.selectedItem.text!
                          : widget.hint!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: widget.whiteHint
                              ? AppColors.whiteColor
                              : widget.selectedItem.text!.isEmpty
                                  ? AppColors.gray
                                  : AppColors.blueDark),
                    ),
                  ),
                  if (widget.enabled)
                    Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                          color: widget.whiteHint
                              ? AppColors.whiteColor
                              : AppColors.grayLight,
                        )),
                  if (widget.selectedItem.text!.isNotEmpty)
                    InkWell(
                      onTap: widget.onCancel,
                      child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.clear,
                            color: widget.whiteHint
                                ? AppColors.whiteColor
                                : AppColors.grayLight,
                          )),
                    ),
                ],
              ),
            ),
          ),
          if (widget.select)
            Card(
              elevation: 10,
              child: widget.items.isEmpty
                  ? Center(child: Text(AppStrings.noDataFound))
                  : SizedBox(
                      child: Column(
                        children: [
                          if (widget.search)
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: AppStrings.search,
                                  hintStyle: const TextStyle(
                                    color: AppColors.gray,
                                  ),
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                                onChanged: (v) {
                                  setState(() {
                                    for (int i = 0;
                                        i < widget.items.length;
                                        i++) {
                                      if (v.trim() == '') {
                                        widget.items[i].search = true;
                                      } else {
                                        if (widget.items[i].text!
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
                          if (widget.search)
                            Container(
                              height: 1,
                              color: AppColors.blueDark,
                            ),
                          SizedBox(
                            height:
                                Utils.getSingleDropHeight(widget.items.length),
                            child: ListView.builder(
                                itemCount: widget.items.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return widget.items[index].search! &&
                                          widget.compareItemId !=
                                              widget.items[index].value
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  widget.selectedValue(
                                                      widget.items[index]);
                                                  // select = false;
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.items[index].text!,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   height: .1,
                                            //   color: AppColors.blueDark,
                                            // )
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error,
                    color: AppColors.red,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: Text(
                      widget.errorText,
                      style:
                          const TextStyle(color: AppColors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
