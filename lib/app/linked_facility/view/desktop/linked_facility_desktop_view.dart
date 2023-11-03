import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class LinkedFacilityDesktopView extends StatefulWidget {
  final VoidCallback fetchLinkFacilityData;
  final VoidCallback onDiscoveryLinking;

  const LinkedFacilityDesktopView({
    required this.fetchLinkFacilityData,
    required this.onDiscoveryLinking,
    super.key,
  });

  @override
  LinkedFacilityDesktopViewState createState() =>
      LinkedFacilityDesktopViewState();
}

class LinkedFacilityDesktopViewState extends State<LinkedFacilityDesktopView> {
  late LinkedFacilityController _linkFacilityController;

  @override
  void initState() {
    super.initState();
    _linkFacilityController = Get.find<LinkedFacilityController>();
  }

  void _onCheckDetails(
    String? hipName,
    LinkFacilityLinkedData? linkedData,
  ) {
    List<LinkFacilityCareContext> careContextList =
        linkedData?.careContexts ?? [];
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      isScrollControlled: true,
      height: context.height * 0.50,
      mContext: context,
      title: LocalizationHandler.of().facilityDetails,
      child: patientDetailsWidget(
        hipName,
        careContextList,
      ).marginSymmetric(
        horizontal: Dimen.d_16,
        vertical: Dimen.d_16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _linkFacilityWidget().paddingAll(Dimen.d_20),
      showBackOption: false,
    );
  }

  Widget _linkFacilityWidget() {
    return GetBuilder<LinkedFacilityController>(
      builder: (_) {
        var data = _linkFacilityController.responseHandler.data;
        LinkedFacilityModel linkFacilityModel =
            data is LinkedFacilityModel ? data : LinkedFacilityModel();
        String? patientAbhaAddress = linkFacilityModel.patient?.id;
        List<LinkFacilityLinkedData>? facilityLinksList =
            linkFacilityModel.patient?.links;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationHandler.of().linkedFacility.toTitleCase(),
                  style: CustomTextStyle.titleLarge(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
                TextButtonOrange.desktop(
                  // width: context.width * 0.12,
                  text: LocalizationHandler.of().linkNewFacility,
                  // leading: ImageLocalAssets.linkedFacilityChainIconSvg,
                  onPressed: widget.onDiscoveryLinking,
                ),
              ],
            ).marginOnly(bottom: Dimen.d_20),
            if (Validator.isNullOrEmpty(facilityLinksList))
              _emptyListWidget()
            else
              _listOfLinkedHip(facilityLinksList)
          ],
        );
      },
    );
  }

  Widget _emptyListWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.noFacilityLinkAcountImage,
      infoMessageTitle: LocalizationHandler.of().linkFacility,
      // infoMessageSubTitle: LocalizationHandler.of().let_s_start,
      onRetryPressed: widget.fetchLinkFacilityData,
      status: _linkFacilityController.responseHandler.status ?? Status.none,
    );
  }

  /// @Here is the Widget to show the Linked facility data into the list.
  /// To show the data into the list ListView.builder Widget is used. IF not data fetch from
  /// the api, the message is shown no data available else you can find the list of data.

  Widget _listOfLinkedHip(
    List<LinkFacilityLinkedData>? facilityLinks,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableHeaderView(
          children: [
            Text(
              LocalizationHandler.of().linkedFacility,
              style: CustomTextStyle.bodySmall(
                context,
              )?.apply(color: AppColors.colorWhite),
            ),
            Text(
              LocalizationHandler.of().patientId,
              style: CustomTextStyle.bodySmall(
                context,
              )?.apply(color: AppColors.colorWhite),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: facilityLinks?.length,
          itemBuilder: (context, position) {
            LinkFacilityLinkedData? linkedData = facilityLinks?[position];
            String? hipName = linkedData?.hip?.name;
            String? hipId = linkedData?.referenceNumber;
            return TableRowView(
              onClick: () {
                _onCheckDetails(hipName, linkedData);
              },
              backgroundColor: (position % 2 == 0)
                  ? AppColors.colorWhite
                  : AppColors.colorGreyVeryLight,
              children: [
                Text(
                  hipName.toString(),
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack,
                    fontWeightDelta: -1,
                  ),
                ).expand(flex: 2),
                Text(
                  hipId.toString(),
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack,
                    fontWeightDelta: -1,
                  ),
                ),
              ],
            );
          },
        ).flexible(),
      ],
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                hipName ?? '',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack,
                  fontWeightDelta: 2,
                ),
              ),
              _expandedWidgetOnClick(careContextList).flexible()
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
        List<String> visitDetails = careContextList[position].display.toString().split(',');
        return DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            size: 5,
            color: AppColors.colorTransparent,
            borderColor: AppColors.colorGrey3,
          ),
          child: _listTilePatientDetails(
            careContextList[position].referenceNumber ?? '',
            visitDetails,
          ).paddingAll(Dimen.d_10),
        ).marginOnly(top: Dimen.d_10);
      },
    ).marginOnly(top: Dimen.d_10);
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
            ).marginOnly(top: Dimen.d_6),
            Expanded(
              child: Wrap(
                runSpacing: Dimen.d_5,
                spacing: Dimen.d_5,
                children: List.generate(visitDetails.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: abhaSingleton.getBorderDecoration
                            .getRectangularBorder(
                          borderColor: AppColors.colorGrey3,
                        ),
                        child: Text(
                          visitDetails[index],
                          style: CustomTextStyle.labelMedium(context)
                              ?.apply(color: AppColors.colorGreyDark2),
                        ).paddingAll(Dimen.d_6),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ).marginOnly(top: Dimen.d_8)
      ],
    ).paddingOnly(top: Dimen.d_10);
  }
}
