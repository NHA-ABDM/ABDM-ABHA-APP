import 'package:abha/app/link_unlink/view/widget/common_link_unlink_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class LinkAbhaNumberDesktopView extends StatefulWidget {
  final VoidCallback onAbhaNumberAuthInit;
  final void Function(LinkUnlinkMethod value) onClickRadioButton;
  final LinkUnlinkController linkUnlinkController;
  final ValueNotifier<bool> isButtonEnable;

  const LinkAbhaNumberDesktopView({
    required this.onAbhaNumberAuthInit,
    required this.onClickRadioButton,
    required this.linkUnlinkController,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LinkAbhaNumberDesktopViewState createState() =>
      LinkAbhaNumberDesktopViewState();
}

class LinkAbhaNumberDesktopViewState extends State<LinkAbhaNumberDesktopView> {
  late LinkUnlinkController _linkUnlinkController;
  @override
  void initState() {
    _linkUnlinkController = widget.linkUnlinkController;
    _linkUnlinkController.actionType = StringConstants.link;
    _linkUnlinkController.update([LinkUnlinkUpdateUiBuilderIds.radioToggle]);
    super.initState();
  }

  @override
  void dispose() {
    _linkUnlinkController.abhaNumberTEC.clear();
    super.dispose();
  }

  void _checkAndEnableButton() {
    String? value = _linkUnlinkController.abhaNumberTEC.text.trim();
    value = value.replaceAll('-', '');
    if (value.length == 14 &&
        !Validator.isNullOrEmpty(_linkUnlinkController.selectedRadioButton)) {
      widget.isButtonEnable.value = true;
    } else {
      widget.isButtonEnable.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _linkAbhaNoParentWidget(),
    );
    //   DesktopCommonScreenWidget(
    //   image: ImageLocalAssets.abhaLogo,
    //   title: LocalizationHandler.of().linkAbhaNumber,
    //   child: _loginAbhaNumberWidget(),
    // );
  }

  Widget _linkAbhaNoParentWidget() {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().linkAbhaNumber,
          style: CustomTextStyle.titleLarge(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 2,
          ),
        ).alignAtTopLeft().marginOnly(bottom: Dimen.d_20),
        CommonBackgroundCard(
          child: CommonLinkUnlinkWidget(
            image: ImageLocalAssets.linkAbhaNumberSvg,
            child: _loginAbhaNumberWidget(),
          ),
        )
      ],
    ).marginAll(
      Dimen.d_20,
    );
  }

  Widget _loginAbhaNumberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            Text(
              LocalizationHandler.of().linkAbhaNumberMsg,
              style: CustomTextStyle.bodyMedium(context)
                  ?.apply(color: AppColors.colorBlack6, fontWeightDelta: 2),
            ).marginOnly(right: Dimen.d_5),
            Text(
              '"${abhaSingleton.getAppData.getAbhaAddress()}"',
              style: CustomTextStyle.bodyMedium(context)?.apply(),
            ).marginOnly(right: Dimen.d_5),
          ],
        ),
        AppTextFormField.desktop(
          key: const Key(KeyConstant.abhaNumberTextField),
          title: LocalizationHandler.of().abhaNumber,
          hintText: LocalizationHandler.of().hintEnterAbhaNumber,
          textEditingController: _linkUnlinkController.abhaNumberTEC,
          textInputType: TextInputType.number,
          context: context,
          onChanged: (value) {
            _checkAndEnableButton();
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (Validator.isNullOrEmpty(value)) {
              return LocalizationHandler.of().errorEnterAbhaNumber;
            }
            if (!Validator.isAbhaNumberWithDashValid(value!)) {
              return LocalizationHandler.of().invalidAbhaNumber;
            }
            return null;
          },
        ).marginOnly(top: Dimen.d_20),
        GetBuilder<LinkUnlinkController>(
          id: LinkUnlinkUpdateUiBuilderIds.radioToggle,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHandler.of().validateUsing,
                  style: CustomTextStyle.titleMedium(context)?.apply(
                    fontSizeDelta: -1,
                    fontWeightDelta: 1,
                    color: AppColors.colorAppBlue,
                  ),
                ).marginOnly(top: Dimen.d_30),
                rowAbhaNumberOrAdhaarOtpIcon(),
              ],
            );
          },
        ),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  key: const Key(KeyConstant.continueBtn),
                  text: LocalizationHandler.of().continuee,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    widget.onAbhaNumberAuthInit();
                  },
                ).centerWidget;
              },
            ),
            TextButtonPurple.desktop(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(
              left: Dimen.d_20,
              right: Dimen.d_20,
            )
          ],
        ).marginOnly(top: Dimen.d_30),
      ],
    );
  }

  Widget rowAbhaNumberOrAdhaarOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ValidateAuthOptionView(
            onClick: () {
              // setState(() {
              _linkUnlinkController.selectedRadioButton =
                  LinkUnlinkMethod.verifyAadhaar;
              widget.onClickRadioButton(
                _linkUnlinkController.selectedRadioButton!,
              );
              _checkAndEnableButton();
              // });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _linkUnlinkController.selectedRadioButton ==
                LinkUnlinkMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
          ),
        ),
        SizedBox(
          width: Dimen.d_10,
        ),
        Flexible(
          child: ValidateAuthOptionView(
            onClick: () {
              // setState(() {
              _linkUnlinkController.selectedRadioButton =
                  LinkUnlinkMethod.verifyMobile;
              widget.onClickRadioButton(
                _linkUnlinkController.selectedRadioButton!,
              );
              _checkAndEnableButton();
              // });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _linkUnlinkController.selectedRadioButton ==
                LinkUnlinkMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginAbhaAddressIconSvg,
          ).marginOnly(left: Dimen.d_3, right: Dimen.d_3),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }
}
