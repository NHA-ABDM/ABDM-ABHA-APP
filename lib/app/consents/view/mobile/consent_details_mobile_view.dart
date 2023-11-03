import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/export_packages.dart';

class ConsentDetailsMobileView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onGrantConsentClick;
  final Function(String id) onDenyClick;
  final ConsentRequestModel request;
  final String consentReqId;

  const ConsentDetailsMobileView({
    required this.arguments,
    required this.onGrantConsentClick,
    required this.onDenyClick,
    required this.request,
    required this.consentReqId,
    super.key,
  });

  @override
  State<ConsentDetailsMobileView> createState() =>
      _ConsentDetailsMobileViewState();
}

class _ConsentDetailsMobileViewState extends State<ConsentDetailsMobileView> {
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
    return GetBuilder<ConsentController>(
      builder: (_) {
        return _mainView();
      },
    );
  }

  Widget _mainView() {
    return _consentController.consentRequest != null
        ? SingleChildScrollView(
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
                    GestureDetector(
                      onTap: () async {
                        if (widget.request.status ==
                            ConsentStatus.requested) {
                          context
                              .navigatePush(
                            RoutePath.routeConsentEdit,
                          )
                              .whenComplete(
                                () => _consentController.update(),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: titleValueColumn(
                                  LocalizationHandler.of().requester,
                                  widget.request.requester?.name ?? '',
                                ),
                              ),
                              if (widget.request.status ==
                                  ConsentStatus.requested)
                                SvgPicture.asset(
                                  ImageLocalAssets.edit,
                                  width: Dimen.d_25,
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                          if (widget.request.hiu?.name != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.request.hiu?.name ?? '',
                                    style: CustomTextStyle.bodySmall(
                                      context,
                                    )?.apply(
                                      color: AppColors.colorGreyDark2,
                                      fontWeightDelta: 2,
                                    ),
                                  ).marginOnly(top: Dimen.d_8),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    titleValueColumn(
                      LocalizationHandler.of().purposeOfRequest,
                      widget.request.purpose?.text ?? '',
                    ),
                    informationRequestWidget(widget.request)
                        .marginOnly(top: Dimen.d_10),
                    informationRequestTypeWidget(widget.request)
                        .marginOnly(top: Dimen.d_10),
                    titleValueColumn(
                        LocalizationHandler.of().bookingConsentExpiry,
                        '${widget.request.permission!.dataEraseAt!.formatDDMMMMYYYY}'
                            '\t\t\t\t\t\t\t\t'
                            '${widget.request.permission!.dataEraseAt!.formatHHMMA}'),
                    if (widget.request.status == ConsentStatus.requested)
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    if (widget.request.status ==
                        ConsentStatus.requested &&
                        widget.request.careContexts.isNotEmpty)
                      InfoNote(
                        note: LocalizationHandler.of().grantConsentNote(
                          '${widget.request.hiu?.name}',
                        ),
                      ).marginOnly(top: Dimen.d_10),
                  ],
                  interItemSpace: Dimen.d_18,
                  flowHorizontal: false,
                ),
              ).paddingOnly(
                top: Dimen.d_10,
                bottom: Dimen.d_20,
                left: Dimen.d_20,
                right: Dimen.d_20,
              ),
            ),
            if (widget.request.status == ConsentStatus.requested)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: WidgetUtility.spreadWidgets(
                  [
                    Expanded(child: denyButton(widget.request)),
                    Expanded(child: grantButton()),
                  ],
                  interItemSpace: Dimen.d_10,
                ),
              ).marginOnly(top: Dimen.d_15)
            else
              const SizedBox.shrink()
          ],
          flowHorizontal: false,
        ),
      ).paddingSymmetric(
        horizontal: Dimen.d_10,
        vertical: Dimen.d_10,
      ),
    )
        : const SizedBox.shrink();
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
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_4),
      ],
    ).marginOnly(top: Dimen.d_10);
  }

  /// @Here common widget to display text. Params used:-
  ///    [title] of type string.
  Widget titleView(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelMedium(context)
          ?.apply(color: AppColors.colorGreyLight6, fontSizeDelta: 2),
    );
  }

  /// @Here is the widget to display the information related to [from] date
  /// and [to] date. Params used :-
  ///    [request] of type Requests.
  Widget informationRequestWidget(ConsentRequestModel request) {
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
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text:
                '${request.permission?.dateRange?.from?.formatDDMMMMYYYY}',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorGreyDark2),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().to} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text: '${request.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorGreyDark2),
              ),
            ],
          ),
        ).marginOnly(top: Dimen.d_4),
      ],
    );
  }

  /// @Here is the widget to display the information related to HiTypes. Params used :-
  ///    [request] of type Requests.
  Widget informationRequestTypeWidget(ConsentRequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().bookingInfoRequestType,
        ),
        Column(
          children: request.hiTypes?.map((e) {
            return Row(
              children: [
                SvgPicture.asset(
                  e.check
                      ? 'assets/images/${e.name}.svg'
                      : 'assets/images/${e.name}_disabled.svg',
                  width: Dimen.d_25,
                ).marginOnly(right: Dimen.d_10),
                Text(
                  Validator.isNullOrEmpty(e.name)
                      ? ''
                      : e.name!.convertPascalCaseString,
                  style: CustomTextStyle.bodyLarge(context)?.copyWith(
                    fontSize: Dimen.d_16,
                    color: e.check
                        ? AppColors.colorBlack
                        : AppColors.colorGrey,
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

  /// @Here function used to grant the consent on button click.
  Widget grantButton() {
    return TextButtonOrange.mobile(
      text: LocalizationHandler.of().grant_consent,
      onPressed: widget.onGrantConsentClick,
    );
  }

  /// @Here is widget to deny consent on click of button. Params used:-
  ///    [consents] of type Requests.
  Widget denyButton(ConsentRequestModel consents) {
    return TextButtonPurple(
      text: LocalizationHandler.of().deny,
      onPressed: () {
        /// call function by passing consents id.
        widget.onDenyClick(widget.consentReqId);
      },
      // width: context.width * 0.4,
    );
  }
}
