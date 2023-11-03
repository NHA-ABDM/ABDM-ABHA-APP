import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/app/health_locker/model/health_locker_subscription_model.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

enum UpdateLockerBuilderIds {
  connectedLockerList,
  allLockersList,
  // healthLockerInfoSection,
  healthLockerInfoSubItem,
  authorizationRequest,
  subscriptionRequest,
  subTypeVisitRequest,
  // recordDataRequest,
}

enum Categories { link, data }

class HealthLockerController extends BaseController {
  late HealthLockerRepo healthLockerRepo;
  List<HealthLockerConnectedModel>? connectedLockers;
  HealthLockerInfoModel? healthLockerInfoModel;
  List<ProviderModel>? allLockers;
  Authorization? authorization;
  Subscription? subscription;
  HealthLockerSubscriptionModel subscriptionModel =
      HealthLockerSubscriptionModel();
  SubscriptionIncludedSource? includeSourceRequest;
  List<String?> listHipName = [];
  bool isOptionAllSelected = false;
  String? hipName;
  List<LinkFacilityLinkedData?> linksFacilityData = [];

  HealthLockerController(HealthLockerRepoImpl repo)
      : super(HealthLockerController) {
    healthLockerRepo = repo;
  }

  Future<void> getConnectedLockers() async {
    var lockerTempRespData = await healthLockerRepo.callConnectedLockerList();
    String tempData = jsonEncode(lockerTempRespData);
    connectedLockers =
        healthLockerConnectedModelFromMap(tempData).toSet().toList();
  }

  Future<void> getAllLockers() async {
    var lockerTempRespData = await healthLockerRepo.callAllLockerList();
    String tempData = jsonEncode(lockerTempRespData);
    allLockers = providerModelFromMap(tempData);
  }

  Future<void> getAddLocker() async {
    abhaSingleton.getApiProvider.updateBaseUrl('');
    tempResponseData = await healthLockerRepo.addLocker();
    abhaSingleton.getApiProvider.updateBaseUrl(
      abhaSingleton.getAppConfig.getConfigData()[AppConfig.baseUrl],
    );
  }

  Future<void> fetchLinkedFacility() async {
    linksFacilityData.clear();
    var response = await healthLockerRepo.fetchLinks();
    String tempData = jsonEncode(response);
    LinkedFacilityModel linkedFacilityModel = tempData == 'null'
        ? LinkedFacilityModel()
        : linkFacilityModelFromMap(tempData);

    List<LinkFacilityLinkedData> tempListOfLinkFacilityLinkedData =
        mergeDuplicateHipDetails(linkedFacilityModel);

    linkedFacilityModel.patient?.links = tempListOfLinkFacilityLinkedData;
    linksFacilityData = linkedFacilityModel.patient?.links ?? [];
  }

  List<LinkFacilityLinkedData> mergeDuplicateHipDetails(
    LinkedFacilityModel linkedFacilityModel,
  ) {
    List<LinkFacilityLinkedData> tempListOfLinkFacilityLinkedData = [];
    linkedFacilityModel.patient?.links?.forEach((element) {
      if (tempListOfLinkFacilityLinkedData.contains(element)) {
        int index = tempListOfLinkFacilityLinkedData.indexOf(element);
        tempListOfLinkFacilityLinkedData
            .elementAt(index)
            .careContexts
            ?.addAll(element.careContexts?.toList() ?? []);
      } else {
        tempListOfLinkFacilityLinkedData.add(element);
      }
    });
    return tempListOfLinkFacilityLinkedData;
  }

  Future<void> getLockerInfo(String lockerId) async {
    var healthLockerInfoTempRespData =
        await healthLockerRepo.callIndividualLockerInfoAPI(lockerId);
    String tempData = jsonEncode(healthLockerInfoTempRespData);
    healthLockerInfoModel = healthLockerInfoModelFromMap(tempData);
  }

  Future<void> getChangeAutoApprovePolicy(
    String autoApproveId,
    bool enable,
  ) async {
    tempResponseData =
        await healthLockerRepo.changeAutoApprovalPolicy(autoApproveId, enable);
  }

