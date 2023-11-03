import 'package:abha/app/share_profile/share_profile_link_model.dart';
import 'package:abha/app/share_profile/share_profile_repo.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:abha/utils/common/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class ShareProfileController extends BaseController {
  late ShareProfileRepo _shareProfileRepo;
  String? hipName;
  WebBrowserInfo? webBrowserInfo;
  List<ShareProfileDataList> shareProfileLinkDataList = [];
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  ShareProfileController(ShareProfileRepoImpl repo)
      : super(ShareProfileController) {
    _shareProfileRepo = repo;
  }

  /// @Here function provides the detail information of user on the basis of hipId
  /// Params [hipId] of type String.
  Future<void> getProviderDetails(String hipId) async {
    tempResponseData = await _shareProfileRepo.callProviderDetailFetch(hipId);
    var data = tempResponseData;
    Map? hipData = data is Map ? data : null;
    hipName =
        hipData?[ApiKeys.responseKeys.identifier][ApiKeys.responseKeys.name];
  }

  Future<void> getPatientProfileShare(
    String hipId,
    String counterId,
    LocationData? location,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) async {
    var requestId = const Uuid().v4();
    Map reqData =
        _shareProfileRequestData(hipId, counterId, location, requestId);
    _shareProfileRepo.callPatientProfileShare(reqData, requestId, callBackFunc);
  }

  /// @Here function shareProfileRequestData() returns data of type Future<Map>.
  /// This function is used to make a request data of latitude, longitude, requestId, hipId
  /// and CounterId.
  /// Params [hipId] and [counterId] of type String and
  /// Params [location] of type Position.
  Map _shareProfileRequestData(
    String? hipId,
    String? counterId,
    LocationData? location,
    String requestId,
  ) {
    /// TO-IMPLEMENT: correct this req body
    ProfileController profileController = Get.find<ProfileController>();
    var hipData = {
      ApiKeys.requestKeys.intent:
          ApiKeys.requestValues.patientShare, // PAYMENT_SHARE
      ApiKeys.requestKeys.metaData: {
        ApiKeys.requestKeys.hipId: hipId,
        ApiKeys.requestKeys.context: counterId, // from provider
        ApiKeys.requestKeys.hprId: 'testdoctor@phr', // from qr code
        ApiKeys.requestKeys.latitude: location?.latitude.toString(),
        ApiKeys.requestKeys.longitude: location?.longitude.toString(),
        // ApiKeys.requestKeys.latitude: '-31.678',
        // ApiKeys.requestKeys.longitude: '51.498',
      },
      ApiKeys.requestKeys.profile: {
        ApiKeys.requestKeys.patient: {
          ApiKeys.requestKeys.abhaNumber:
              profileController.profileModel?.abhaNumber,
          ApiKeys.requestKeys.abhaAddress:
              profileController.profileModel?.abhaAddress,
          ApiKeys.requestKeys.name: profileController.profileModel?.fullName,
          ApiKeys.requestKeys.gender: profileController.profileModel?.gender,
          ApiKeys.requestKeys.dayOfBirth:
              profileController.profileModel?.dateOfBirth?.date,
          ApiKeys.requestKeys.monthOfBirth:
              profileController.profileModel?.dateOfBirth?.month,
          ApiKeys.requestKeys.yearOfBirth:
              profileController.profileModel?.dateOfBirth?.year,
          ApiKeys.requestKeys.phoneNumber:
              profileController.profileModel?.mobile,
          ApiKeys.requestKeys.address: {
            ApiKeys.requestKeys.pinCode:
                profileController.profileModel?.pinCode,
            ApiKeys.requestKeys.line: profileController.profileModel?.address,
            ApiKeys.requestKeys.districtName:
                profileController.profileModel?.districtName,
            ApiKeys.requestKeys.stateName:
                profileController.profileModel?.stateName,
          },
        },
      },
    };
    return hipData;
  }

  Future<void> getLocalJsonData(
    BuildContext context,
    String localFilePath,
  ) async {
    String data =
        await DefaultAssetBundle.of(context).loadString(localFilePath);
    final shareProfileLinkData = shareProfileLinkModelFromMap(data);
    shareProfileLinkDataList = shareProfileLinkData.dataList;
    await _getBrowserDetail();
  }

  Future<void> _getBrowserDetail() async {
    webBrowserInfo = await CustomDeviceInfo.getWebPlatFormDetail();
  }

  void launchUrlHandler(
    String link, {
    Map<String, dynamic>? uhiQueryParam,
    Map<String, dynamic>? shareQueryParam,
  }) {
    Uri pushUriLink = Uri();
    if (link.contains(StringConstants.google) ||
        link.contains(StringConstants.apple)) {
      pushUriLink = Uri.parse(link);
    } else {
      pushUriLink = Uri.parse(link)
          .replace(queryParameters: uhiQueryParam ?? shareQueryParam);
    }
    abhaLog.e(pushUriLink);
    if (pushUriLink.isAbsolute) {
      _launchURLService.launchInBrowserLink(pushUriLink);
    } else {
      MessageBar.showToastError(LocalizationHandler.of().invalidUrl);
    }
  }

  bool getKyc(ProfileModel profileModel) {
    return profileModel.kycStatus == 'VERIFIED' ? true : false;
  }
}
