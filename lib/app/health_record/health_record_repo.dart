import 'package:abha/export_packages.dart';

abstract class HealthRecordRepo {
  Future<Map> callPatientsLinkedHip();

  Future<Map> callConsentRequest(Map consentData);

  Future<Map> callHealthInformationStatus(Map healthInformationStatusData);

  Future<Map> callHealthInformationFetch(Map healthInformationFetchData);

  Future<dynamic> callDownloadFile(String consentId, String url);
}

class HealthRecordRepoImpl extends BaseRepo implements HealthRecordRepo {
  HealthRecordRepoImpl() : super(HealthRecordRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<Map> callPatientsLinkedHip() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.healthInformationLinkHipApi,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> callConsentRequest(Map consentData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.healthInformationConsentRequestApi,
      dataPayload: consentData,
      options: Options(
        headers: {
          ApiKeys.headersKeys.requesterId:
              abhaSingleton.getAppData.getAbhaAddress()
        },
      ),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> callHealthInformationStatus(
    Map healthInformationStatusData,
  ) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.healthInformationStatusApi,
      dataPayload: healthInformationStatusData,
      options: Options(
        headers: {
          ApiKeys.headersKeys.requesterId:
              abhaSingleton.getAppData.getAbhaAddress()
        },
      ),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> callHealthInformationFetch(Map healthInformationFetchData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.healthInformationFetchApi,
      dataPayload: healthInformationFetchData,
      options: Options(
        headers: {
          ApiKeys.headersKeys.requesterId:
              abhaSingleton.getAppData.getAbhaAddress()
        },
      ),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> callDownloadFile(String consentId, String url) async {
    Map appConfigData = abhaSingleton.getAppConfig.getConfigData();
    if (appConfigData[AppConfig.flavorName] == '') {
      apiProvider.updateBaseUrl('');
    } else {
      apiProvider.updateBaseUrl('');
    }
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      ignoreHeaders: true,
      url: '$consentId$url',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          ApiKeys.headersKeys.xAuthToken: 'Bearer ${apiProvider.xToken}',
        },
      ),
    );
    apiProvider.updateBaseUrl(appConfigData[AppConfig.baseUrl]);
    return Future.value(response?.data ?? {});
  }
}
