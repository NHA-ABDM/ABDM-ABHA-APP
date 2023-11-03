import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/export_packages.dart';

class ConsentMyMobileView extends StatefulWidget {
  final Map arguments;
  final Function(ConsentArtefactModel model) onClickViewDetails;
  final Function(String? consentId) onRevokeClick;

  const ConsentMyMobileView({
    required this.arguments,
    required this.onClickViewDetails,
    required this.onRevokeClick,
    super.key,
  });

  @override
  State<ConsentMyMobileView> createState() => _ConsentMyMobileViewState();
}

class _ConsentMyMobileViewState extends State<ConsentMyMobileView> {
  late ConsentController _consentController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
  }

  @override
  Widget build(BuildContext context) {
    return myConsentsView();
  }

  Widget myConsentsView() {
    return GetBuilder<ConsentController>(
      builder: (_) {
        var data = _consentController.consentArtefact;
        List<ConsentArtefactModel> consentArtefactData =
            data is List<ConsentArtefactModel> ? data : [];
        return (Validator.isNullOrEmpty(consentArtefactData))
            ? const SizedBox.shrink()
            : notificationListWidget(consentArtefactData);
      },
    );
  }

  Widget notificationListWidget(List<ConsentArtefactModel>? consentArtefacts) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: consentArtefacts?.length,
      itemBuilder: (context, position) {
        ConsentArtefactModel tempNotification =
            consentArtefacts?[position] ?? ConsentArtefactModel();

        tempNotification.consentDetail?.hiu?.name =
            _consentController.consentRequest?.hiu?.name;
        tempNotification.consentDetail?.hip?.name =
            _consentController.consentRequest?.hip?.name;
        return _cardItemViewWidget(tempNotification);
      },
    );
  }

  Widget _cardItemViewWidget(ConsentArtefactModel consentArtefact) {
    return Card(
      color: AppColors.colorWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimen.d_15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitleWidget(consentArtefact),
          _getPurposeWidget(consentArtefact),
          _getHipTypeWidget(consentArtefact),
          _getLastUpdatedWidget(consentArtefact),
          if (consentArtefact.status == ConsentStatus.revoked)
            informationRequestWidget(consentArtefact)
          else
            const SizedBox.shrink(),
          Container(
            height: 2,
            width: double.infinity,
            color: AppColors.colorGrey2,
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimen.d_15),
                bottomRight: Radius.circular(Dimen.d_15),
              ),
            ),
            onTap: () {
              widget.onClickViewDetails(consentArtefact);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconAssets.openEye,
                  color: AppColors.colorBlueDark1,
                ).marginOnly(right: Dimen.d_10),
                Text(
                  LocalizationHandler.of().viewDetails,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_10),
          )
        ],
      ),
    );
  }

  /// @Here widget shows title .
  /// Params used [consentArtefact] of type ConsentArtefact.
  Widget _getTitleWidget(ConsentArtefactModel consentArtefact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleView(
              consentArtefact.consentDetail?.requester?.name ?? '',
            ).marginOnly(top: Dimen.d_10),
            Text(
              consentArtefact.consentDetail?.hiu?.name ?? '',
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
            ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_10),
          ],
        ),
        if (consentArtefact.status == ConsentStatus.granted)
          InkWell(
            onTap: () {
              widget.onRevokeClick(consentArtefact.consentDetail?.consentId);
            },
            // child:
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  ImageLocalAssets.revokeOneIconSvg,
                  width: Dimen.d_16,
                  height: Dimen.d_16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.colorRed,
                    BlendMode.srcIn,
                  ),
                ).marginOnly(right: Dimen.d_5),
                Text(
                  LocalizationHandler.of().revokeConsent,
                  style: CustomTextStyle.bodySmall(context)
                      ?.apply(color: AppColors.colorRed),
                ).marginOnly(left: Dimen.d_5, right: Dimen.d_5)
              ],
            ),
          ).marginOnly(top: Dimen.d_5)
        else
          const SizedBox.shrink(),
      ],
    ).marginOnly(
      top: Dimen.d_5,
      left: Dimen.d_20,
      right: Dimen.d_20,
    );
  }

  Widget _getHipTypeWidget(ConsentArtefactModel consentArtefact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().hipType,
        ),
        Text(
          consentArtefact.consentDetail?.hip?.name ?? '',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_5),
      ],
    ).marginOnly(
      top: Dimen.d_10,
      left: Dimen.d_20,
      right: Dimen.d_20,
      bottom: Dimen.d_10,
    );
  }

  /// @Here widget shows the purpose of Consent artefacts.
  /// Params used [consentArtefact] of type ConsentArtefact.
  Widget _getPurposeWidget(ConsentArtefactModel consentArtefact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().purposeOfRequest,
        ),
        Text(
          consentArtefact.consentDetail?.purpose?.text ?? '',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_5),
      ],
    ).marginOnly(
      top: Dimen.d_10,
      left: Dimen.d_20,
      right: Dimen.d_20,
      bottom: Dimen.d_10,
    );
  }

  /// @Here widget shows the last updated of Consent artefacts.
  /// Params used [consentArtefact] of type ConsentArtefact.
  Widget _getLastUpdatedWidget(ConsentArtefactModel consentArtefact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().last_updated,
        ),
        Text(
          consentArtefact.consentDetail?.lastUpdated
                  ?.calculatePastTime(utc: false) ??
              '',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_5),
      ],
    ).marginOnly(
      top: Dimen.d_10,
      left: Dimen.d_20,
      right: Dimen.d_20,
      bottom: Dimen.d_10,
    );
  }

  /// @Here widget shows the information i.e is dateRange (from and to date).
  /// Params used [consentArtefact] of type ConsentArtefact.
  Widget informationRequestWidget(ConsentArtefactModel consentArtefact) {
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
                  color: AppColors.colorGreyDark2, fontWeightDelta: 2,
                  // fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text:
                    '${consentArtefact.consentDetail?.permission?.dateRange?.from?.formatDDMMMMYYYY}',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontSizeDelta: -3,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().to} ',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
              ),
              TextSpan(
                text:
                    '${consentArtefact.consentDetail?.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
                style: CustomTextStyle.bodySmall(
                  context,
                )?.apply(
                  color: AppColors.colorGreyDark2,
                  fontSizeDelta: -3,
                  fontWeightDelta: 2,
                ),
              ),
            ],
          ),
        ).marginOnly(top: Dimen.d_4),
      ],
    ).marginOnly(top: Dimen.d_15, left: Dimen.d_20, right: Dimen.d_20);
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

  /// @Here function used to show pop up for revoking the artefacts.
  /// Params used [context] of type BuildContext and [requestID]
  /// of type String.
  void alertDialog(BuildContext context, String? requestID) {
    CustomDialog.showPopupDialog(
      LocalizationHandler.of().deletingConsent,
      title: LocalizationHandler.of().doYouWantToDeleteIt,
      positiveButtonTitle: LocalizationHandler.of().yes,
      negativeButtonTitle: LocalizationHandler.of().no,
      onPositiveButtonPressed: () async {
        context.navigateBack();
        _consentController.functionHandler(
          function: () {
            _consentController.revokeConsent(requestID!).then((value) {
              if (_consentController.responseHandler.status == Status.success) {
                context.navigateBack(result: true);
              }
            });
          },
          isLoaderReq: true,
          isShowError: true,
        );
      },
      onNegativeButtonPressed: CustomDialog.dismissDialog,
    );
  }
}
