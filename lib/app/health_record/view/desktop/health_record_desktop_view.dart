import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';
import 'package:abha/reusable_widget/search/custom_search_view.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';

class HealthRecordDesktopView extends StatefulWidget {
  final VoidCallback onHealthInformationFetch;
  final Function(String) onSearchHealthRecord;

  const HealthRecordDesktopView({
    required this.onHealthInformationFetch,
    required this.onSearchHealthRecord,
    super.key,
  });

  @override
  HealthRecordDesktopViewState createState() => HealthRecordDesktopViewState();
}

class HealthRecordDesktopViewState extends State<HealthRecordDesktopView> {
  late final HealthRecordController _healthRecordController =
      Get.find<HealthRecordController>();
  late final AppTextController _searchTEC = AppTextController();
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
        _searchHealthRecordWidget(),
        GetBuilder<HealthRecordController>(
          builder: (_) {
            Map<String, List<HealthRecordLocalModel>> healthRecordData =
                _healthRecordController.getHealthRecordBasedOnDate();
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _titleHealthRecordWidget(),
                    if (!Validator.isNullOrEmpty(healthRecordData))
                      InkWell(
                        onTap: () {
                          if (abhaSingleton.getAppData
                              .getHealthRecordFetched()) {
                            widget.onHealthInformationFetch();
                          } else {
                            MessageBar.showToastDialog(
                              LocalizationHandler.of().pleaseWaitForRecord,
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              IconAssets.refresh,
                              color: AppColors.colorAppOrange,
                              size: Dimen.d_18,
                            ),
                            Text(
                              LocalizationHandler.of().refreshRecords,
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                decoration: TextDecoration.underline,
                                color: AppColors.colorAppOrange,
                                fontWeightDelta: 2,
                                fontSizeDelta: -2,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ).marginOnly(top: Dimen.d_16),
                Divider(
                  color: AppColors.colorGreyWildSand,
                  thickness: Dimen.d_1,
                ),
                if (Validator.isNullOrEmpty(healthRecordData))
                  _healthRecordValidatorWidget(healthRecordData)
                else
                  _healthRecordDataWidget(healthRecordData)
              ],
            );
          },
        )
      ],
    ).marginSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20);
  }

  Widget _titleHealthRecordWidget() {
    return Row(
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
      ],
    );
  }

  Widget _searchHealthRecordWidget() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        color: AppColors.colorWhite,
        borderColor: AppColors.colorWhite,
      ),
      child: CustomSearchView(
        autofocus: false,
        appTextController: _searchTEC,
        hint: LocalizationHandler.of().selectRecordToView,
        onChanged: (searchValue) {
          _searchHealthRecord = searchValue;
          if (Validator.isNullOrEmpty(_searchHealthRecord)) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
          widget.onSearchHealthRecord(_searchHealthRecord.toLowerCase().trim());
        },
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
          ).marginOnly(top: Dimen.d_10)
        : CustomErrorView(
            status: Validator.isNullOrEmpty(_searchHealthRecord)
                ? Status.error
                : Status.success,
            image: ImageLocalAssets.emptyHealthRecordSvg,
            errorMessageTitle: LocalizationHandler.of().noDataAvailable,
            infoMessageTitle: LocalizationHandler.of().noRecordForHips,
          );
  }

  Widget _healthRecordDataWidget(
    Map<String, List<HealthRecordLocalModel>> healthRecordData,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (_healthRecordController.responseHandler.status == Status.loading ||
            !abhaSingleton.getAppData.getHealthRecordFetched())
          CustomLoadingView(
            loadingMessage: LocalizationHandler.of().syncingRecords,
            style: CustomTextStyle.titleSmall(context)?.apply(),
            width: Dimen.d_20,
            height: Dimen.d_20,
          ).marginOnly(top: Dimen.d_10)
        else
          const SizedBox.shrink(),
        ListView(
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
                ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < healthRecordList.length; i++)
                      DecoratedBox(
                        decoration:
                            abhaSingleton.getBorderDecoration.getElevation(
                          size: 0,
                          borderColor: AppColors.colorPurple3,
                          color: AppColors.colorWhite,
                          isLow: true,
                        ),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              var arguments = {
                                IntentConstant.healthBundleDate:
                                    healthRecordList
                                        .elementAt(i)
                                        .date
                                        .toString(),
                                IntentConstant.healthEntryPosition: i,
                              };
                              context.navigatePush(
                                RoutePath.routeHealthRecordDetail,
                                arguments: arguments,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 50,
                                  child: Text(
                                    healthRecordList.elementAt(i).hipName ?? '',
                                    style: CustomTextStyle.bodySmall(
                                      context,
                                    )?.apply(
                                      color: context.themeData.primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 25,
                                  child: RichText(
                                    text: TextSpan(
                                      style: CustomTextStyle.bodySmall(
                                        context,
                                      )?.apply(
                                        color: AppColors.colorBlack6,
                                        fontSizeDelta: -1,
                                        fontWeightDelta: -1,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${LocalizationHandler.of().patientStatus}: ',
                                        ),
                                        TextSpan(
                                          text: healthRecordList
                                                  .elementAt(i)
                                                  .encounterLocalModel
                                                  ?.status ??
                                              '-',
                                          style: CustomTextStyle.bodySmall(
                                            context,
                                          )?.apply(
                                            color: AppColors.colorBlack6,
                                            fontSizeDelta: -1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 25,
                                  child: RichText(
                                    text: TextSpan(
                                      style: CustomTextStyle.bodySmall(
                                        context,
                                      )?.apply(
                                        color: AppColors.colorBlack6,
                                        fontSizeDelta: -1,
                                        fontWeightDelta: -1,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${LocalizationHandler.of().time}: ',
                                        ),
                                        TextSpan(
                                          text: healthRecordList
                                                  .elementAt(i)
                                                  .date
                                                  ?.formatHHMMA ?? '',
                                          style: CustomTextStyle.bodySmall(
                                            context,
                                          )?.apply(
                                            color: AppColors.colorBlack6,
                                            fontSizeDelta: -1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(
                              vertical: Dimen.d_16,
                              horizontal: Dimen.d_16,
                            ),
                          ),
                        ),
                      )
                  ],
                )
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}