  Future<Authorization?> getAuthorizationRequestDetail(
    String authRequestId,
  ) async {
    var response = await healthLockerRepo.getAuthorizationDetail(authRequestId);
    authorization = Authorization.fromMap(response);
    return authorization;
  }

  Future<void> getRevokedAuthRequest(String revokedRequestID) async {
    tempResponseData =
        await healthLockerRepo.getRevokedAuthRequest(revokedRequestID);
  }

  Future<Subscription?> getSubscriptionRequestDetail(
    String subscriptionRequestID,
  ) async {
    var response =
        await healthLockerRepo.getSubscriptionDetail(subscriptionRequestID);
    subscription = Subscription.fromMap(response);
    subscriptionModel.subscriptionEditAndApprovalRequest =
        SubscriptionEditAndApprovalRequest(
      includedSources: subscription?.includedSources,
    );

    listHipName = [];

    for (var link in linksFacilityData) {
      if (!isHIPIdMatches(link?.hip?.id)) {
        /// If link hip id not matches [returns false]
        subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
            ?.add(
          SubscriptionIncludedSource(
            hiTypes: [],
            hip: Hiu(
              id: link?.hip?.id,
              name: link?.hip?.name,
              type: StringConstants.hip,
            ),
            categories: [],
            purpose: includedSourcePurpose(),
            status: ConsentStatus.granted,
            period: PeriodHealthLocker(
              from: DateTime.now(),
              to: DateTime.now(),
            ),
          ),
        );
      } else {
        isOptionAllSelected = false;
        listHipName.add(link?.hip?.name);
        subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
            ?.forEach((element) {
          if (element.hip?.id == link?.hip?.id) {
            element.hip = Hiu(
              id: link?.hip?.id,
              name: link?.hip?.name,
              type: StringConstants.hip,
            );
            element.purpose = includedSourcePurpose();
            element.period = PeriodHealthLocker(
              from: element.period?.from,
              to: element.period?.to,
            );
          }
        });
      }
    }

    bool isAllAvailable = false;
    subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.forEach((element) {
      if (Validator.isNullOrEmpty(element.hip?.id)) {
        isAllAvailable = true;

        /// If Hip Id is Null then add name 'All' in HIP
        subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
            ?.forEach((element) {
          if (element.hip?.id == null) {
            element.hip = Hiu(name: 'All', type: StringConstants.hip);
            element.purpose = includedSourcePurpose();
            element.hiTypes = List.from(hiTypesCode);
          }
        });
        listHipName.add('All');
        isOptionAllSelected = true;
      }
    });

    /// if boolean 'isAllAvailable' is false, i.e {hip Id is not null} .
    /// Add the SubscriptionIncludedSource() into subscriptionModel.
    if (!isAllAvailable) {
      /// Add for 'All' Option
      subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
          ?.add(
        SubscriptionIncludedSource(
          hiTypes: [],
          hip: Hiu(id: null, name: 'All', type: StringConstants.hip),
          categories: [],
          purpose: includedSourcePurpose(),
          status: ConsentStatus.granted,
          period: PeriodHealthLocker(
            from: DateTime.now(),
            to: DateTime.now(),
          ),
        ),
      );
    }
    return subscription;
  }

  /// @Here is function to set Purpose into the subscription item
  IncludedSourcePurpose includedSourcePurpose() => IncludedSourcePurpose(
        code: StringConstants.patrqt,
        refUri: 'www.abdm.gov.in',
        text: StringConstants.selfRequested,
      );

  /// @Here is the function to remove the unselected item from subscription model
  void removeUnSelectedItemFromModel() {
    subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.removeWhere(
      (element) =>
          !listHipName.contains('All') &&
          Validator.isNullOrEmpty(element.hip?.name),
    );
    subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.removeWhere((element) => !listHipName.contains(element.hip?.name));
  }

