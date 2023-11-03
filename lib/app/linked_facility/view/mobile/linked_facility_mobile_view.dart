import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:flutter/foundation.dart';

class LinkedFacilityMobileView extends StatefulWidget {
  final VoidCallback fetchLinkFacilityData;
  final VoidCallback onDiscoveryLinking;

  const LinkedFacilityMobileView({
    required this.fetchLinkFacilityData,
    required this.onDiscoveryLinking,
    super.key,
  });

  @override
  LinkedFacilityMobileViewState createState() =>
      LinkedFacilityMobileViewState();
}

class LinkedFacilityMobileViewState extends State<LinkedFacilityMobileView> {
  late LinkedFacilityController _linkFacilityController;
  late DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _linkFacilityController = Get.find<LinkedFacilityController>();
    _dashboardController = Get.find<DashboardController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onCheckDetails(
    String? hipName,
    List<LinkFacilityCareContext> careContextList,
    String? hipId,
  ) {
    double? dialogHeight =
        _linkFacilityController.getCareContextLength(careContextList.length);
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      isScrollControlled: true,
      height: kIsWeb
          ? context.height * 0.50
          : dialogHeight != null
              ? context.height * dialogHeight
              : null,
      mContext: context,
      title: kIsWeb ? LocalizationHandler.of().facilityDetails : '',
      width: kIsWeb ? context.width / 0.3 : null,
      child: patientDetailsWidget(
        hipName,
        careContextList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        widget.fetchLinkFacilityData();
      },
      child: GetBuilder<LinkedFacilityController>(
        builder: (_) {
          var data = _linkFacilityController.responseHandler.data;
          LinkedFacilityModel linkFacilityModel =
              data is LinkedFacilityModel ? data : LinkedFacilityModel();
          List<LinkFacilityLinkedData>? facilityLinksList =
              linkFacilityModel.patient?.links;
          return Column(
            children: [
              if (Validator.isNullOrEmpty(facilityLinksList))
                kIsWeb ? _emptyListWidget() : _emptyListWidget().flexible()
              else
                kIsWeb
                    ? listOfLinkedHip(facilityLinksList)
                    : listOfLinkedHip(facilityLinksList).expand(),
              if (kIsWeb)
                TextButtonOrange.mobile(
                  text: LocalizationHandler.of().linkNewFacility,
                  leading: ImageLocalAssets.linkedFacilityChainIconSvg,
                  onPressed: widget.onDiscoveryLinking,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyListWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.noFacilityLinkAcountImage,
      infoMessageTitle: '${LocalizationHandler.of().linkFacility}.',
      onRetryPressed: widget.fetchLinkFacilityData,
      status: _linkFacilityController.responseHandler.status ?? Status.none,
    );
  }

  /// @Here is the Widget to show the Linked facility data into the list.
  /// To show the data into the list ListView.builder Widget is used. IF not data fetch from
  /// the api, the message is shown no data available else you can find the list of data.

  Widget listOfLinkedHip(
    List<LinkFacilityLinkedData>? links,
  ) {
    return ListView.builder(
      itemCount: links?.length,
      shrinkWrap: true,
      itemBuilder: (context, position) {
        String? hipName = links?[position].hip?.name;
        String? hipId = links?[position].referenceNumber;
        return Card(
          color: AppColors.colorWhite,
          elevation: Dimen.d_4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimen.d_8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _hipNameAndAddress(
                hipName ?? '',
                hipId ?? '',
              ),
              Divider(
                height: Dimen.d_3,
                color: AppColors.colorGrey2,
              ),
              _viewDetailPullRecords(
                hipName,
                links?[position].careContexts ?? [],
                links?[position].hip?.id,
              ),
            ],
          ),
        );
      },
    ).marginOnly(bottom: Dimen.d_60);
  }

  Widget _hipNameAndAddress(String? hipName, String hipId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hipName ?? '',
          maxLines: 2,
          style: CustomTextStyle.bodyMedium(context)?.apply(
            color: AppColors.colorGreyDark2,
            fontWeightDelta: 2,
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          LocalizationHandler.of().patientId,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyLight6),
        ).marginOnly(top: Dimen.d_5),
        Text(
          hipId,
          style: CustomTextStyle.bodyMedium(context)
              ?.apply(color: AppColors.colorBlack5),
        ),
      ],
    ).marginSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_20);
  }

  Widget _viewDetailPullRecords(
    String? hipName,
    List<LinkFacilityCareContext> careContextList,
    String? hipId,
  ) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: (!kIsWeb)
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          iconTextListTile(
            onClick: () {
              _onCheckDetails(
                hipName,
                careContextList,
                hipId,
              );
            },
            title: LocalizationHandler.of().viewDetails,
          ).expand(),
          if (!kIsWeb)
            VerticalDivider(
              width: Dimen.d_3,
              color: AppColors.colorGrey2,
            ),
          if (!kIsWeb)
            iconTextListTile(
              onClick: () {
                if (abhaSingleton.getAppData.getHealthRecordFetched()) {
                  List hipIds = [];
                  Map hipIdData = {
                    ApiKeys.responseKeys.hip: {
                      ApiKeys.responseKeys.id: hipId,
                      ApiKeys.responseKeys.name: hipName,
                    }
                  };
                  hipIds.add(hipIdData);
                  _dashboardController.setLinkedFacilityPullRecord(hipIds);
                } else {
                  MessageBar.showToastError(
                    LocalizationHandler.of().pleaseWaitForRecord,
                  );
                }
              },
              svgIcon: ImageLocalAssets.pullRecordIcon,
              title: LocalizationHandler.of().pullRecords,
            ).expand()
        ],
      ),
    );
  }

  Widget iconTextListTile({
    required VoidCallback onClick,
    required String title,
    String? svgIcon,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!Validator.isNullOrEmpty(svgIcon))
            CustomSvgImageView(
              svgIcon!,
              color: AppColors.colorBlueDark1,
              width: Dimen.d_20,
              height: Dimen.d_20,
            ).marginOnly(right: Dimen.d_6)
          else
            const Icon(
              IconAssets.openEye,
              color: AppColors.colorBlueDark1,
            ).marginOnly(right: Dimen.d_6),
          Text(
            title,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorGreyDark9,
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: Dimen.d_0, vertical: Dimen.d_10),
    );
  }

  Widget noLinkProvider() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocalizationHandler.of().no_linked_records,
              style: CustomTextStyle.bodyLarge(context)?.apply(
                color: AppColors.colorAppBlue,
              ),
            ),
            Text(
              LocalizationHandler.of().let_s_start,
              style: CustomTextStyle.bodyMedium(context)?.apply(
                color: AppColors.colorAppBlue,
              ),
            ).marginOnly(top: Dimen.d_5)
          ],
        ).centerWidget,
        Image.asset(
          ImageLocalAssets.downArrow,
          height: Dimen.d_80,
          fit: BoxFit.contain,
        ).centerWidget.marginOnly(left: context.width * 0.7, top: Dimen.d_50)
      ],
    ).centerWidget;
  }

  /// @Here is the Widget patientDetailsWidget() consist of ExpansionTile() widget
  /// having [title] and [subtitle] and [trailing] and [Children] properties.
  /// subtitle contains the param [patientAbhaAddress]  String. Further Children Property
  /// consist of Column widget inside which expanded list is shown of [careContextList] of type
  /// List<CareContext.
  Widget patientDetailsWidget(
    String? hipName,
    List<LinkFacilityCareContext> careContextList,
  ) {
    return Validator.isNullOrEmpty(careContextList)
        ? const SizedBox.shrink()
        : Column(
            children: [
              Text(
                hipName ?? '',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ).marginOnly(
                top: Dimen.d_10,
                left: Dimen.d_30,
                right: Dimen.d_30,
              ),
              Flexible(
                child: _expandedWidgetOnClick(careContextList)
                    .marginOnly(left: Dimen.d_15),
              ),
            ],
          );
  }

  /// @Here is the List of Widget _expandedWidgetOnClick() contains
  /// param  [careContextList]  List<CareContext>. This widget is the expanded widget opens\
  /// on click of ExpansionTile widget.
  Widget _expandedWidgetOnClick(List<LinkFacilityCareContext> careContextList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: careContextList.length,
      itemBuilder: (context, position) {
        List<String> visitDetails =
            careContextList[position].display.toString().split(',');
        return _listTilePatientDetails(
          careContextList[position].referenceNumber ?? '',
          visitDetails,
        ).paddingAll(Dimen.d_10);
      },
    );
  }

  /// @Here is the ListTile Widget contains
  /// param [title]  String
  /// param [subTitle]  String
  Widget _listTilePatientDetails(String visitId, List<String> visitDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${LocalizationHandler.of().visitID} : ',
              style: CustomTextStyle.bodySmall(context)?.apply(
                fontSizeDelta: -2,
                fontWeightDelta: 2,
                color: AppColors.colorAppBlue,
              ),
            ),
            Text(
              visitId,
              style: CustomTextStyle.labelMedium(context)
                  ?.apply(fontSizeDelta: 2, color: AppColors.colorGreyDark2),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${LocalizationHandler.of().detailsOfVisit} : ',
              style: CustomTextStyle.bodySmall(context)?.apply(
                fontSizeDelta: -2,
                fontWeightDelta: 2,
                color: AppColors.colorAppBlue,
              ),
            ).marginOnly(top: Dimen.d_5),
            Wrap(
              runSpacing: Dimen.d_5,
              spacing: Dimen.d_5,
              children: List.generate(visitDetails.length, (index) {
                return DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    borderColor: AppColors.colorGrey3,
                  ),
                  child: Text(
                    visitDetails[index],
                    style: CustomTextStyle.labelMedium(context)?.apply(
                      color: AppColors.colorGreyDark2,
                      fontSizeDelta: 2,
                    ),
                  ).paddingAll(Dimen.d_6),
                );
              }).toList(),
            ).expand(),
          ],
        ).marginOnly(top: Dimen.d_8)
      ],
    ).paddingOnly(top: Dimen.d_10);
  }
}
