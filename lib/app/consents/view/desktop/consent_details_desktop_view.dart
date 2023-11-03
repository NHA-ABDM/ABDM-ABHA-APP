import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class ConsentDetailsDesktopView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onGrantConsentClick;
  final Function(String id) onDenyClick;
  final ConsentRequestModel request;

  const ConsentDetailsDesktopView({
    required this.arguments,
    required this.onGrantConsentClick,
    required this.onDenyClick,
    required this.request,
    super.key,
  });

  @override
  State<ConsentDetailsDesktopView> createState() =>
      _ConsentDetailsDesktopViewState();
}

class _ConsentDetailsDesktopViewState extends State<ConsentDetailsDesktopView> {
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
    _consentController.tempResponseData = null;

    /// TEST: comment below line for test case
    _consentController.consentRequest = null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_consentController.getLocalizedRequestType(_consentController.consentRequest?.status?.toUpperCase() ?? '')} ${LocalizationHandler.of().consentsRequestTitle.toTitleCase()}',
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          GetBuilder<ConsentController>(
            builder: (_) {
              return _mainView();
            },
          ),
        ],
      ).marginSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
    );
  }

  Widget _mainView() {
    return _consentController.consentRequest != null
        ? CommonBackgroundCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: WidgetUtility.spreadWidgets(
                [
                  Row(
                    children: [
                      Expanded(
                        child: titleValueColumn(
                          LocalizationHandler.of().requester,
                          widget.request.requester?.name ?? '',
                        ),
                      ),
                      Expanded(
                        child: titleValueColumn(
                          LocalizationHandler.of().purposeOfRequest,
                          widget.request.purpose?.text ?? '',
                        ),
                      ),
                      Expanded(child: informationRequestWidget(widget.request)),
                      // if (_consentController.linksFacilityData.isNotEmpty)
                        InkWell(
                          onTap: () {
                            if (widget.request.status ==
                                ConsentStatus.requested) {
                              context
                                  .navigatePush(RoutePath.routeConsentEdit)
                                  .whenComplete(() {
                                _consentController.update();
                              });
                            }
                          },
                          child:
                              (widget.request.status == ConsentStatus.requested)
                                  ? CustomSvgImageView(
                                      ImageLocalAssets.edit,
                                      width: Dimen.d_25,
                                    )
                                  : const SizedBox.shrink(),
                        )
                    ],
                  ),
                  informationRequestTypeWidget(widget.request),
                  titleValueColumn(
                      LocalizationHandler.of().bookingConsentExpiry,
                      '${widget.request.permission!.dataEraseAt!.formatDDMMMMYYYY} - '
                      '${widget.request.permission!.dataEraseAt!.formatHHMMA}'),
                  if (widget.request.status == ConsentStatus.requested)
                    Divider(
                      height: Dimen.d_1,
                      color: AppColors.colorPurple4,
                    ),
                  if (widget.request.status == ConsentStatus.requested &&
                      widget.request.careContexts.isNotEmpty)
                    InfoNote(
                      note: LocalizationHandler.of().grantConsentNote(
                        '${widget.request.hiu?.name}',
                      ),
                    ),
                  // if (widget.request.status == ConsentStatus.requested &&
                  //     _consentController.linksFacilityData.isEmpty)
                  //   InfoNote(
                  //     note: LocalizationHandler.of().noHipsLinkedError,
                  //   ).marginOnly(top: Dimen.d_10),
                  if (widget.request.status == ConsentStatus.requested)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: WidgetUtility.spreadWidgets(
                        [
                          Flexible(child: grantButton()),
                          Flexible(child: denyButton(widget.request)),
                        ],
                        interItemSpace: Dimen.d_10,
                      ),
                    )
                ],
                interItemSpace: Dimen.d_16,
                flowHorizontal: false,
              ),
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
        // fontSizeDelta: 1,
      ),
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
                  color: AppColors.colorBlack,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text:
                    '${request.permission?.dateRange?.from?.formatDDMMMMYYYY}',
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
                text: '${request.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
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

  /// @Here is the widget to display the information related to HiTypes. Params used :-
  ///    [request] of type Requests.
  Widget informationRequestTypeWidget(ConsentRequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().bookingInfoRequestType,
        ),
        Wrap(
          runSpacing: Dimen.d_12,
          spacing: Dimen.d_12,
          children: request.hiTypes?.map((e) {
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
                        e.check
                            ? 'assets/images/${e.name}.svg'
                            : 'assets/images/${e.name}_disabled.svg',
                        height: Dimen.d_24,
                        width: Dimen.d_24,
                      ).marginOnly(right: Dimen.d_6),
                      Text(
                        Validator.isNullOrEmpty(e.name)
                            ? ''
                            : e.name!.convertPascalCaseString,
                        style: CustomTextStyle.bodyLarge(
                          context,
                        )?.copyWith(
                          fontSize: Dimen.d_16,
                          color: e.check
                              ? AppColors.colorBlack
                              : AppColors.colorGrey,
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

  /// @Here function used to grant the consent on button click.
  Widget grantButton() {
    return TextButtonOrange.desktop(
      text: LocalizationHandler.of().grant_consent,
      // isButtonEnable: _consentController.linksFacilityData.isNotEmpty,
      onPressed: widget.onGrantConsentClick,
    );
  }

  /// @Here is widget to deny consent on click of button. Params used:-
  ///    [consents] of type Requests.
  Widget denyButton(ConsentRequestModel consents) {
    return TextButtonPurple.desktop(
      text: LocalizationHandler.of().deny,
      onPressed: () {
        /// call function by passing consents id.
        widget.onDenyClick(consents.id ?? '');
      },
    );
  }
}
