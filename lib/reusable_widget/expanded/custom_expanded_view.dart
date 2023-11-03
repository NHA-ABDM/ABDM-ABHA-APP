import 'package:abha/app/app_intro/view/desktop/app_intro_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/animated_widget/expanded_view.dart';

class CustomExpandedView extends StatefulWidget {
  final List<ExpandModel>? dataList;

  const CustomExpandedView({super.key, this.dataList});

  @override
  CustomExpandedViewState createState() => CustomExpandedViewState();
}

class CustomExpandedViewState extends State<CustomExpandedView> {
  int? _selected = -1;
  late List<ExpandModel> _dataList;

  @override
  void initState() {
    _dataList = widget.dataList ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _dataList.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.colorWhiteAliceBlue,
                  width: Dimen.d_0_5,
                ),
                borderRadius: BorderRadius.circular(Dimen.d_10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.colorDropShadow,
                    blurRadius: Dimen.d_1,
                    spreadRadius: Dimen.d_1,
                    offset: const Offset(0.0, 2.5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_selected == i) {
                          _selected = -1;
                        } else {
                          _selected = i;
                        }
                      });
                    },
                    child: Container(
                      color: _selected == i
                          ? AppColors.colorAppBlue1
                          : AppColors.colorWhite,
                      padding: EdgeInsets.symmetric(
                        vertical: Dimen.d_12,
                        horizontal: Dimen.d_16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dataList[i].title,
                            style: TextStyle(
                              fontSize: Dimen.d_16,
                              fontWeight: FontWeight.w500,
                              color: _selected == i
                                  ? AppColors.colorWhite
                                  : AppColors.colorAppBlue1,
                            ),
                          ).paddingOnly(left: Dimen.d_10).alignAtCenterLeft(),
                          Icon(
                            _selected == i
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_outlined,
                            color: _selected == i
                                ? AppColors.colorWhite
                                : AppColors.colorAppBlue1,
                          )
                        ],
                      ),
                    ),
                  ),
                  ExpandedView(
                    expand: _selected == i,
                    child: ColoredBox(
                      color: AppColors.colorWhite,
                      child: Text(
                        _dataList[i].desc,
                        style: CustomTextStyle.labelLarge(context)?.apply(
                          color: AppColors.colorBlack4,
                          heightDelta: Dimen.d_0_5,
                          fontWeightDelta: -1,
                        ),
                      )
                          .paddingSymmetric(
                            vertical: Dimen.d_12,
                            horizontal: Dimen.d_16,
                          )
                          .alignAtTopLeft(),
                    ),
                  )
                ],
              ),
              // child: ExpansionTile(
              //   tilePadding: EdgeInsets.zero,
              //   childrenPadding: EdgeInsets.zero,
              //   // textColor:  _selected == i
              //   //     ? AppColors.colorWhite
              //   //     : AppColors.colorAppBlue1,
              //   initiallyExpanded: _selected == i,
              //   onExpansionChanged: (expanded) {
              //     if (expanded) {
              //       setState(() {
              //         _selected = i;
              //       });
              //     }
              //   },
              //   title: Container(
              //     color: Colors.red,
              //     child: Text(
              //       _dataList[i].title,
              //       style: TextStyle(
              //         fontSize: Dimen.d_16,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              //   children: [
              //     ColoredBox(
              //       color: AppColors.colorWhite,
              //       child: Text(
              //         _dataList[i].desc,
              //         style: CustomTextStyle.labelLarge(context)?.apply(
              //           color: AppColors.colorBlack4,
              //           heightDelta: Dimen.d_0_5,
              //           fontWeightDelta: -1,
              //         ),
              //       ).paddingOnly(left: Dimen.d_16, bottom: Dimen.d_10).alignAtTopLeft(),
              //     ),
              //   ],
              // ),
              // child: ExpansionPanelList(
              //   expandedHeaderPadding: EdgeInsets.zero,
              //   expandIconColor: AppColors.colorWhite,
              //   expansionCallback: (int index, bool status) {
              //     setState(() {
              //       _selected = _selected == i ? null : i;
              //     });
              //   },
              //   children: [
              //     ExpansionPanel(
              //       isExpanded: _selected == i,
              //       canTapOnHeader: true,
              //       backgroundColor: (_selected == i)
              //           ? AppColors.colorAppBlue1
              //           : AppColors.colorWhite,
              //       headerBuilder: (BuildContext context, bool isExpanded) {
              //         return Container(
              //           color: isExpanded
              //               ? AppColors.colorAppBlue1
              //               : AppColors.colorWhite,
              //           child: Text(
              //             _dataList[i].title,
              //             style: TextStyle(
              //               fontSize: Dimen.d_16,
              //               fontWeight: FontWeight.w500,
              //               color: isExpanded
              //                   ? AppColors.colorWhite
              //                   : AppColors.colorAppBlue1,
              //             ),
              //           ).paddingOnly(left: Dimen.d_10).alignAtCenterLeft(),
              //         );
              //       },
              //       body: ColoredBox(
              //         color: AppColors.colorWhite,
              //         child: Text(
              //           _dataList[i].desc,
              //           style: CustomTextStyle.labelLarge(context)?.apply(
              //             color: AppColors.colorBlack4,
              //             heightDelta: Dimen.d_0_5,
              //             fontWeightDelta: -1,
              //           ),
              //         )
              //             .paddingOnly(left: Dimen.d_15, bottom: Dimen.d_10)
              //             .alignAtTopLeft(),
              //       ),
              //     )
              //   ],
              // ),
            );
          },
        ),
        Text(
          LocalizationHandler.of().cantFindAnswer,
          style: CustomTextStyle.labelLarge(context)?.apply(
            color: AppColors.colorGreyDark4,
            heightDelta: 0.5,
          ),
        ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_10),
        TextButtonPurple.desktop(
          text: LocalizationHandler.of().contactUs.toTitleCase(),
          onPressed: () {
            context.navigatePush(RoutePath.routeSupport);
          },
        )
      ],
    );
  }
}
