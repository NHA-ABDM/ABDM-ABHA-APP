import 'dart:io';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class ProfileMobileView extends StatefulWidget {
  const ProfileMobileView({super.key});

  @override
  ProfileMobileViewState createState() => ProfileMobileViewState();
}

class ProfileMobileViewState extends State<ProfileMobileView> {
  late ProfileController _profileController;
  ProfileModel? _profileModel;
  final ShareService _shareService = ShareServiceImpl();
  final FileService _fileService = FileServiceImpl();
  bool _kycDetail = false;
  // File _qrCodeData = File('');
  Uint8List? image;
  DateTime _dtObj = DateTime(0, 0, 0);
  @override
  void initState() {
    _init();
    // _getProfileData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _profileController = Get.find<ProfileController>();
  }

  void _getProfileData() {
    _profileModel = _profileController.profileModel;
    _kycDetail = _profileController.getKycDetail();
    // _qrCodeData = _profileController.tempQrCodeFile ?? File('');
    _dtObj = _profileController.getDateTime();
  }

  void _showQrScannerPopup() {
    CustomScanOptionDialog()
        .scanOptionPopUp(context, this)
        .then((isDataShared) {
      DeleteControllers().deleteQrCodeScanner();
      bool dataShared = isDataShared ?? false;
      if (dataShared) {
        context.navigateBack(result: dataShared);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _profileWidget();
  }

  Widget _profileWidget() {
    return GetBuilder<ProfileController>(
      builder: (_) {
        _getProfileData();
        return SingleChildScrollView(
          child: Column(
            children: [
              _cardCommonWidget(_userDetail()),
              _cardCommonWidget(_userAbhaDetail()).marginOnly(top: Dimen.d_5),
              _cardCommonWidget(_qrCode()).marginOnly(top: Dimen.d_5),
              _scanAndDownloadQRButton(),
              if (!kIsWeb)
              _scanQrButton(),
              _unlinkText()
            ],
          ),
        );
      },
    );
  }

  Widget _userDetail() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomCircularBorderBackground(
                  innerRadius: Dimen.d_60,
                  image: _profileModel?.profilePhoto ?? '',
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .navigatePush(
                      RoutePath.routeProfileUpdateAddress,
                    )
                        .then((_) {
                      /// update the UI on returning back from next screen with some change
                      _profileController.functionHandler(
                        isUpdateUi: true,
                      );
                    });
                  },
                  child: CustomSvgImageView(
                    ImageLocalAssets.editProfileIconPng,
                    width: Dimen.d_35,
                    height: Dimen.d_35,
                  ).marginOnly(left: Dimen.d_100, top: Dimen.d_70),
                ),
              ],
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _profileModel?.fullName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.bodyLarge(context)?.apply(
                      fontWeightDelta: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (_kycDetail)
                        Icon(
                          IconAssets.checkCircleRounded,
                          size: Dimen.d_20,
                          color: AppColors.colorGreenDark,
                        ).marginOnly(right: Dimen.d_10)
                      else
                        CustomSvgImageView(
                          ImageLocalAssets.selfDeclaredIcon,
                          width: Dimen.d_20,
                          height: Dimen.d_20,
                        ).marginOnly(right: Dimen.d_10),
                      Text(
                        _kycDetail
                            ? LocalizationHandler.of().kycVerified
                            : LocalizationHandler.of().selfdeclared,
                        style: CustomTextStyle.labelMedium(context)?.apply(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).marginOnly(top: Dimen.d_5),
                  Material(
                    color: AppColors.colorAppOrange,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
                        color: AppColors.colorTransparent,
                        borderColor: AppColors.colorAppOrange,
                        size: 5,
                      ),
                      child: InkWell(
                        onTap: () async{
                          _profileController.mappedPhrAddress = [];
                          _profileController.functionHandler(
                            function: () => _profileController.getSwitchAccountUsers(),
                            isLoaderReq: true,
                          ).whenComplete(() {
                            _profileController.mappedPhrAddress = [];
                            Map data = _profileController.responseHandler.data;
                            if (data.isNotEmpty) {
                              for (Map<String, dynamic> jsonMap
                              in data[ApiKeys.responseKeys.users]) {
                                _profileController.mappedPhrAddress
                                    .add(ProfileModel.fromMappedUserMap(jsonMap));
                              }
                              _profileController.abhaAddressSelectedValue =
                                  _profileModel?.abhaAddress ?? '';
                              _profileController.showUserList(context);
                            }
                          });

                          // await abhaSingleton.getSharedPref.get(SharedPref.userLists).then((usersString) {
                          //   for (Map<String, dynamic> jsonMap in jsonDecode(usersString!)) {
                          //     _profileController.mappedPhrAddress.add(ProfileModel.fromMappedUserMap(jsonMap));
                          //   }
                          //   _profileController.abhaAddressSelectedValue = _profileModel?.abhaAddress ?? '';
                          //   _profileController.showUserList(context);
                          // });
                          // context.navigatePush(
                          //   RoutePath.routeSwitchAccount,);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomSvgImageView(
                              ImageLocalAssets.switchAccountIconSvg,
                              width: Dimen.d_20,
                              height: Dimen.d_20,
                              color: AppColors.colorWhite,
                            ).marginOnly(left: Dimen.d_0),
                            Text(
                              LocalizationHandler.of().switchAccount,
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                color: AppColors.colorWhite,
                                fontSizeDelta: -1,
                              ),
                              textAlign: TextAlign.center,
                            ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                          ],
                        ).paddingSymmetric(vertical: Dimen.d_5, horizontal: Dimen.d_10),
                      ),
                    ),
                  ).marginOnly(top: Dimen.d_5),
                ],
              ).marginOnly(left: Dimen.d_10, top: Dimen.d_10),
            )
          ],
        ).paddingAll(Dimen.d_10),
        Divider(
          thickness: Dimen.d_1,
          color: AppColors.colorGreyWildSand,
        ),
        VerticalDivider(
          thickness: Dimen.d_1,
          color: AppColors.colorGreyDark8,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _userProfileCommonWidget(
                  LocalizationHandler.of().dateOfBirth,
                  Validator.isNullOrEmpty(_profileModel?.dateOfBirth?.month) ||
                          Validator.isNullOrEmpty(
                            _profileModel?.dateOfBirth?.date,
                          )
                      ? (_profileModel?.dateOfBirth?.year).toString()
                      : _dtObj.formatDDMMMMYYYY,
                  // _dateOfBirth
                ),
              ),
              VerticalDivider(
                thickness: Dimen.d_1,
                color: AppColors.colorGreyWildSand,
              ),
              Expanded(
                child: _userProfileCommonWidget(
                  LocalizationHandler.of().gender,
                  Validator.getGender(_profileModel?.gender),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userAbhaDetail() {
    return Column(
      children: [
        Row(
          children: [
            CustomSvgImageView(
              ImageLocalAssets.profileAbhaNumberIconSvg,
              width: Dimen.d_40,
              height: Dimen.d_40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userAbhaDetailTitleCommonWidget(
                  LocalizationHandler.of().abhaNumber,
                ),
                Row(
                  children: [
                    _userAbhaDetailValueCommonWidget(
                      _kycDetail
                          ? _profileModel?.abhaNumber ?? ''
                          : LocalizationHandler.of().not_linked,
                    ).marginOnly(top: Dimen.d_5),
                    if (!_kycDetail)
                      InkWell(
                        onTap: () {
                          if (!_kycDetail
                              // && abhaSingleton.getAppData
                              //     .getHealthRecordFetched()
                          ) {
                            context.navigatePush(
                              RoutePath.routeLinkAbhaNumber,
                            );
                          }
                          // else {
                          //   MessageBar.showToastDialog(
                          //     LocalizationHandler.of().pleaseWaitForRecord,
                          //   );
                          // }
                        },
                        child: Text(
                          LocalizationHandler.of().labelLinkAbhaNumber,
                          style: CustomTextStyle.bodyMedium(context)?.apply(
                            decoration: TextDecoration.underline,
                            color: AppColors.colorAppOrange,
                            fontSizeDelta: -2,
                            fontWeightDelta: 2,
                          ),
                        ),
                      ).marginOnly(left: Dimen.d_10, top: Dimen.d_5),
                  ],
                )
              ],
            ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
          ],
        ).paddingOnly(
          top: Dimen.d_10,
          bottom: Dimen.d_5,
          left: Dimen.d_30,
          right: Dimen.d_30,
        ),
        Container(
          height: Dimen.d_2,
          color: AppColors.colorGrey2,
        ),
        Row(
          children: [
            CustomSvgImageView(
              ImageLocalAssets.profileAbhaAddressIconSvg,
              width: Dimen.d_40,
              height: Dimen.d_40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userAbhaDetailTitleCommonWidget(
                  LocalizationHandler.of().abhaAddress,
                ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
                _userAbhaDetailValueCommonWidget(
                  _profileModel?.abhaAddress ?? '',
                ).marginOnly(
                  left: Dimen.d_20,
                  right: Dimen.d_20,
                  top: Dimen.d_5,
                ),
              ],
            )
          ],
        ).paddingOnly(
          top: Dimen.d_10,
          bottom: Dimen.d_5,
          left: Dimen.d_30,
          right: Dimen.d_30,
        ),
      ],
    );
  }

  Widget _qrCode() {
    return _profileController.tempQrCodeFile.isNotEmpty
        ? Column(
            children: [
              Image.memory(
                Uint8List.fromList(_profileController.tempQrCodeFile),
                width: context.width,
                height: Dimen.d_150,
              ),
              Text(
                LocalizationHandler.of().qrCodeShare,
                style: CustomTextStyle.labelMedium(context)?.apply(),
                textAlign: TextAlign.center,
              ),
            ],
          ).paddingAll(Dimen.d_10)
        : const SizedBox.shrink();
  }

  Widget _scanAndDownloadQRButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!kIsWeb)
          ElevatedButtonOrangeBorder(
            text: LocalizationHandler.of().shareqr,
            onPressed: () async {
              File? file = await _fileService.writeToStorage(
                fileName:
                    '${abhaSingleton.getAppData.getAbhaAddress()}_qr_code.png',
                //data: bytes,
                data: Uint8List.fromList(_profileController.tempQrCodeFile),
                directoryType: DirectoryType.temporary,
              );
              _shareService.shareFile(filePath: [file!.path]);
            },
            isLeadingIconRequired: true,
            icon: IconAssets.share,
            size: 5,
          ).marginOnly(right: Dimen.d_10).expand(),
        ElevatedButtonOrangeBorder(
          text: LocalizationHandler.of().download,
          onPressed: () {
            context.navigatePush(
              RoutePath.routeAbhaCard,
            );
          },
          isLeadingIconRequired: true,
          icon: IconAssets.download,
          size: 5,
        ).marginOnly(left: kIsWeb ? Dimen.d_0 : Dimen.d_10).expand(),
      ],
    ).marginOnly(top: Dimen.d_10, right: Dimen.d_5, left: Dimen.d_5);
  }

  Widget _scanQrButton() {
    return TextButtonOrange.mobile(
      text: LocalizationHandler.of().shareAndScan,
      onPressed: () {
        _showQrScannerPopup();
      },
    ).marginOnly(top: Dimen.d_30);
  }

  Widget _unlinkText() {
    return _kycDetail
        ? InkWell(
            onTap: () {
              int? abhaLinkedCount = int.tryParse(
                _profileController.profileModel?.abhaLinkedCount ?? '1f',
              );
              if (_profileController.profileModel != null &&
                  abhaLinkedCount != null &&
                  abhaLinkedCount > 1) {
                // if (abhaSingleton.getAppData.getHealthRecordFetched()) {
                  context.navigatePush(
                    RoutePath.routeUnlinkAbhaNumber,
                  );
                // } else {
                //   MessageBar.showToastDialog(
                //     LocalizationHandler.of().pleaseWaitForRecord,
                //   );
                // }
              } else {
                MessageBar.showToastDialog(
                  LocalizationHandler.of().onlyOneAbhaAddressLinked,
                );
              }
            },
            child: Text(
              LocalizationHandler.of().unlinkAbhaNumber,
              style: CustomTextStyle.bodyMedium(context)?.apply(
                color: AppColors.colorAppOrange,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_50)
        : const SizedBox.shrink();
  }

  /// @Here Common Widget for [title] and its [value]
  Widget _userProfileCommonWidget(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: CustomTextStyle.labelMedium(context)?.apply(),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: CustomTextStyle.bodyMedium(context)?.apply(),
          textAlign: TextAlign.center,
        ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_10),
      ],
    );
  }

  /// @Here Common Widget for [title] and its [value]
  Widget _userAbhaDetailTitleCommonWidget(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelMedium(context)?.apply(),
    );
  }

  Widget _userAbhaDetailValueCommonWidget(String value) {
    return Text(
      value,
      style: CustomTextStyle.bodyMedium(context)
          ?.apply(color: context.themeData.primaryColor),
    );
  }

  Widget _cardCommonWidget(Widget child) {
    return Card(
      shape: abhaSingleton.getBorderDecoration.getRectangularShapeBorder(),
      elevation: Dimen.d_3,
      child: child,
    );
  }
}
