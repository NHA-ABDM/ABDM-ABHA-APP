import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/share_profile/share_profile_repo.dart';
import 'package:abha/app/share_profile/view/share_profile_mobile_view.dart';
import 'package:abha/app/share_profile/view/share_profile_phr_link_desktop_view.dart';
import 'package:abha/app/share_profile/view/share_profile_uhi_link_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/geolocation/geolocation_handler.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class ShareProfileView extends StatefulWidget {
  final Map arguments;

  const ShareProfileView({required this.arguments, super.key});

  @override
  ShareProfileViewState createState() => ShareProfileViewState();
}

class ShareProfileViewState extends State<ShareProfileView> {
  late ShareProfileController _shareProfileController;
  late String _shareHipId, _counterId, _uhiHipId;

  @override
  void initState() {
    _init();
    kIsWeb ? null : _onFetchProviderDetails();
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteShareProfiler();
    super.dispose();
  }

  void _init() {
    _shareProfileController =
        Get.put(ShareProfileController(ShareProfileRepoImpl()));
    _shareHipId = widget.arguments[IntentConstant.hipId] ?? '';
    _counterId = widget.arguments[IntentConstant.counterId] ?? '';
    _uhiHipId = widget.arguments[IntentConstant.uhiId] ?? '';
  }

  Future<void> _onFetchProviderDetails() async {
    _shareProfileController.functionHandler(
      function: () => _shareProfileController.getProviderDetails(_shareHipId),
      isUpdateUi: true,
    );
  }

  Future<void> _getCurrentLocation() async {
    LocationData? location;
    _shareProfileController
        .functionHandler(
      function: () async =>
          location = await GeoLocationHandler.getUserLocation(),
      isLoaderReq: true,
    )
        .whenComplete(() {
      if (_shareProfileController.responseHandler.status == Status.success) {
        _onShareMyProfile(location);
      }
    });
  }

  Future<void> _onShareMyProfile(LocationData? location) async {
    /// NEW implementation with websocket
    _shareProfileController.getPatientProfileShare(
      _shareHipId,
      _counterId,
      location,
      (responseModel) => _getShareMyProfileOnResponse(responseModel),
    );

    /// OLD implementation without websocket
    // _shareProfileController.functionHandler(
    //   function: () => _shareProfileController.getPatientProfileShare(
    //     _shareHipId,
    //     _counterId,
    //     location,
    //       (responseModel)=> _getShareMyProfileOnResponse(responseModel)
    //   ),
    //   isLoaderReq: true,
    // ).whenComplete(() {
    //   if (_shareProfileController.responseHandler.status == Status.success) {
    //     abhaSingleton.getSharedPref.set(SharedPref.isShareTokenActivated, true);
    //     context.navigateBack(result: true);
    //   }
    // });
  }

  void _getShareMyProfileOnResponse(ApiSocketLocalResponseModel responseModel) {
    // abhaSingleton.getSharedPref.set(SharedPref.isShareTokenActivated, true);
    // context.navigateBack(result: true);
    // if (responseModel.id == 0) {
    //   MessageBar.showToastError(LocalizationHandler.of().socketError);
    // } else {
    Map responseData = jsonDecode(responseModel.data ?? '');
    bool isAcknowledged =
        responseData.containsKey(ApiKeys.responseKeys.acknowledgement);
    if (isAcknowledged) {
      // abhaSingleton.getSharedPref.set(SharedPref.isShareTokenActivated, true);

      /// AS per new logic suggested by leaders we will save the token details in shared preference
      /// and from it we will show it to dashboard screen
      // TokenModel tokenModel = TokenModel();
      // tokenModel.tokenNumber = responseData['acknowledgement']['profile']['tokenNumber'];
      // tokenModel.dateCreated = DateTime.now();
      // tokenModel.currentDateTime = DateTime.now();
      // /// TO-IMPLEMENT: added 1800 sec hardcoded as Atik told we have to set expiry for 30 min
      // tokenModel.expiresIn = 1800; //double.parse(responseData['acknowledgement']['profile']['expiry']);
      // abhaSingleton.getSharedPref.set(SharedPref.tokenDetails, jsonEncode(tokenModel.toMap()));

      context.navigateBack(result: true);
    } else {
      MessageBar.showToastError(LocalizationHandler.of().someError);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().shareProfile.toTitleCase(),
      type: ShareProfileView,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: _mobileWidget(),
      bodyDesktop: _desktopWidget(),
    );
  }

  Widget _mobileWidget() {
    return kIsWeb
        ? _desktopWidget()
        : ShareProfileMobileView(getCurrentLocation: _getCurrentLocation);
  }

  Widget _desktopWidget() {
    return !Validator.isNullOrEmpty(_uhiHipId)
        ? ShareProfileUhiLinkDesktopView(uhiHipId: _uhiHipId).alignAtCenter()
        : ShareProfilePhrLinkDesktopView(
            shareHipId: _shareHipId,
            counterId: _counterId,
          ).alignAtCenter();
  }
}
