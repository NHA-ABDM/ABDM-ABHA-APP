import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';
import 'package:flutter/foundation.dart';

class LoginConfirmMobileView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onMobileEmailLoginConfirm;

  const LoginConfirmMobileView({
    required this.arguments,
    required this.onMobileEmailLoginConfirm,
    super.key,
  });

  @override
  LoginConfirmMobileViewState createState() => LoginConfirmMobileViewState();
}

class LoginConfirmMobileViewState extends State<LoginConfirmMobileView> {
  late LoginController _loginController;
  late List<ProfileModel> _mappedPhrAddress;
  ValueNotifier<bool> isButtonEnable = ValueNotifier<bool>(false);

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
    return kIsWeb
        ? MobileWebCardWidget(child: _loginConfirmWidget())
        : _loginConfirmWidget();
  }

  Widget _loginConfirmWidget() {
    return Column(
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().loginSelectAbhaAddress,
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).paddingSymmetric(
            vertical: Dimen.d_20,
            horizontal: Dimen.d_20,
          )
        else
          Text(
            LocalizationHandler.of().loginSelectAbhaAddress,
            style: CustomTextStyle.bodyMedium(context)?.apply(
              color: AppColors.colorBlack6,
            ),
          ).marginOnly(left: Dimen.d_25, right: Dimen.d_25, top: Dimen.d_20),
        if (kIsWeb)
          SizedBox(height: context.height / 2, child: _listOfAbhaAddress())
        else
          Expanded(child: _listOfAbhaAddress()),
        ValueListenableBuilder<bool>(
          valueListenable: isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (isButtonEnable) {
                  _loginController.loginMethod =
                      LoginMethod.abhaAddressSelection;
                  widget.onMobileEmailLoginConfirm();
                }
              },
            ).marginOnly(
              top: Dimen.d_10,
              bottom: Dimen.d_35,
              left: kIsWeb ? Dimen.d_16 : Dimen.d_0,
              right: kIsWeb ? Dimen.d_16 : Dimen.d_0,
            );
          },
        ),
      ],
    );
  }

  /// @Here list displays the suggested phr mapped addresses.
  Widget _listOfAbhaAddress() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _mappedPhrAddress.length,
      itemBuilder: (context, position) {
        /// mapped phr address list item
        var item = _mappedPhrAddress[position];

        if (item.status != StringConstants.deleted) {
          return CustomRadioTileWidget(
            titleWidget: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.abhaAddress ?? '',
                        style: CustomTextStyle.labelLarge(context)?.apply(
                          color: AppColors.colorBlack,
                          fontWeightDelta: -1,
                        ),
                      ).paddingOnly(top: Dimen.d_5),
                      Text(
                        item.fullName ?? '',
                        style: CustomTextStyle.labelLarge(context)?.apply(
                          color: AppColors.colorGreyLight1,
                        ),
                      ).paddingOnly(top: Dimen.d_5),
                    ],
                  ),
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
    ).paddingOnly(bottom: Dimen.d_30).marginOnly(top: Dimen.d_10);
  }
}
