import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';
import 'package:abha/reusable_widget/search/custom_search_view.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';
import 'package:flutter/foundation.dart';

class HealthRecordMobileView extends StatefulWidget {
  final bool fromDashBoard;
  final VoidCallback onHealthInformationFetch;
  final Function(String) onSearchHealthRecord;

  const HealthRecordMobileView({
    required this.fromDashBoard,
    required this.onHealthInformationFetch,
    required this.onSearchHealthRecord,
    super.key,
  });

  @override
  HealthRecordMobileViewState createState() => HealthRecordMobileViewState();
}

class HealthRecordMobileViewState extends State<HealthRecordMobileView> {
  late final HealthRecordController _healthRecordController =
      Get.find<HealthRecordController>();
  late final AppTextController _searchTEC =
      AppTextController(enabled: widget.fromDashBoard ? false : true);
  String _searchHealthRecord = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _healthRecordWidget();
  }

  Widget _healthRecordWidget() {
    return Column(
      children: [
        _titleHealthRecordWidget(),
        _searchHealthRecordWidget(),
        GetBuilder<HealthRecordController>(
          builder: (_) {
            Map<String, List<HealthRecordLocalModel>> healthRecordData =
                _healthRecordController.getHealthRecordBasedOnDate();
            return Validator.isNullOrEmpty(healthRecordData)
                ? kIsWeb
                    ? _healthRecordValidatorWidget(healthRecordData)
                    : _healthRecordValidatorWidget(healthRecordData).flexible()
                : kIsWeb
                    ? _healthRecordMobileWidget(healthRecordData)
                    : _healthRecordMobileWidget(healthRecordData).expand();
          },
        )
      ],
    );
  }

  Widget _titleHealthRecordWidget() {
    return widget.fromDashBoard
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              LocalizationHandler.of().myHealthRecords,
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                color: AppColors.colorBlack6,
                                fontWeightDelta: 2,
                                fontSizeDelta: -1,
                              ),
                            ),
                            CustomToolTipMessage(
                              message: LocalizationHandler.of().recordsTakeTime,
                            ).marginOnly(left: Dimen.d_5, right: Dimen.d_10),
                            // Tooltip(
                            //   verticalOffset: 30.0,
                            //   showDuration: const Duration(seconds: 10),
                            //   padding: EdgeInsets.only(
                            //     left: Dimen.d_8,
                            //     top: Dimen.d_8,
                            //     bottom: Dimen.d_8,
                            //     right: Dimen.d_5,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(Dimen.d_4),
                            //     color: AppColors.colorBlack.withOpacity(0.7),
                            //   ),
                            //   triggerMode: TooltipTriggerMode.tap,
                            //   message: LocalizationHandler.of().recordsTakeTime,
                            //   child: Icon(
                            //     IconAssets.infoOutline,
                            //     size: Dimen.d_15,
                            //   ),
                            // ).marginOnly(left: Dimen.d_5, right: Dimen.d_10),
                          ],
                        ),
                        Text(
                          LocalizationHandler.of().selectRecordToView,
                          style: CustomTextStyle.labelMedium(context)?.apply(
                            color: AppColors.colorGreyDark7,
                            fontWeightDelta: 2,
                          ),
                        ).marginOnly(top: Dimen.d_5),
                      ],
                    ),
                  ),
                  // GetBuilder<HealthRecordController>(
                  //   builder: (_) {
                  //     return (_healthRecordController.responseHandler.status == Status.loading)
                  //         ? const SizedBox()
                  //         : (Validator.isNullOrEmpty(
                  //             _healthRecordApiFetchController.errorMsg,
                  //           ))
                  //             ? const SizedBox.shrink()
                  //             : IconButton(
                  //                 onPressed: () {
                  //                   _showErrorMsgDialog();
                  //                 },
                  //                 icon: const Icon(
                  //                   IconAssets.infoFileOutline,
                  //                   color: AppColors.colorRed,
                  //                 ),
                  //               ).alignAtTopRight().marginOnly(right: Dimen.d_10);
                  //   },
                  // )
                ],
              ).paddingOnly(
                left: Dimen.d_23,
                right: Dimen.d_23,
                top: Dimen.d_10,
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _searchHealthRecordWidget() {
    return InkWell(
      onTap: () {
        if (widget.fromDashBoard) {
          context
              .navigatePush(RoutePath.routeHealthRecordSearch)
              .whenComplete(() {
            _searchHealthRecord = '';
            widget
                .onSearchHealthRecord(_searchHealthRecord.toLowerCase().trim());
          });
        }
      },
      child: DecoratedBox(
        decoration: abhaSingleton.getBorderDecoration.getElevation(
          color: AppColors.colorWhite,
          borderColor: AppColors.colorWhite,
        ),
        child: CustomSearchView(
          autofocus: false,
          appTextController: _searchTEC,
          hint: LocalizationHandler.of().searchRecord,
          onChanged: (searchValue) {
            _searchHealthRecord = searchValue;
            if (Validator.isNullOrEmpty(_searchHealthRecord)) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            widget
                .onSearchHealthRecord(_searchHealthRecord.toLowerCase().trim());
          },
        ),
      ).paddingSymmetric(
        vertical: Dimen.d_10,
        horizontal: Dimen.d_20,
      ),
    );
  }

  Widget _healthRecordValidatorWidget(
    Map<String, List<HealthRecordLocalModel>> healthRecordData,
  ) {
    return _healthRecordController.responseHandler.status == Status.loading ||
            !abhaSingleton.getAppData.getHealthRecordFetched()
        ? CustomLoadingView(
            loadingMessage: LocalizationHandler.of().fetchingRecord,
            style:
                CustomTextStyle.labelMedium(context)?.apply(fontSizeDelta: 2),
            width: Dimen.d_20,
            height: Dimen.d_20,
          ).sizedBox(height: Dimen.d_50).marginOnly(top: Dimen.d_10)
        : CustomErrorView(
            status: Validator.isNullOrEmpty(_searchHealthRecord)
                ? Status.error
                : Status.success,
            image: ImageLocalAssets.emptyHealthRecordSvg,
            imageHeight: context.height * 0.15,
            errorMessageTitle: LocalizationHandler.of().noDataAvailable,
            infoMessageTitle: LocalizationHandler.of().noRecordForHips,
          );
  }

  Widget _healthRecordMobileWidget(
    Map<String, List<HealthRecordLocalModel>> healthRecordData,
  ) {
    return Column(
      children: [
        _healthRecordLoaderWidget(),
        if (kIsWeb)
          _healthRecordListWidget(healthRecordData)
        else
          _healthRecordListWidget(healthRecordData).flexible()
      ],
    );
  }

  Widget _healthRecordLoaderWidget() {
    return _healthRecordController.responseHandler.status == Status.loading ||
            !abhaSingleton.getAppData.getHealthRecordFetched()
        ? CustomLoadingView(
            loadingMessage: LocalizationHandler.of().syncingRecords,
            style: CustomTextStyle.titleSmall(context)?.apply(),
            width: Dimen.d_20,
            height: Dimen.d_20,
          ).marginOnly(top: Dimen.d_10)
        : const SizedBox.shrink();
  }

  Widget _healthRecordListWidget(
    Map<String, List<HealthRecordLocalModel>> healthRecordData,
  ) {
    return ListView(
      shrinkWrap: true,
      children: healthRecordData.entries.map((e) {
        String recordDate = e.key;
        List<HealthRecordLocalModel> healthRecordList = e.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              recordDate.formatDDMMMMYYYY,
              style: CustomTextStyle.titleSmall(context)?.apply(
                color: AppColors.colorGreyDark,
              ),
            ).marginOnly(top: Dimen.d_10, bottom: Dimen.d_10),
            Column(
              children: [
                for (int i = 0; i < healthRecordList.length; i++)
                  DecoratedBox(
                    decoration: abhaSingleton.getBorderDecoration.getElevation(
                      size: 0,
                      borderColor: AppColors.colorPurple3,
                      color: AppColors.colorWhite,
                      isLow: true,
                    ),
                    child: ListTile(
                      title: Text(
                        healthRecordList.elementAt(i).hipName ?? '',
                        style: CustomTextStyle.bodySmall(
                          context,
                        )?.apply(
                          color: AppColors.colorGreyDark3,
                          fontWeightDelta: -1,
                        ),
                      ),
                      trailing: Icon(
                        IconAssets.navigateNext,
                        size: Dimen.d_15,
                        color: AppColors.colorBlack,
                      ),
                      onTap: () {
                        var arguments = {
                          IntentConstant.healthBundleDate:
                              healthRecordList.elementAt(i).date.toString(),
                          IntentConstant.healthEntryPosition: i,
                        };
                        context.navigatePush(
                          RoutePath.routeHealthRecordDetail,
                          arguments: arguments,
                        );
                      },
                    ),
                  )
              ],
            )
          ],
        );
      }).toList(),
    ).paddingAll(Dimen.d_20);
  }
}
