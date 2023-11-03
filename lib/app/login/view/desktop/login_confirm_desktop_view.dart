import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';

class LoginConfirmDesktopView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onMobileEmailLoginConfirm;
  final ValueNotifier<bool> isButtonEnable;

  const LoginConfirmDesktopView({
    required this.arguments,
    required this.onMobileEmailLoginConfirm,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginConfirmDesktopViewState createState() => LoginConfirmDesktopViewState();
}

class LoginConfirmDesktopViewState extends State<LoginConfirmDesktopView> {
  late LoginController _loginController;
  late List<ProfileModel> _mappedPhrAddress;
  ValueNotifier<bool> isButtonEnable = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    _mappedPhrAddress = widget.arguments[IntentConstant.mappedPhrAddress];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkOnAbhaClick(value) {
    setState(() {
      _loginController.abhaAddressSelectedValue = value as String;
      isButtonEnable.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().loginSelectAbhaAddress,
      child: _loginConfirmWidget(),
    );
  }

  Widget _loginConfirmWidget() {
    return Column(
      children: [
        _listOfAbhaAddress().sizedBox(height: context.height * 0.5),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  text: LocalizationHandler.of().continuee,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    if (isButtonEnable) {
                      _loginController.loginMethod =
                          LoginMethod.abhaAddressSelection;
                      widget.onMobileEmailLoginConfirm();
                    }
                  },
                ).marginOnly(right: Dimen.d_16);
              },
            ),
            TextButtonPurple.desktop(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(right: Dimen.d_16),
          ],
        )
      ],
    );
  }

  /// @Here list displays the suggested phr mapped addresses.
  Widget _listOfAbhaAddress() {
    return Scrollbar(
      thickness: Dimen.d_6,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      controller: scrollController,
      radius: const Radius.circular(15),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        controller: scrollController,
        itemCount: _mappedPhrAddress.length,
        itemBuilder: (context, position) {
          /// mapped phr address list item
          var item = _mappedPhrAddress[position];
          if (item.status != StringConstants.deleted) {
            return CustomRadioTileWidget(
              titleWidget: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.abhaAddress ?? '',
                        style: CustomTextStyle.labelLarge(context)?.apply(
                          color: AppColors.colorBlack,
                        ),
                      ).paddingOnly(top: Dimen.d_5),
                      Text(
                        item.fullName ?? '',
                        style: CustomTextStyle.labelMedium(context)?.apply(
                          color: AppColors.colorGreyDark4,
                          fontWeightDelta: -1,
                        ),
                      ).paddingOnly(top: Dimen.d_5),
                    ],
                  )
                ],
              ).paddingSymmetric(
                vertical: Dimen.d_6,
                horizontal: Dimen.d_6,
              ),
              radioValue: item.abhaAddress ?? '',
              radioGroupValue: _loginController.abhaAddressSelectedValue,
              onChanged: (value) {
                _checkOnAbhaClick(value);
              },
            );
          }

          return Container();
        },
      ).marginOnly(bottom: Dimen.d_30),
    );
  }
}
