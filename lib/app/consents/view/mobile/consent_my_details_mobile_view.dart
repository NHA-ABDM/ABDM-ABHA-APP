import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_artefacts_widget.dart';
import 'package:abha/export_packages.dart';

class ConsentMyDetailsMobileView extends StatefulWidget {
  final ConsentArtefactModel consentArtefact;

  const ConsentMyDetailsMobileView({required this.consentArtefact, super.key});

  @override
  State<ConsentMyDetailsMobileView> createState() =>
      _ConsentMyDetailsMobileViewState();
}

class _ConsentMyDetailsMobileViewState
    extends State<ConsentMyDetailsMobileView> {
  late ConsentController _consentController;
  late ConsentArtefactModel _consentArtefact;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    _consentArtefact = widget.consentArtefact;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return myConsentDetailsView();
  }

  Widget myConsentDetailsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: WidgetUtility.spreadWidgets(
          [
            DecoratedBox(
              decoration: abhaSingleton.getBorderDecoration.getElevation(
                borderColor: AppColors.colorGrey4,
                color: AppColors.colorWhite,
                isLow: true,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: WidgetUtility.spreadWidgets(
                  [
                    requesterAndHIUNameColumn(),
                    titleValueColumn(
                      LocalizationHandler.of().purposeOfRequest,
                      _consentArtefact.consentDetail?.purpose?.text ?? '',
                    ),
                    informationRequestWidget().marginOnly(top: Dimen.d_10),
                    informationRequestTypeWidget().marginOnly(top: Dimen.d_10),
                    titleValueColumn(
                        LocalizationHandler.of().bookingConsentExpiry,
                        '${_consentArtefact.consentDetail!.permission!.dataEraseAt!.formatDDMMMMYYYY}\t\t\t\t\t\t\t\t'
                        '${_consentArtefact.consentDetail!.permission!.dataEraseAt!.formatHHMMA}'),
                    ConsentArtefactsWidget(
                      links: _consentController.linksFacilityData,
                      consentArtefact: _consentArtefact,
                    ).marginOnly(top: Dimen.d_10)
                  ],
                  interItemSpace: Dimen.d_18,
                  flowHorizontal: false,
                ),
              ).paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
            ),
          ],
          interItemSpace: Dimen.d_18,
          flowHorizontal: false,
        ),
      ).paddingOnly(
        bottom: Dimen.d_30,
      ),
    );
  }

  Widget requesterAndHIUNameColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: titleView(
                _consentArtefact.consentDetail?.requester?.name ?? '',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                _consentArtefact.consentDetail?.hiu?.name ?? '',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ).marginOnly(top: Dimen.d_8),
            ),
          ],
        ),
      ],
    );
  }

  /// @Here common widget to display the title and value as a text in a Column.
  /// Params used [title] of type String.
  /// Params used [value] of type String.
  Widget titleValueColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(title),
        Text(
          value,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_4),
      ],
    ).marginOnly(top: Dimen.d_10);
  }

  /// @Here common widget to display the text.
  /// Params used [title] of type String.
  Widget titleView(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelMedium(context)
          ?.apply(color: AppColors.colorGreyLight6, fontSizeDelta: 2),
    );
  }

  /// @Here widget shows the information i.e is dateRange (from and to date).
  Widget informationRequestWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().informationRequest,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '${LocalizationHandler.of().from} ',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text:
                    '${_consentArtefact.consentDetail?.permission?.dateRange?.from?.formatDDMMMMYYYY}',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().to} ',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text:
                    '${_consentArtefact.consentDetail?.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
            ],
          ),
        ).marginOnly(top: Dimen.d_4),
      ],
    );
  }

  Widget informationRequestTypeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().bookingInfoRequestType,
        ),
        Column(
          children: _consentArtefact.consentDetail?.hiTypes?.map((e) {
                return Row(
                  children: [
                    CustomSvgImageView(
                      'assets/images/$e.svg',
                      width: Dimen.d_25,
                    ).marginOnly(right: Dimen.d_10, left: Dimen.d_10),
                    Text(
                      Validator.isNullOrEmpty(e)
                          ? ''
                          : e.convertPascalCaseString,
                      style: CustomTextStyle.bodyLarge(
                        context,
                      )?.copyWith(
                        fontSize: Dimen.d_16,
                        color: AppColors.colorBlack,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ).marginOnly(top: Dimen.d_25);
              }).toList() ??
              [],
        ),
      ],
    );
  }
}
