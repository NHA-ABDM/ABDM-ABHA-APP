import 'package:abha/app/profile/model/profile_abha_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';

class RegistrationAbhaConfirmDesktopView extends StatefulWidget {
  final VoidCallback onMobileEmailLoginConfirm;
  final Map arguments;

  const RegistrationAbhaConfirmDesktopView({
    required this.arguments,
    required this.onMobileEmailLoginConfirm,
    super.key,
  });

  @override
  RegistrationAbhaConfirmDesktopViewState createState() =>
      RegistrationAbhaConfirmDesktopViewState();
}

class RegistrationAbhaConfirmDesktopViewState
    extends State<RegistrationAbhaConfirmDesktopView> {
  late RegistrationController _registrationController;
  late List<ProfileModel> _mappedPhrAddress;

  Map<String, dynamic>? _screenData;
  ProfileAbhaModel? _profileData;
  late String _sentToString;
  late String _fromScreenString;
  bool checkbox1 = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find();
    _mappedPhrAddress = widget.arguments[IntentConstant.mappedPhrAddress];
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _sentToString = widget.arguments[IntentConstant.sentToString];
    _screenData = widget.arguments[IntentConstant.data];
    if (_fromScreenString == 'registrationAbha') {
      _profileData = ProfileAbhaModel.fromJson(_screenData!);
      _registrationController.saveAbhaFormDetails(_profileData);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkOnAbhaClick(value) {
    _registrationController.abhaAddressSelectedValue = value;
    _registrationController
        .update([UpdateAddressSelectUiBuilderIds.addressSelect]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: abhaSingleton.getBorderDecoration
          .getRectangularShapeBorder(size: Dimen.d_4),
      elevation: Dimen.d_1,
      child: _userProfileWidget(),
    ).paddingSymmetric(
      vertical: Dimen.d_30,
      horizontal: context.width * 0.1,
    );
  }

  Widget _userProfileWidget() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: (!Validator.isNullOrEmpty(_profileData))
                ? _getAbhaDetailsFromProfileWidget()
                : CustomImageView(
                    image: ImageLocalAssets.loginWithEmailImg,
                    // width: Dimen.d_200,
                    height: Dimen.d_260,
                  ).centerWidget.paddingSymmetric(
                      vertical: Dimen.d_24,
                      horizontal: Dimen.d_20,
                    ),
          ),
          Container(
            width: Dimen.d_1,
            color: AppColors.colorGreyWildSand,
          ).marginSymmetric(vertical: Dimen.d_10),
          Flexible(
            flex: 6,
            child: regConfirmWidget().marginSymmetric(
              vertical: Dimen.d_20,
              horizontal: Dimen.d_60,
            ),
          )
        ],
      ).paddingAll(Dimen.d_15),
    );
  }

  Widget regConfirmWidget() {
    return Column(
      children: WidgetUtility.spreadWidgets(
        [
          if (Validator.isNullOrEmpty(_profileData))
            Text(
              LocalizationHandler.of().registrationSelectAbhaAddress,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack6,
                fontWeightDelta: 2,
              ),
            ).alignAtCenterLeft().marginOnly(left: Dimen.d_20)
          else
            const SizedBox.shrink(),
          if (!Validator.isNullOrEmpty(_profileData) &&
              !Validator.isNullOrEmpty(_mappedPhrAddress))
            if (_mappedPhrAddress.length == 1)
              Text(
                LocalizationHandler.of()
                    .weFoundAccount(_mappedPhrAddress.length.toString()),
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontWeightDelta: 2,
                ),
              ).alignAtTopLeft()
            else
              Text(
                LocalizationHandler.of()
                    .weFoundAccounts(_mappedPhrAddress.length.toString()),
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontWeightDelta: 2,
                ),
              ).alignAtTopLeft()
          else
            const SizedBox.shrink(),
          if (Validator.isNullOrEmpty(_mappedPhrAddress))
            SizedBox(
              height: context.height * 0.5,
              child: CustomErrorView(
                image: ImageLocalAssets.noFacilityLinkAcountImage,
                imageHeight: context.height * 0.25,
                status: Status.success,
                infoMessageTitle: LocalizationHandler.of().noAbhaAddressFound,
              ),
            )
          else
            _listOfAbhaAddressWidget().sizedBox(
              height: _mappedPhrAddress.length > 10
                  ? context.height * 0.5
                  : _mappedPhrAddress.length * Dimen.d_60,
            ),
          Row(
            children: [
              if (!Validator.isNullOrEmpty(_mappedPhrAddress))
                TextButtonOrange.desktop(
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    widget.onMobileEmailLoginConfirm();
                  },
                ).marginOnly(right: Dimen.d_16),
              TextButtonPurple.desktop(
                text: LocalizationHandler.of().cancel,
                onPressed: () {
                  setState(() {
                    _registrationController.mobileTexController.text = '';
                    _registrationController.abhaNumberTextController.text = '';
                    _registrationController.emailTextController.text = '';
                    _registrationController.autoValidateModeWeb =
                        AutovalidateMode.disabled;
                  });
                  context.navigateBack();
                },
              ).marginOnly(right: Dimen.d_16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    /// If came from Registration Abha Number screen
                    if (_fromScreenString == 'registrationAbha') {
                      var arguments = {
                        IntentConstant.fromScreen: _fromScreenString,
                        IntentConstant.sentToString: _sentToString,
                      };
                      context.navigatePushReplacement(
                        RoutePath.routeRegistrationAbhaAddress,
                        arguments: arguments,
                      );
                    } else {
                      /// If Came from Registration Email or Mobile screen
                      var arguments = {
                        IntentConstant.fromScreen: _fromScreenString,
                        IntentConstant.sentToString: _sentToString,
                      };
                      context.navigatePushReplacement(
                        RoutePath.routeRegistrationForm,
                        arguments: arguments,
                      );
                    }
                  },
                  child: Text(
                    !Validator.isNullOrEmpty(_mappedPhrAddress)
                        ? LocalizationHandler.of()
                            .create_new_phr //wantToCreateAbhaAddress
                        : LocalizationHandler.of().create_new_phr,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorAppOrange,
                      fontWeightDelta: 2,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ).alignAtCenterRight(),
              ),
            ],
          ).marginOnly(top: Dimen.d_10),
        ],
        interItemSpace: Dimen.d_6,
        flowHorizontal: false,
      ),
    ).marginSymmetric(horizontal: Dimen.d_10);
  }

  Widget _listOfAbhaAddressWidget() {
    return Scrollbar(
      thickness: Dimen.d_6,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      controller: scrollController,
      radius: const Radius.circular(15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _mappedPhrAddress.length,
        controller: scrollController,
        itemBuilder: (context, position) {
          /// mapped phr address list item
          var item = _mappedPhrAddress[position];
          if (item.status != StringConstants.deleted) {
            return GetBuilder<RegistrationController>(
              id: UpdateAddressSelectUiBuilderIds.addressSelect,
              builder: (mContext) {
                return CustomRadioTileWidget(
                  tileHeight: Dimen.d_60,
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
                  radioGroupValue: _registrationController
                          .abhaAddressSelectedValue?.abhaAddress ??
                      '',
                  onChanged: (value) {
                    _checkOnAbhaClick(item);
                  },
                );
              },
            );
          }
          return Container();
        },
      ).paddingAll(Dimen.d_0).marginSymmetric(),
    );
  }

  /// Here is the Parent Widget were the User details like name, mobile no, email and
  /// abha number will get in getUsersNameEmailAbhaNoDetail() widget and Details related
  /// to Address, Gender and DOB will get in getUsersGenderDOBAddressDetail()
  Widget _getAbhaDetailsFromProfileWidget() {
    return Stack(
      children: [
        _getUsersNameEmailAbhaNoDetail(),
        _getUsersGenderDOBAddressDetail()
      ],
    ).marginOnly(
      left: Dimen.d_10,
      right: Dimen.d_25,
      top: Dimen.d_10,
      bottom: Dimen.d_10,
    );
  }

  /// Here is the Widget to get Name, Email, Phone No and Profile Image
  Widget _getUsersNameEmailAbhaNoDetail() {
    Accounts? user = _profileData?.accounts?[0];
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
        topLeft: 0,
        topRight: 0,
        bottomLeft: 0,
        bottomRight: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user?.firstName} ${user?.lastName}',
                style: CustomTextStyle.bodyLarge(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(
                top: Dimen.d_20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSvgImageView(
                    ImageLocalAssets.shareMobileNoIconSvg,
                    color: AppColors.colorWhite,
                    width: Dimen.d_15,
                  ).paddingOnly(top: Dimen.d_10),
                  Text(
                    '${user?.mobile}',
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorWhite,
                    ),
                  ).marginOnly(top: Dimen.d_7).paddingOnly(left: Dimen.d_10),
                ],
              ),
              if (user?.email != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomSvgImageView(
                      ImageLocalAssets.shareEmailIconSvg,
                      color: AppColors.colorWhite,
                      width: Dimen.d_15,
                    ).paddingOnly(top: Dimen.d_10),
                    Text(
                      '${user?.email}',
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorWhite,
                      ),
                    ).marginOnly(top: Dimen.d_7).paddingOnly(left: Dimen.d_10),
                  ],
                )
              else
                Container(),
              Text(
                LocalizationHandler.of().fetchedFromAbhaNumber,
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGrey,
                ),
              ).marginOnly(top: Dimen.d_19),
              Text(
                '${user?.aBHANumber}',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(top: Dimen.d_5),
            ],
          ).marginOnly(left: Dimen.d_20),
          CustomCircularBorderBackground(
            image: user?.profilePhoto ?? '',
          ).alignAtTopRight().marginOnly(right: Dimen.d_30, top: Dimen.d_5),
        ],
      ).marginOnly(top: Dimen.d_30),
    ).sizedBox(height: Dimen.d_300);
  }

  /// Here is the Widget to get DOB, Gender, and Address
  Widget _getUsersGenderDOBAddressDetail() {
    Accounts? user = _profileData?.accounts?[0];
    var dtObj = DateTime(
      int.tryParse(user?.yearOfBirth ?? '') ?? 0,
      int.tryParse(user?.monthOfBirth ?? '') ?? 0,
      int.tryParse(user?.dayOfBirth ?? '') ?? 0,
    );
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        color: AppColors.colorWhite,
        borderColor: AppColors.colorWhite,
        size: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _textTitleValue(
                LocalizationHandler.of().gender,
                Validator.getGender(user?.gender),
              ),
              _textTitleValue(
                LocalizationHandler.of().dateOfBirth,
                dtObj.formatDDMMMMYYYY,
              )
            ],
          ),
          _textTitleValue(
            LocalizationHandler.of().plotNumber,
            '${user?.address}',
          ).marginOnly(top: Dimen.d_20),
          SizedBox(
            width: context.width,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              children: [
                _textTitleValue(
                  LocalizationHandler.of().district,
                  '${user?.districtName}',
                ),
                _textTitleValue(
                  LocalizationHandler.of().state,
                  '${user?.stateName}',
                ),
                _textTitleValue(
                  LocalizationHandler.of().pinCode,
                  '${user?.pincode}',
                ),
              ],
            ).marginOnly(top: Dimen.d_20),
          ),
        ],
      ).paddingAll(Dimen.d_20),
    )
        .marginOnly(
          left: Dimen.d_20,
          right: Dimen.d_20,
          top: Dimen.d_50,
        )
        .centerWidget
        .marginOnly(top: Dimen.d_170);
  }

  Widget _textTitleValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomTextStyle.labelMedium(context)?.apply(
            color: AppColors.colorGreyDark1,
          ),
        ),
        Text(
          value,
          softWrap: true,
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontSizeDelta: -2,
            fontWeightDelta: 2,
            color: AppColors.colorGreyDark2,
          ),
        ).marginOnly(top: Dimen.d_5)
      ],
    );
  }
}
