import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/webview/webview_abs.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AbhaCardDesktopView extends StatefulWidget {
  final ProfileModel? profileModel;

  const AbhaCardDesktopView({super.key, this.profileModel});

  @override
  AbhaCardDesktopViewState createState() => AbhaCardDesktopViewState();
}

class AbhaCardDesktopViewState extends State<AbhaCardDesktopView>
    implements WebViewAbs {
  late AbhaCardController _abhaCardController;
  InAppWebViewController? inAppWebViewController;

  late ProfileController _profileController;
  DateTime _dtObj = DateTime(0, 0, 0);

  @override
  void initState() {
    super.initState();
    _abhaCardController = Get.put(AbhaCardController(AbhaCardRepoImpl()));
    _profileController = Get.find<ProfileController>();
    _dtObj = _profileController.getDateTime();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onFetchAbhaCard();
    });
  }

  @override
  void dispose() {
    DeleteControllers().deleteAbhaCard();
    super.dispose();
  }

  /// fetch ABHA card by calling [callAbhaCard] metod in controller
  Future<void> _onFetchAbhaCard() async {
    await _abhaCardController.functionHandler(
      function: () => _abhaCardController.getAbhaCard(),
      isLoaderReq: true,
      isUpdateUi: true,
    );
  }

  void _onTapOfLinkUnlinkButton() {
    // Unlink Abha Number
    if (_abhaCardController.getKycDetail(widget.profileModel)) {
      int? abhaLinkedCount = int.tryParse(
        widget.profileModel!.abhaLinkedCount!,
      );
      if (widget.profileModel != null &&
          abhaLinkedCount != null &&
          abhaLinkedCount > 1) {
        context.navigatePush(
          RoutePath.routeUnlinkAbhaNumber,
        );
      } else {
        MessageBar.showToastDialog(
          LocalizationHandler.of().onlyOneAbhaAddressLinked,
        );
      }
    } else {
      // Link Abha Number
      context.navigatePush(
        RoutePath.routeLinkAbhaNumber,
      );
    }
  }

  @override
  void onWebViewCreated(inAppWebViewController) {
    this.inAppWebViewController = inAppWebViewController;
  }

  @override
  Widget build(BuildContext context) {
    return _abhaCardWidgetForWeb();
  }

  Widget _abhaCardWidgetForWeb() {
    return GetBuilder<AbhaCardController>(
      builder: (_) {
        var data = _abhaCardController.responseHandler.data ?? '';
        return (Validator.isNullOrEmpty(data))
            ? const SizedBox.shrink()
            : CommonBackgroundCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _customAbhaCardWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButtonOrange.desktop(
                          text: LocalizationHandler.of().downloadABHACard,
                          onPressed: () async {
                            await _abhaCardController.downloadFile(
                              inAppWebViewController,
                            );
                          },
                        ).marginOnly(
                          top: Dimen.d_15,
                          bottom: Dimen.d_10,
                          left: Dimen.d_15,
                          right: Dimen.d_15,
                        ),
                        if (_abhaCardController
                            .getKycDetail(widget.profileModel))
                          TextButtonOrangeBorder.desktop(
                            text: LocalizationHandler.of().unlinkAbhaNumber,
                            onPressed: () async {
                              _onTapOfLinkUnlinkButton();
                            },
                          ).marginOnly(
                            top: Dimen.d_15,
                            bottom: Dimen.d_10,
                            left: Dimen.d_15,
                            right: Dimen.d_15,
                          )
                        else
                          TextButtonOrange.desktop(
                            text: LocalizationHandler.of().labelLinkAbhaNumber,
                            onPressed: () async {
                              _onTapOfLinkUnlinkButton();
                            },
                          ).marginOnly(
                            top: Dimen.d_15,
                            bottom: Dimen.d_10,
                            left: Dimen.d_15,
                            right: Dimen.d_15,
                          ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _customAbhaCardWidget() {
    return Container(
      constraints: BoxConstraints(
        // minHeight: Dimen.d_400,
        // maxHeight: Dimen.d_600,
        minWidth: Dimen.d_600,
        maxWidth: Dimen.d_700,
      ),
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        borderColor: AppColors.colorBlack,
        size: Dimen.d_0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: AppColors.colorAppBlue1,
            child: _abhaCardHeaderWidget(),
          ),
          _abhaCardUserDetailsWidget(),
        ],
      ),
    );
  }

  Widget _abhaCardHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: WidgetUtility.spreadWidgets(
        [
          SvgPicture.asset(
            ImageLocalAssets.nhaLogo,
            fit: BoxFit.cover,
            // height: Dimen.d_55,
            colorFilter: const ColorFilter.mode(
              AppColors.colorWhite,
              BlendMode.srcIn,
            ),
          ),
          Column(
            children: [
              Text(
                LocalizationHandler.of().abhaCardTitle1,
                style: CustomTextStyle.bodyLarge(context)
                    ?.apply(fontWeightDelta: 0, color: AppColors.colorWhite),
              ),
              Text(
                LocalizationHandler.of().abhaCardTitle2,
                style: CustomTextStyle.bodyLarge(context)
                    ?.apply(fontWeightDelta: 0, color: AppColors.colorWhite),
              ).marginOnly(top: Dimen.d_12)
            ],
          ).marginSymmetric(horizontal: Dimen.d_20),
          SvgPicture.asset(
            ImageLocalAssets.abdmProfileCardLogo,
            // height: Dimen.d_55,
            fit: BoxFit.cover,
          ),
        ],
        interItemSpace: Dimen.d_10,
      ),
    ).paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20);
  }

  Widget _abhaCardUserDetailsWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!Validator.isNullOrEmpty(widget.profileModel?.profilePhoto))
          Image.memory(
            const Base64Decoder()
                .convert(widget.profileModel?.profilePhoto ?? ''),
            width: Dimen.d_100,
            height: Dimen.d_120,
            gaplessPlayback: true,
            fit: BoxFit.fitHeight,
          ).marginOnly(left: Dimen.d_20, top: Dimen.d_20)
        else
          Image.asset(
            ImageLocalAssets.userDefaultProfileImage,
            width: Dimen.d_100,
            height: Dimen.d_120,
            fit: BoxFit.fitHeight,
          ).marginOnly(left: Dimen.d_20, top: Dimen.d_20),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: WidgetUtility.spreadWidgets(
              [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: WidgetUtility.spreadWidgets(
                          [
                            _titleValueCommonWidget(
                              LocalizationHandler.of().abhaCardName,
                              widget.profileModel?.fullName ?? '',
                            ),
                            _titleValueCommonWidget(
                              LocalizationHandler.of().abhaCardAbhaNumber,
                              widget.profileModel?.abhaNumber ?? '-',
                            ),
                            _titleValueCommonWidget(
                              LocalizationHandler.of().abhaCardAbhaAddress,
                              widget.profileModel?.abhaAddress ?? '',
                            ),
                          ],
                          interItemSpace: Dimen.d_20,
                          flowHorizontal: false,
                        ),
                      ).marginSymmetric(
                        horizontal: Dimen.d_20,
                        vertical: Dimen.d_20,
                      ),
                    ),
                    _qrCode()
                  ],
                ),
                _userGenderDOBMobileWidget().marginOnly(
                  left: Dimen.d_20,
                  bottom: Dimen.d_20,
                  right: Dimen.d_20,
                )
              ],
              interItemSpace: Dimen.d_0,
              flowHorizontal: false,
            ),
          ),
        )
      ],
    );
  }

  Widget _userGenderDOBMobileWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: WidgetUtility.spreadWidgets(
        [
          _titleValueCommonWidget(
            LocalizationHandler.of().abhaCardGender,
            Validator.getGender(widget.profileModel?.gender),
          ),
          _titleValueCommonWidget(
            LocalizationHandler.of().abhaCardDateOfBirth,
            _dtObj.formatDDMMYYYY,
          ),
          _titleValueCommonWidget(
            LocalizationHandler.of().abhaCardMobile,
            widget.profileModel?.mobile ?? '',
          ),
        ],
        interItemSpace: Dimen.d_20,
      ),
    );
  }

  Widget _qrCode() {
    return _profileController.tempQrCodeFile.isNotEmpty
        ? SizedBox(
            width: Dimen.d_150,
            height: Dimen.d_150,
            child: Image.memory(
              Uint8List.fromList(_profileController.tempQrCodeFile),
              fit: BoxFit.cover,
            ),
          ).marginOnly(right: Dimen.d_20, top: Dimen.d_20)
        : Container();
  }

  Widget _titleValueCommonWidget(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomTextStyle.bodyMedium(context)
              ?.apply(color: AppColors.colorBlack90, fontSizeDelta: 1),
        ),
        Text(
          value,
          style: CustomTextStyle.bodyLarge(context)?.apply(
            fontSizeDelta: 2,
            color: AppColors.colorBlack95,
            fontWeightDelta: 1,
          ),
        ).marginOnly(
          top: Dimen.d_5,
        ),
      ],
    );
  }
}
