import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';
import 'package:abha/reusable_widget/reset/restart_widget.dart';
import 'package:abha/service/lgd_service.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class ProfileController extends BaseController {
  late ProfileRepo profileRepo;
  late LGDService lgdService;
  final int _otpTime = 60;
  late int otpCountDown;
  late bool isResendOtpEnabled;
  int minutes = 0;
  ProfileModel? profileModel;
  ValueNotifier<ProfileModel?> getProfileModel = ValueNotifier(ProfileModel());
  String? tokenNo = '';
  // File? tempQrCodeFile;
  List<int> tempQrCodeFile = [];
  final FileService _fileService = FileServiceImpl();
  String? txnId;
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
  final TextEditingController textEditingController = TextEditingController();

  late List<ProfileModel> mappedPhrAddress;
  String? abhaAddressSelectedValue;

  ProfileController(ProfileRepoImpl repo) : super(ProfileController) {
    profileRepo = repo;
    lgdService = LGDServiceImpl();
  }

  Future<void> getProfileFetch({bool fromDashboard = false}) async {
    tempResponseData = await profileRepo.onMyProfile();
    String tempData = jsonEncode(tempResponseData);
    profileModel = profileFromMap(tempData);
    getProfileModel.value = profileModel;
    _setUserDataLocally();
    fromDashboard ? null : await getQrCode();
  }

  Future<void> getQrCode() async {
    tempQrCodeFile = await profileRepo.onDownloadQrCode() ?? Uint8List(0);
    // tempQrCodeFile = await _fileService.writeToStorage(
    //   fileName: '${userId}_qr_code.png',
    //   data: response,
    //   directoryType: DirectoryType.temporary,
    // );
  }

  DateTime getDateTime() {
    return DateTime(
      profileModel?.dateOfBirth?.year ?? 0,
      profileModel?.dateOfBirth?.month ?? 0,
      profileModel?.dateOfBirth?.date ?? 0,
    );
  }

  Future<void> _setUserDataLocally() async {
    String userName = profileModel?.fullName ??
        '${profileModel?.name?.firstName} ${profileModel?.name?.lastName}';
    abhaSingleton.getAppData.setUserName(userName);
    abhaSingleton.getAppData.setAbhaAddress(profileModel?.abhaAddress ?? '');
    abhaSingleton.getAppData.setAbhaNumber(profileModel?.abhaNumber ?? '');
    abhaSingleton.getSharedPref.set(SharedPref.userName, userName);
    abhaSingleton.getSharedPref
        .set(SharedPref.abhaAddress, profileModel?.abhaAddress ?? '');
  }

  Future<void> getEmailMobileOtpGen(
    String data, {
    bool isUpdateEmail = false,
  }) async {
    // final Encrypted encryptedEmailId = await Validator.encryptData(email);
    tempResponseData = await profileRepo.onEmailMobileOtpGen(
      await _generateOtpRequestData(data, isUpdateEmail: isUpdateEmail),
    );
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getOtpVerify(String otp, bool isUpdateEmail) async {
    // final Encrypted encryptedEmailId = await Validator.encryptData(otp);
    tempResponseData = await profileRepo.onEmailMobileOtpVerify(
      await _verifyOtpRequestData(otp, isUpdateEmail: isUpdateEmail),
    );
    if (responseHandler.status == Status.success) {
      if (tempResponseData.containsKey(ApiKeys.responseKeys.authResult) &&
          tempResponseData[ApiKeys.responseKeys.authResult]
              .toString()
              .contains('success')) {
        await getProfileFetch();
      }
    }
  }

  // Future<void> getResendOtp(String sessionId) async {
  //   final resendOtpData = {
  //     ApiKeys.requestKeys.sessionId: sessionId,
  //   };
  //   tempResponseData = await profileRepo.onMobileEmailResentOtp(resendOtpData);
  // }

  Future<void> getStates({BuildContext? context}) async {
    tempResponseData = await lgdService.onGetStates();
    /*String data = await DefaultAssetBundle.of(context!)
        .loadString('assets/json/states.json');
    tempResponseData = jsonDecode(data);*/
  }

  Future<void> getDistricts(String stateCode, {BuildContext? context}) async {
    tempResponseData = await lgdService.onGetDistricts(stateCode);

    /*String data = await DefaultAssetBundle.of(context!)
        .loadString('assets/json/districts.json');
    tempResponseData = jsonDecode(data);*/
  }

  Future<LGDDetails?> validatePinCode(
    String pinCode, {
    BuildContext? context,
  }) async {
    try {
      var response = await lgdService.validateLGDDetails(pinCode);
      return LGDDetails.fromJson(response);
    } catch (e) {
      return null;
    }

    /*String data = await DefaultAssetBundle.of(context!)
        .loadString('assets/json/districts.json');
    tempResponseData = jsonDecode(data);*/
  }

  Future<void> updateUserProfile(ProfileModel model) async {
    tempResponseData =
        await profileRepo.onUpdateUserProfile(model.toUpdateProfileMap());
    await getProfileFetch();
  }

  void otpTimerInit() {
    otpCountDown = _otpTime;
    isResendOtpEnabled = false;
  }

  void otpTimerCountDown() {
    if (otpCountDown > 1) {
      otpCountDown--;
    } else {
      isResendOtpEnabled = true;
    }
  }

  /// @Here function getKycDetail() returns boolean.
  /// Functions checks the user is kyc verified or not.
  /// returns bool.
  bool getKycDetail() {
    // String kycVerified = profileModel?.kycVerified ?? '';
    String kycStatus = profileModel?.kycStatus ?? '';
    return kycStatus == StringConstants.kycStatus
        // || kycVerified.parseBool()
        ? true
        : false;
  }

  String getGender(String? gender) {
    if (gender == 'M') {
      return 'Male';
    } else if (gender == 'F') {
      return 'Female';
    } else if (gender == 'O') {
      return 'Others';
    } else if (gender == 'U') {
      return "I Don't Want To Disclose";
    } else {
      return '';
    }
  }

  String getNote() {
    String message = '';
    bool isKycVerified = getKycDetail();
    if (isKycVerified) {
      message = LocalizationHandler.of().note_edited_doc_info;
    }
    // else if (profileModel?.mobileVerified == true &&
    //     profileModel?.emailVerified == true) {
    //   message = LocalizationHandler.of().mobileEmailCantEdit;
    // } else if (profileModel?.mobileVerified == true) {
    //   message = LocalizationHandler.of().mobile_cant_edit;
    // } else if (profileModel?.emailVerified == true) {
    //   message = LocalizationHandler.of().email_cant_edit;
    // }
    return message;
  }

  /// @Here function to create the Map request with authmode params used :-
  ///    [profileUpdateData] of type String.
  ///    returns the variable [updateEmailMobileData].
  Future<Map> _generateOtpRequestData(
    String profileUpdateData, {
    bool isUpdateEmail = false,
  }) async {
    tempResponseData =
        await abhaSingleton.getApiProvider.onEncryptData(profileUpdateData);
    Map<String, dynamic> updateEmailMobileData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaAddressProfile,
        if (isUpdateEmail)
          ApiKeys.requestValues.scopeEmailVerify
        else
          ApiKeys.requestValues.scopeMobileVerify
      ],
      ApiKeys.requestKeys.loginHint: isUpdateEmail
          ? ApiKeys.requestValues.loginHintEmail
          : ApiKeys.requestValues.loginHintMobileNumber,
      ApiKeys.requestKeys.loginId: tempResponseData,
      ApiKeys.requestKeys.otpSystem: ApiKeys.requestValues.otpSystemAbdm,
    };
    return updateEmailMobileData;
  }

  Future<Map> _verifyOtpRequestData(
    String profileConfirmData, {
    bool isUpdateEmail = false,
  }) async {
    tempResponseData =
        await abhaSingleton.getApiProvider.onEncryptData(profileConfirmData);
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaAddressProfile,
        if (isUpdateEmail)
          ApiKeys.requestValues.scopeEmailVerify
        else
          ApiKeys.requestValues.scopeMobileVerify
      ],
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestValues.authMethodsOtp],
        ApiKeys.requestKeys.otp: {
          ApiKeys.requestKeys.txnId: txnId,
          ApiKeys.requestKeys.otpValue: tempResponseData
        },
      },
    };
    return authConfirmData;
  }

  bool isImageSizeValid(int size) {
    return size <= 100000;
  }

  bool isImagePathValid(String imageType) {
    bool imageAccepted = false;
    if (kIsWeb) {
      if (imageType.contains('image/jpeg') ||
          imageType.contains('image/png') ||
          imageType.contains('image/jpg')) {
        imageAccepted = true;
      }
    } else {
      if (imageType.endsWith('jpeg') ||
          imageType.endsWith('png') ||
          imageType.endsWith('jpg')) {
        imageAccepted = true;
      }
    }
    return imageAccepted;
  }

  void showUserList(BuildContext context, {bool isWebMobile = false}) async {
    if (kIsWeb) {
      showDialogBox(context, isWebMobile);
    } else {
      showBottomSheetDialog(context);
    }
  }

  void showDialogBox(BuildContext context, bool isWebMobile) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => CustomSimpleDialog(
        title: LocalizationHandler.of().switchAccount,
        subTitle: LocalizationHandler.of().switchAccountMessage,
        showCloseButton: true,
        paddingLeft: Dimen.d_0,
        size: Dimen.d_6,
        child: switchProfile().sizedBox(
          width: isWebMobile ? context.width * 0.40 : context.width / 0.3,
          height: isWebMobile ? context.width * 0.30 : context.height * 0.7,
        ),
      ),
    );
  }

  void showBottomSheetDialog(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => switchProfile(),
    );
  }

  StatefulBuilder switchProfile() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Material(
          child: Container(
            constraints: BoxConstraints(maxHeight: context.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!kIsWeb)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvgImageView(
                        ImageLocalAssets.switchAccountIconSvg,
                        width: Dimen.d_20,
                        height: Dimen.d_20,
                        color: AppColors.colorAppBlue,
                      ).marginOnly(left: Dimen.d_10),
                      Text(
                        LocalizationHandler.of().switchAccount,
                        style: CustomTextStyle.bodyMedium(context)?.apply(
                          color: AppColors.colorAppBlue,
                        ),
                        textAlign: TextAlign.center,
                      ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                    ],
                  ).marginOnly(top: Dimen.d_5),
                if (!kIsWeb)
                  Text(
                    LocalizationHandler.of().switchAccountMessage,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack,
                      fontWeightDelta: -1,
                    ),
                    textAlign: TextAlign.center,
                  ).marginOnly(
                    top: Dimen.d_10,
                    left: Dimen.d_10,
                    right: Dimen.d_5,
                  ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: mappedPhrAddress.length,
                    itemBuilder: (context, position) {
                      /// mapped phr address list item
                      var item = mappedPhrAddress[position];

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
                                      style: CustomTextStyle.labelLarge(context)
                                          ?.apply(
                                        color: AppColors.colorBlack,
                                        fontWeightDelta: -1,
                                      ),
                                    ).paddingOnly(top: Dimen.d_5),
                                    Text(
                                      item.fullName ?? '',
                                      style: CustomTextStyle.labelLarge(context)
                                          ?.apply(
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
                          radioGroupValue: abhaAddressSelectedValue,
                          horizontalMargin: Dimen.d_0,
                          onChanged: (value) {
                            setModalState(() {
                              abhaAddressSelectedValue = value as String;
                            });
                          },
                        );
                      }
                      return Container();
                    },
                  ).marginOnly(top: kIsWeb ? Dimen.d_0 : Dimen.d_10),
                ),
                TextButtonOrange.mobile(
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    if (abhaAddressSelectedValue == profileModel?.abhaAddress) {
                      MessageBar.showToastDialog(
                        LocalizationHandler.of().selectDiffAbhaAddress,
                      );
                    } else {
                      functionHandler(
                        function: () => _verifySwitchUser(),
                        isLoaderReq: true,
                      ).whenComplete(() async {
                        abhaSingleton.getApiProvider.xAuthToken = '';
                        DashboardController dashboardController =
                            Get.find<DashboardController>();
                        final box = HiveBoxes();
                        var arguments = {
                          IntentConstant.abhaAddress: abhaAddressSelectedValue
                        };
                        await dashboardController
                            .isNewAbhaAddress(box, arguments)
                            .then((value) {
                          kIsWeb
                              ? html.window.location.reload()
                              : RestartWidget.restartApp(context);
                        });
                      });
                    }
                  },
                ).marginOnly(
                  top: Dimen.d_10,
                  bottom: Dimen.d_10,
                  left: kIsWeb ? Dimen.d_16 : Dimen.d_0,
                  right: kIsWeb ? Dimen.d_16 : Dimen.d_0,
                )
              ],
            ).marginSymmetric(
              horizontal: Dimen.d_16,
              vertical: Dimen.d_16,
            ),
          ),
        );
      },
    );
  }

  Future<void> getSwitchAccountUsers() async {
    tempResponseData = await profileRepo.onGetSwitchAccountUsers();
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> _verifySwitchUser() async {
    String tToken = tempResponseData[ApiKeys.responseKeys.tokens]
        [ApiKeys.responseKeys.token];
    Map<String, dynamic> switchUser = {
      'abhaAddress': abhaAddressSelectedValue,
      'txnId': txnId
    };
    tempResponseData = await profileRepo.onVerifySwitchUser(switchUser, tToken);
    abhaSingleton.getApiProvider.addXHeaderToken(tempResponseData);
  }
}
