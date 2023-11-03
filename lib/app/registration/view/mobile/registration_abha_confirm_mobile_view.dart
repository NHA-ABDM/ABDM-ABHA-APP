import 'package:abha/app/profile/model/profile_abha_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';
import 'package:flutter/foundation.dart';

class RegistrationAbhaConfirmMobileView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onMobileEmailLoginConfirm;

  const RegistrationAbhaConfirmMobileView({
    required this.arguments,
    required this.onMobileEmailLoginConfirm,
    super.key,
  });

  @override
  RegistrationAbhaConfirmMobileViewState createState() =>
      RegistrationAbhaConfirmMobileViewState();
}

class RegistrationAbhaConfirmMobileViewState
    extends State<RegistrationAbhaConfirmMobileView> {
  late RegistrationController _registrationController;
  late List<ProfileModel> _mappedPhrAddress;

  Map<String, dynamic>? _screenData;

  // ProfileModel? _profileData;
  ProfileAbhaModel? _profileData;
  late String _sentToString;
  late String _fromScreenString;
  bool checkbox1 = false;

  @override
  void initState() {
    _registrationController = Get.find<RegistrationController>();
    _mappedPhrAddress = widget.arguments[IntentConstant.mappedPhrAddress];
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _sentToString = widget.arguments[IntentConstant.sentToString];
    _screenData = widget.arguments[IntentConstant.data];
    if (_fromScreenString == 'registrationAbha') {
      _profileData = ProfileAbhaModel.fromJson(_screenData!);
      _registrationController.saveAbhaFormDetails(_profileData);
    }
    super.initState();
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
    return kIsWeb
        ? MobileWebCardWidget(child: regConfirmWidget())
        : SingleChildScrollView(child: regConfirmWidget());
  }

  Widget regConfirmWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!Validator.isNullOrEmpty(_profileData))
            _getAbhaDetailsFromProfileWidget()
          else
            const SizedBox.shrink(),
          Column(
            children: [
              if (Validator.isNullOrEmpty(_profileData))
                Text(
                  LocalizationHandler.of().registrationSelectAbhaAddress,
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorBlack6,
                    heightDelta: 0.5,
                  ),
                )
                    .marginOnly(
                      top: Dimen.d_30,
                      left: Dimen.d_17,
                      right: Dimen.d_17,
                    )
                    .alignAtCenterLeft()
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
                  ).marginOnly(
                    top: Dimen.d_30,
                    left: Dimen.d_30,
                    right: Dimen.d_30,
                  )
                else
                  Text(
                    LocalizationHandler.of()
                        .weFoundAccounts(_mappedPhrAddress.length.toString()),
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack6,
                      fontWeightDelta: 2,
                    ),
                  ).marginOnly(
                    top: Dimen.d_30,
                    left: Dimen.d_30,
                    right: Dimen.d_30,
                  )
              else
                const SizedBox.shrink(),
              if (Validator.isNullOrEmpty(_mappedPhrAddress))
                CustomErrorView(
                  image: ImageLocalAssets.noFacilityLinkAcountImage,
                  imageHeight: context.height * 0.20,
                  status: Status.success,
                  infoMessageTitle: LocalizationHandler.of().noAbhaAddressFound,
                )
              else
                _listOfAbhaAddressWidget()
                    .marginOnly(top: Dimen.d_10, bottom: Dimen.d_10),
            ],
          ),
          if (!Validator.isNullOrEmpty(_mappedPhrAddress))
            TextButtonOrange.mobile(
              text: LocalizationHandler.of().continuee,
              onPressed: () {
                widget.onMobileEmailLoginConfirm();
              },
            ).marginOnly(
              top: Dimen.d_40,
              left: Dimen.d_16,
              right: Dimen.d_16,
            ),
          if (!Validator.isNullOrEmpty(_mappedPhrAddress)) _optionWidget(),
          InkWell(
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
                  ? LocalizationHandler.of().wantToCreateAbhaAddress
                  : LocalizationHandler.of().create_new_phr,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppOrange,
                fontWeightDelta: 2,
                decoration: TextDecoration.underline,
              ),
            ),
          ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_50),
        ],
      ),
    );
  }

  Widget _listOfAbhaAddressWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mappedPhrAddress.length,
      itemBuilder: (context, position) {
        /// mapped phr address list item
        var item = _mappedPhrAddress[position];
        if (item.status != StringConstants.deleted) {
          return GetBuilder<RegistrationController>(
            id: UpdateAddressSelectUiBuilderIds.addressSelect,
            builder: (mContext) {
              return CustomRadioTileWidget(
                titleWidget: Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                ).paddingSymmetric(vertical: Dimen.d_6, horizontal: Dimen.d_6),
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
    ).marginOnly(top: Dimen.d_10);
  }

  Widget _optionWidget() {
    return Text(
      LocalizationHandler.of().or.toUpperCase(),
      style: CustomTextStyle.bodyLarge(context)?.apply(
        color: AppColors.colorGreyDark2,
        fontWeightDelta: 2,
      ),
    ).marginOnly(top: Dimen.d_20);
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
                '${user?.name}',
                style: CustomTextStyle.bodyLarge(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(
                top: Dimen.d_20,
              ),
              if (user?.mobile != null)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _textTitleValue(
                LocalizationHandler.of().plotNumber,
                '${user?.address}',
              ),
            ],
          ).marginOnly(top: Dimen.d_20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ).paddingAll(Dimen.d_20),
    )
        .marginOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_50)
        .centerWidget
        .marginOnly(top: Dimen.d_170);
  }

  Widget _textTitleValue(String title, String value) {
    return Flexible(
      child: Column(
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
      ),
    );
  }
}
