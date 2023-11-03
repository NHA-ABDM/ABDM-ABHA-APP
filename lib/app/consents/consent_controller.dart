import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class ConsentController extends BaseController {
  late ConsentRepo consentRepo;
  Map<String, List<dynamic>> requestedConsentMap = {};
  Map<String, List<dynamic>> approvedConsentMap = {};

  Map<String, List<dynamic>> requestedSubscriptionMap = {};
  Map<String, List<dynamic>> approvedSubscriptionMap = {};

  bool canFetchRequestedConsents = true;
  bool canFetchApprovedConsents = true;
  RxMap<String, bool> isRequestedViewPaginationInProgress = RxMap();
  RxMap<String, bool> isApprovedViewPaginationInProgress = RxMap();
  String requestedFilter = 'All';
  String approvedFilter = 'Granted';
  Map<String, Set<CareContexts?>> selectedHipContext = {};
  Map<String, Set<LinkFacilityCareContext?>> linkFacilityHipContext = {};
  List<LinkFacilityLinkedData?> linksFacilityData = [];
  List<LinkFacilityLinkedData?> selectedArtifactsLinks = [];
  ConsentRequestModel? consentRequest;
  late SubscriptionRequest? subscriptionRequest;
  late Subscription? subscription;
  List<ConsentArtefactModel?> consentArtefact = [];
  bool isRequestInProgress = false;
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);

  ConsentController(ConsentRepoImpl repo) : super(ConsentController) {
    consentRepo = repo;
  }

  List<ConsentRequestModel>? tempConsentList = [];
  List<ConsentSubscriptionRequestModel>? tempSubscriptionRequestList = [];

  Future<void> fetchRequestedConsentData({
    required String filter,
    bool shouldResetData = false,
  }) async {
    try {
      if (isRequestInProgress) return;
      isRequestInProgress = true;
      if (shouldResetData) resetData(filter);
      ConsentModel consentModel = ConsentModel();
      await _fetchRequestedConsentByFilter(
        filter: filter,
        consentModel: consentModel,
      );
      await _fetchRequestedSubscriptionByFilter(
        filter: filter,
        consentModel: consentModel,
      );

      requestedConsentMap[filter]?.addAll(consentModel.get());
      isRequestedViewPaginationInProgress[filter] = false;
    } catch (e) {
      abhaLog.d(e);
    } finally {
      isRequestInProgress = false;
    }
  }

  Future<void> fetchApprovedConsentData({
    required String filter,
    bool shouldResetData = false,
  }) async {
    try {
      if (isRequestInProgress) return;
      isRequestInProgress = true;
      if (shouldResetData) resetData(filter);
      ConsentModel consentModel = ConsentModel();
      await _fetchApprovedConsentByFilter(
        filter: filter,
        consentModel: consentModel,
      );
      await _fetchApprovedSubscriptionByFilter(
        filter: filter,
        consentModel: consentModel,
      );

      approvedConsentMap[filter]?.addAll(consentModel.get());
      isApprovedViewPaginationInProgress[filter] = false;
    } catch (e) {
      abhaLog.d(e);
    } finally {
      isRequestInProgress = false;
    }
  }

  /// Fetch Subscription for requested tab
  Future<void> _fetchRequestedSubscriptionByFilter({
    required String filter,
    required ConsentModel consentModel,
  }) async {
    try {
      int offset = 0;

      List<dynamic> consents = requestedConsentMap[filter] ?? [];
      if (consents.isNotEmpty) {
        isRequestedViewPaginationInProgress[filter] = true;
        offset = tempSubscriptionRequestList?.length ?? 0 + 1;
      } else {
        requestedConsentMap[filter] = [];
      }
      var response = await consentRepo.getSubscriptions(
        limit: 10,
        filters: filter,
        offset: offset,
      );
      if (Validator.isNullOrEmpty(response['requests']) ||
          !Validator.isNullOrEmpty(response['requests'][0]['error'])) {
        return;
      }
      ConsentGenericModel<ConsentSubscriptionRequestModel>
          lockerAndConsentResponse =
          consentModel.convertSubscriptionRequest(response);
      consentModel.subscriptions = lockerAndConsentResponse;
      tempSubscriptionRequestList?.addAll(lockerAndConsentResponse.requests);
    } catch (e) {
      abhaLog.d(e);
    } finally {
      isRequestInProgress = false;
    }
  }

  /// Fetch Consents for requested tab
  Future<void> _fetchRequestedConsentByFilter({
    required String filter,
    required ConsentModel consentModel,
  }) async {
    try {
      int offset = 0;
      List<dynamic> consents = requestedConsentMap[filter] ?? [];
      if (consents.isNotEmpty) {
        isRequestedViewPaginationInProgress[filter] = true;
        offset = consents.length + 1;
      } else {
        requestedConsentMap.clear();
      }
      var response = await consentRepo.getConsents(
        limit: 10,
        filters: filter,
        offset: offset,
      );
      if (Validator.isNullOrEmpty(response['requests']) ||
          !Validator.isNullOrEmpty(response['requests'][0]['error'])) {
        return;
      }

      ConsentGenericModel<ConsentRequestModel> lockerAndConsentResponse =
          consentModel.convertConsents(response);
      consentModel.consents = lockerAndConsentResponse;
      tempConsentList?.addAll(lockerAndConsentResponse.requests);
      abhaLog.e('praj');
      debugPrint('$response', wrapWidth: 1024);
    } catch (e) {
      abhaLog.d(e);
    } finally {
      isRequestInProgress = false;
    }
  }

  /// Fetch Consents for approved tab
  Future<void> _fetchApprovedConsentByFilter({
    required String filter,
    required ConsentModel consentModel,
  }) async {
    try {
      int offset = 0;
      List<dynamic> consents = approvedConsentMap[filter] ?? [];
      if (consents.isNotEmpty) {
        isApprovedViewPaginationInProgress[filter] = true;
        offset = consents.length + 1;
      } else {
        approvedConsentMap[filter] = [];
      }
      var response = await consentRepo.getConsents(
        limit: 10,
        filters: filter,
        offset: offset,
      );
      if (Validator.isNullOrEmpty(response['requests']) ||
          !Validator.isNullOrEmpty(response['requests'][0]['error'])) {
        return;
      }

      ConsentGenericModel<ConsentRequestModel> lockerAndConsentResponse =
          consentModel.convertConsents(response);
      consentModel.consents = lockerAndConsentResponse;
      tempConsentList?.addAll(lockerAndConsentResponse.requests);
    } catch (e) {
      abhaLog.d(e);
    }
  }

  /// Fetch Subscription for requested tab
  Future<void> _fetchApprovedSubscriptionByFilter({
    required String filter,
    required ConsentModel consentModel,
  }) async {
    try {
      int offset = 0;

      List<dynamic> consents = approvedConsentMap[filter] ?? [];
      if (consents.isNotEmpty) {
        isApprovedViewPaginationInProgress[filter] = true;
        offset = consents.length + 1;
      } else {
        approvedConsentMap[filter] = [];
      }
      var response = await consentRepo.getSubscriptions(
        limit: 10,
        filters: filter,
        offset: offset,
      );
      if (Validator.isNullOrEmpty(response['requests']) ||
          !Validator.isNullOrEmpty(response['requests'][0]['error'])) {
        return;
      }
      ConsentGenericModel<ConsentSubscriptionRequestModel>
          lockerAndConsentResponse =
          consentModel.convertSubscriptionRequest(response);
      consentModel.subscriptions = lockerAndConsentResponse;
      tempSubscriptionRequestList?.addAll(lockerAndConsentResponse.requests);
    } catch (e) {
      abhaLog.d(e);
    }
  }

  /// @Here fetch the Consent details by Id.
  /// param [id] String.
  Future<void> fetchConsentRequestById(String id) async {
    var response = await consentRepo.fetchConsentRequestById(requestId: id);
    consentRequest = ConsentRequestModel.fromJson(response ?? {});
    // transform the [links] object
    List<LinkFacilityLinkedData> tempListOfLinkFacilityLinkedData = [];
    consentRequest?.links?.forEach((element) {
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
    consentRequest?.links = tempListOfLinkFacilityLinkedData;

    for (LinkFacilityLinkedData link in consentRequest?.links ?? []) {
      linkFacilityHipContext[link.hip?.name ?? ''] =
          Set.from(link.careContexts ?? []);
    }
  }

  Future<SubscriptionRequest?> fetchSubscriptionByRequestId({
    required String subscriptionRequestId,
  }) async {
    var response = await consentRepo.fetchSubscriptionByRequestId(
      subscriptionRequestId: subscriptionRequestId,
    );
    subscriptionRequest = SubscriptionRequest.fromJson(response);
    return subscriptionRequest;
  }

  Future<Subscription?> fetchSubscriptionRequest({
    required String subscriptionId,
  }) async {
    var response =
        await consentRepo.fetchSubscription(subscriptionId: subscriptionId);
    subscription = Subscription.fromMap(response);
    return subscription;
  }

  Future<void> fetchLinkedFacility() async {
    linksFacilityData.clear();
    var response = await consentRepo.fetchLinks();
    String tempData = jsonEncode(response);
    LinkedFacilityModel linkedFacility = linkFacilityModelFromMap(tempData);
    linkedFacility.patient?.links?.forEach((element) {
      if (linksFacilityData.contains(element)) {
        int index = linksFacilityData.indexOf(element);
        linksFacilityData
            .elementAt(index)
            ?.careContexts
            ?.addAll(element.careContexts?.toList() ?? []);
      } else {
        linksFacilityData.add(element);
      }
    });
    initializeSelectedLinks();
  }

  void initializeSelectedLinks() {
    for (var link in linksFacilityData) {
      selectedHipContext[link?.hip?.name ?? ''] =
          Set.from(link?.careContexts ?? []);
    }
  }

  Future<Map<String, dynamic>> fetchProviderDetails(String id) async {
    var response = await consentRepo.callProviderDetailFetch(id);
    return response ?? {};
  }

  /// @Here function deny the consent request by passing id.
  /// Params used [id] of type String.
  Future<void> denyConsentRequest({required String id}) async {
    await consentRepo.denyConsent(requestId: id);
  }

  /// @Here This function is used to return the consent types.
  /// Param used [type] of type String.
  String getRequestType(String type) {
    if (type == ConsentStatus.requested) {
      return 'Requested';
    } else if (type == ConsentStatus.expired) {
      return 'Expired';
    } else if (type == ConsentStatus.denied) {
      return 'Denied';
    } else if (type == ConsentStatus.granted) {
      return 'Granted';
    } else if (type == ConsentStatus.revoked) {
      return 'Revoked';
    } else {
      return '';
    }
  }

  /// @Here This function is used to return the consent types.
  /// Param used [type] of type String.
  String getLocalizedRequestType(String type) {
    if (type == ConsentStatus.requested) {
      return LocalizationHandler.of().requested;
    } else if (type == ConsentStatus.expired) {
      return LocalizationHandler.of().expired;
    } else if (type == ConsentStatus.denied) {
      return LocalizationHandler.of().denied;
    } else if (type == ConsentStatus.granted) {
      return LocalizationHandler.of().granted;
    } else if (type == ConsentStatus.revoked) {
      return LocalizationHandler.of().revoked;
    } else {
      return '';
    }
  }

  /// @Here This function is used to return the consent types Color.
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

  /// @Here This function is used to return the consent types Images.
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

  /// @Here function returns the boolean true or false on
  /// the basis of selected Hip's
  bool allHipContextSelected() {
    int total = 0;
    int selected = 0;
    for (var element in linksFacilityData) {
      int len = element?.careContexts?.length ?? 0;
      total = total + len;
    }
    selectedHipContext.forEach((key, value) {
      selected = selected + value.length;
    });

    return selected == total;
  }

  /// @Here function returns the count of selected Hip's.
  int selectedHipContextCount() {
    int selected = 0;
    selectedHipContext.forEach((key, value) {
      selected = selected + value.length;
    });
    return selected;
  }

  int selectedLinkedHipContextCount() {
    int selected = 0;
    linkFacilityHipContext.forEach((key, value) {
      selected = selected + value.length;
    });
    return selected;
  }

  /// Approve consent using temporaryToken
  /// [tempToken] -> Token received after pin verification
  Future<dynamic> approveConsent(String consentReqId) async {
    var response = await consentRepo.approveConsent(
      request: {ApiKeys.requestKeys.consents: generateApproveConsentPayload()},
      requestId: consentReqId,
    );
    return response;
  }

  List<Map<String, dynamic>> generateApproveConsentPayload() {
    List<Map<String, dynamic>> payload = [];
    List<CareContexts> consents = [];
    List<String?>? hiTypes = [];

    /// add hiTypes
    hiTypes.addAll(
      consentRequest?.hiTypes?.where((e) => e.check).map((e) => e.name) ?? [],
    );

    if (!Validator.isNullOrEmpty(consentRequest?.links)) {
      for (LinkFacilityLinkedData data in consentRequest!.links!) {
        if (linkFacilityHipContext.containsKey(data.hip?.name) &&
            linkFacilityHipContext[data.hip?.name]!.isNotEmpty) {
          List<CareContexts?> tempSelectedHipsContext = [];

          for (LinkFacilityCareContext? context
              in linkFacilityHipContext[data.hip?.name]!.toList()) {
            if (context != null) {
              tempSelectedHipsContext.add(
                CareContexts(
                  careContextReference: context.referenceNumber,
                  patientReference: data.referenceNumber,
                ),
              );
            }
          }

          payload.add({
            ApiKeys.requestKeys.careContexts: List<dynamic>.from(
              tempSelectedHipsContext.map((e) => e?.toJson()),
            ),
            ApiKeys.requestKeys.hiTypes: hiTypes,
            ApiKeys.requestKeys.hip: data.hip!.toMap(),
            ApiKeys.requestKeys.permission: consentRequest?.permission?.toJson()
          });
        }
      }
    } else {
      /// add request into the payload
      List<CareContexts?> tempSelectedHipsContext =
          selectedHipContext[consentRequest?.hip?.name]?.toList() ?? [];

      payload.add({
        ApiKeys.requestKeys.careContexts:
            List<dynamic>.from(tempSelectedHipsContext.map((e) => e?.toJson())),
        ApiKeys.requestKeys.hiTypes: hiTypes,
        ApiKeys.requestKeys.hip: consentRequest?.hip?.toMap(),
        ApiKeys.requestKeys.permission: consentRequest?.permission?.toJson()
      });
    }

    abhaLog.i('Grant consent payload is $payload');
    return payload;
  }

  Future<List<ConsentArtefactModel>> fetchConsentArtifacts(String id) async {
    var response = await consentRepo.getConsentArtefacts(id: id);
    List<ConsentArtefactModel> artefact = List<ConsentArtefactModel>.from(
      response.map((e) => ConsentArtefactModel.fromJson(e)),
    );
    initializeSelectedArtefacts(artefact);
    return artefact;
  }

  void initializeSelectedArtefacts(List<ConsentArtefactModel?>? artefacts) {
    selectedHipContext.clear();
    selectedArtifactsLinks.clear();
    for (var link in linksFacilityData) {
      List<LinkFacilityCareContext> linkContext = link?.careContexts ?? [];
      List<LinkFacilityCareContext> tempLinkContext = [];

      ConsentArtefactModel? artefact = artefacts?.firstWhereOrNull((e) {
        if (e?.consentDetail?.hip?.id == link?.hip?.id) {
          consentRequest?.hip = Hip(id: link?.hip?.id);

          return true;
        }
        return false;
      });

      for (var context in linkContext) {
        CareContexts? tempContexts =
            artefact?.consentDetail?.careContexts?.firstWhereOrNull(
          (element) => element.careContextReference == context.referenceNumber,
        );
        if (tempContexts != null) {
          tempLinkContext.add(context);
        }
      }
      if (tempLinkContext.isNotEmpty) {
        selectedArtifactsLinks.add(
          LinkFacilityLinkedData(
            hip: link?.hip,
            careContexts: tempLinkContext,
            referenceNumber: link?.referenceNumber,
          ),
        );
      }
    }
  }

  Future<dynamic> revokeConsent(String consentId) async {
    List consentIdList = [];
    consentIdList.add(consentId);
    var response = await consentRepo.revokeConsent(
      revokeConsentRequest: {ApiKeys.requestKeys.consents: consentIdList},
    );
    return response;
  }

  // String getAddedDateTime(String dateTime) {
  //   DateTime date = DateTime.parse(dateTime).toLocal();
  //   return date.getAddedDateTime(date.toString());
  // }

  /// @Here function to display not available consent message according to
  /// different status.
  /// Params used [type] of type String.
  String getEmptyListMessage(String type) {
    if (type == ConsentStatus.requested) {
      return LocalizationHandler.of().noRequest;
    } else if (type == ConsentStatus.expired) {
      return LocalizationHandler.of().noExpiredRequest;
    } else if (type == ConsentStatus.denied) {
      return LocalizationHandler.of().noDeniedRequest;
    } else {
      return LocalizationHandler.of().noDataAvailable;
    }
  }

  /// @Here function to display not available consent message according to
  /// different status.
  /// Params used [type] of type String.
  String getApprovedEmptyListMessage(String type) {
    if (type == ConsentStatus.granted) {
      return LocalizationHandler.of().noGrantedRequest;
    } else if (type == ConsentStatus.expired) {
      return LocalizationHandler.of().noExpiredRequest;
    } else if (type == ConsentStatus.revoked) {
      return LocalizationHandler.of().noRevokedRequest;
    } else {
      return '';
    }
  }

  void resetData(String filter) {
    requestedConsentMap[filter]?.clear();
    approvedConsentMap[filter]?.clear();

    // tempConsentList?.clear();
    // tempSubscriptionRequestList?.clear();
  }

  List<dynamic> getFilteredList({required List<dynamic> consents}) {
    List<dynamic> filteredConsents = [];
    // List<dynamic> consents1 =
    //     _consentController.requestedConsentMap[ConsentStatus.all] ?? [];
    if (!Validator.isNullOrEmpty(consents)) {
      for (dynamic data in consents) {
        if (data is ConsentRequestModel) {
          ConsentRequestModel request = data;
          if (!Validator.isNullOrEmpty(request.requester?.name) &&
              request.requester?.name! != 'SELF') {
            filteredConsents.add(data);
          }
        }
      }
    }
    return filteredConsents;
  }
}