  /// @Here is the function to call the api for edit subscription
  /// params [subscriptionID] String and [mapData] String
  Future<void> getEditSubscription(String subscriptionID, var mapData) async {
    tempResponseData = await healthLockerRepo
        .updateSubscriptionDetail(subscriptionID, request: mapData);
  }

  String getRequestType(String type) {
    if (type == ConsentStatus.requested) {
      return ConsentStatus.requested.capitalizeFirstLetter;
    } else if (type == ConsentStatus.expired) {
      return ConsentStatus.expired.capitalizeFirstLetter;
    } else if (type == ConsentStatus.denied) {
      return ConsentStatus.denied.capitalizeFirstLetter;
    } else if (type == ConsentStatus.granted) {
      return ConsentStatus.granted.capitalizeFirstLetter;
    } else if (type == ConsentStatus.revoked) {
      return ConsentStatus.revoked.capitalizeFirstLetter;
    } else {
      return '';
    }
  }

  /// Param used [type] of type String.
  Color getRequestTypeColor(String type) {
    if (type == ConsentStatus.requested) {
      return kIsWeb ? AppColors.colorBlueLight10 : AppColors.colorAppBlue;
    } else if (type == ConsentStatus.expired) {
      return AppColors.colorGreyDark1;
    } else if (type == ConsentStatus.denied) {
      return kIsWeb ? AppColors.colorDarkRed4 : AppColors.colorDarkRed1;
    } else if (type == ConsentStatus.granted) {
      return kIsWeb ? AppColors.colorGreenDark3 : AppColors.colorGreen;
    } else if (type == ConsentStatus.revoked) {
      return kIsWeb ? AppColors.colorDarkRed4 : AppColors.colorDarkRed1;
    } else {
      return AppColors.colorBlueLight10;
    }
  }

  /// Param used [type] of type String.
  Color getRequestTypeBackgroundColor(String type) {
    if (type == ConsentStatus.requested) {
      return AppColors.colorGreyLight8;
    } else if (type == ConsentStatus.expired) {
      return AppColors.colorGreyLight8;
    } else if (type == ConsentStatus.denied) {
      return AppColors.colorRedLight6;
    } else if (type == ConsentStatus.granted) {
      return AppColors.colorGreenLight2;
    } else if (type == ConsentStatus.revoked) {
      return AppColors.colorRedLight6;
    } else {
      return AppColors.colorGreyLight8;
    }
  }

  /// Param used [type] of type String.
  String getRequestTypeImage(String type) {
    if (type == ConsentStatus.requested) {
      return ImageLocalAssets.consentRequested;
    } else if (type == ConsentStatus.expired) {
      return ImageLocalAssets.consentExpired;
    } else if (type == ConsentStatus.denied) {
      return ImageLocalAssets.consentDenied;
    } else if (type == ConsentStatus.granted) {
      return ImageLocalAssets.consentGranted;
    } else if (type == ConsentStatus.revoked) {
      return ImageLocalAssets.consentExpired;
    } else {
      return ImageLocalAssets.consentRequested;
    }
  }

  bool isAuthRevoked() {
    bool isRevoked = false;
    if (authorization?.status == 'REVOKED') {
      isRevoked = true;
    }
    return isRevoked;
  }

  /// IF subscription HIP ID matches with the patients HIP ID
  /// param [hipId] String
  /// returns [hipMatch] boolean
  bool isHIPIdMatches(String? hipId) {
    bool hipMatch = false;
    subscription?.includedSources?.forEach((element) {
      if (element.hip?.id == hipId) {
        hipMatch = true;
      }
    });
    return hipMatch;
  }

  /// If HIP ID is null in Subscription then set [hipMatch] to true
  /// and enable the checkbox of option "ALL". And if ID is not null then set[hipMatch]
  /// to false and disable the checkbox of Option "ALL".
  /// return [hipMatch] boolean
  bool isHIPIdNullInSubscription() {
    bool hipMatch = false;
    String? id = subscriptionModel
        .subscriptionEditAndApprovalRequest?.includedSources?[0].hip?.id;
    if (Validator.isNullOrEmpty(id)) {
      hipMatch = true;
    }
    return hipMatch;
  }
}
