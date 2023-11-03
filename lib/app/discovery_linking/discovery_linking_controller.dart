import 'dart:math';

import 'package:abha/app/discovery_linking/discovery_linking_repo.dart';
import 'package:abha/app/discovery_linking/model/care_context_req_model.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:uuid/uuid.dart';

class DiscoveryLinkingController extends BaseController {
  late DiscoveryLinkingRepoImpl _discoveryLinkingRepoImpl;
  Map discoveryRespData = {};
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
  final ValueNotifier<bool> isButtonEnable = ValueNotifier(false);
  final patientIdTEC = AppTextController();
  final deBouncer = Debouncer(delay: const Duration(seconds: 1));
  List careContextData = [];
  bool isGovtProgramVisible = true;

  DiscoveryLinkingController(DiscoveryLinkingRepoImpl repo)
      : super(DiscoveryLinkingController) {
    _discoveryLinkingRepoImpl = repo;
  }

  /// @Here function returns Images on the basis of id. Params used :-
  ///     [id] of type String.
  String checkImageType(String id) {
    return id.toLowerCase().contains('pmjay')
        ? ImageLocalAssets.abPmJay
        : id.toLowerCase().contains('cowinsit')
            ? ImageLocalAssets.cownin
            : id.toLowerCase().contains('rch_hip')
                ? ImageLocalAssets.reProdChildHealth
                : id.toLowerCase().contains('sanjeevani')
                    ? ImageLocalAssets.sanjeevani
                    : id.toLowerCase().contains('sanjeevani_opd')
                        ? ImageLocalAssets.sanjeevaniOpd
                        : ImageLocalAssets.healthFacility;
  }

  Future<void> getGovtProgram() async {
    isGovtProgramVisible = true;
    List tempData = await _discoveryLinkingRepoImpl.callGovtProgram();
    String govtProgramData = jsonEncode(tempData);
    tempResponseData = providerModelFromMap(govtProgramData);
  }

  Future<void> getSearchHip(String hipName) async {
    isGovtProgramVisible = false;
    var reqData = {
      ApiKeys.requestKeys.name: hipName,
      ApiKeys.requestKeys.limit: 20,
      ApiKeys.requestKeys.offset: 0,
    };
    List tempData = await _discoveryLinkingRepoImpl.callSearchHip(reqData);
    String searchedHipsData = jsonEncode(tempData);
    tempResponseData = providerModelFromMap(searchedHipsData);
  }

  Future<void> getDiscoverHip(
    String hipName,
    String hipId,
    ProfileModel? profileModel,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) async {
    var requestId = const Uuid().v4();
    Map reqData = _createDiscoverHipReq(hipName, hipId, profileModel);
    _discoveryLinkingRepoImpl.callDiscoverHip(reqData, requestId, callBackFunc);
  }

  void getDiscoverHipResponseHandler(
    ApiSocketLocalResponseModel responseModel,
  ) {
    tempResponseData = jsonDecode(responseModel.data ?? '');
    if (!Validator.isNullOrEmpty(tempResponseData)) {
      List patientData = tempResponseData[ApiKeys.responseKeys.patient];
      careContextData =
          patientData.elementAt(0)[ApiKeys.responseKeys.careContexts];
      discoveryRespData = tempResponseData;
    }
  }

  Future<void> getLinkHip(
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) async {
    var requestId = const Uuid().v4();
    Map reqData = _createLinkHipReq();
    _discoveryLinkingRepoImpl.callLinkHip(reqData, requestId, callBackFunc);
  }

  Future<void> getLinkConfirmHip(
    String otp,
    String referenceNumber,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) async {
    var requestId = const Uuid().v4();
    var reqData = {
      ApiKeys.requestKeys.token: otp,
      ApiKeys.requestKeys.linkRefNumber: referenceNumber
    };
    _discoveryLinkingRepoImpl.callLinkConfirmHip(
      reqData,
      requestId,
      callBackFunc,
    );
  }

  /// @Here function returns the map request. Params used:-
  ///    [hipName] of type String.
  ///    [hipId] of type String.
  Map _createDiscoverHipReq(
    String hipName,
    String hipId,
    ProfileModel? profileModel,
  ) {
    Random random = Random();
    int randomNumber2 = random.nextInt(1000000000) + 1;
    var data = {
      ApiKeys.requestKeys.hip: {
        ApiKeys.requestKeys.id: hipId,
      },
      ApiKeys.requestKeys.unverifiedIdentifiers: [
        {
          ApiKeys.requestKeys.type: 'MOBILE',
          ApiKeys.requestKeys.value: randomNumber2 * 10,
        }
      ],
    };
    return data;
  }

  void addCareContext(List<CareContextReqModel> tempCareContextDataModel) {
    List tempData = [];
    for (int i = 0; i < tempCareContextDataModel.length; i++) {
      if (tempCareContextDataModel.elementAt(i).isCheck) {
        var data = {
          'referenceNumber':
              tempCareContextDataModel.elementAt(i).referenceNumber,
          'display': tempCareContextDataModel.elementAt(i).display,
        };
        tempData.add(data);
      }
    }
    careContextData = tempData;
  }

  Map _createLinkHipReq() {
    Map patientRecord =
        discoveryRespData[ApiKeys.responseKeys.patient].elementAt(0);
    Map patientData = {
      'referenceNumber': patientRecord[ApiKeys.responseKeys.referenceNumber],
      'display': patientRecord[ApiKeys.responseKeys.display],
      'careContexts': careContextData,
      'hiType': patientRecord[ApiKeys.requestKeys.hiType],
      'count': careContextData.length,
    };
    Map responseData = {
      'requestId': discoveryRespData['response'][ApiKeys.requestKeys.requestId],
    };
    Map reqData = {
      'transactionId': discoveryRespData[ApiKeys.requestKeys.transactionId],
      'patient': [patientData],
      'response': responseData,
    };
    return reqData;
  }
}
