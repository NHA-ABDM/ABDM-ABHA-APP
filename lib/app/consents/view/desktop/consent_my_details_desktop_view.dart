import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_artefacts_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class ConsentMyDetailsDesktopView extends StatefulWidget {
  final ConsentArtefactModel consentArtefact;

  const ConsentMyDetailsDesktopView({required this.consentArtefact, super.key});

  @override
  State<ConsentMyDetailsDesktopView> createState() =>
      _ConsentMyDetailsDesktopViewState();
}

class _ConsentMyDetailsDesktopViewState
    extends State<ConsentMyDetailsDesktopView> {
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
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_consentArtefact.status?.capitalize() ?? ''} ${LocalizationHandler.of().consentsRequestTitle.toTitleCase()}',
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(child: myConsentDetailsView()),
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget myConsentDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Row(
            children: [
              Expanded(child: requesterAndHIUNameColumn()),
              Expanded(
                child: titleValueColumn(
                  LocalizationHandler.of().purposeOfRequest,
                  _consentArtefact.consentDetail?.purpose?.text ?? '',
                ),
              ),
              Expanded(child: informationRequestWidget()),
            ],
          ),
          informationRequestTypeWidget(),
          titleValueColumn(
            LocalizationHandler.of().bookingConsentExpiry,
            '${_consentArtefact.consentDetail!.permission!.dataEraseAt!.formatDDMMMMYYYY} - '
            '${_consentArtefact.consentDetail!.permission!.dataEraseAt!.formatHHMMA}',
          ),
          ConsentArtefactsWidget(
            links: _consentController.linksFacilityData,
            consentArtefact: _consentArtefact,
          ),
        ],
        interItemSpace: Dimen.d_16,
        flowHorizontal: false,
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
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
                ),
              ).marginOnly(top: Dimen.d_8),
            ),
          ],
        ),
      ],
    );
  }

  /// @Here common widget to display text. Params used:-
  ///    [title] of type string.
  ///    [value] of type string.
  Widget titleValueColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(title),
        Text(
          value,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack,
            fontWeightDelta: -1,
          ),
        ).marginOnly(top: Dimen.d_4),
      ],
    );
  }

  /// @Here common widget to display text. Params used:-
  ///    [title] of type string.
  Widget titleView(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelLarge(context)?.apply(
        color: AppColors.colorGreyDark5,
        fontSizeDelta: -1,
        fontWeightDelta: -1,
      ),
    );
  }

  /// @Here widget shows the information i.e is dateRange (from and to date).
  Widget informationRequestWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(LocalizationHandler.of().informationRequest),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '${LocalizationHandler.of().from} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text:
                    '${_consentArtefact.consentDetail?.permission?.dateRange?.from?.formatDDMMMMYYYY}',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().to} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text:
                    '${_consentArtefact.consentDetail?.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        titleView(LocalizationHandler.of().bookingInfoRequestType),
        Wrap(
          runSpacing: Dimen.d_12,
          spacing: Dimen.d_12,
          children: _consentArtefact.consentDetail?.hiTypes?.map((e) {
                return DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    borderColor: AppColors.colorOrangeLight3,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSvgImageView(
                        'assets/images/$e.svg',
                        width: Dimen.d_25,
                        height: Dimen.d_25,
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
                  ).paddingAll(Dimen.d_12),
                );
              }).toList() ??
              [],
        ).marginOnly(top: Dimen.d_6),
      ],
    );
  }
}
