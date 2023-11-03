import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';
import 'package:uuid/uuid.dart';

enum APIMethod { post, get, delete, download, put, patch }

class ApiProvider {
  final abhaLog = customLogger(ApiProvider);
  Dio? _dio;
  final BaseOptions _dioOptions = BaseOptions();
  late CancelToken _cancelToken;
  late Map _configData;
  late String _baseUrl;
  final String _headerSuffix = 'Bearer';
  String xToken = '';
  String xAuthToken = '';

  Future<void> initApiDetails() async {
    _configData = abhaSingleton.getAppConfig.getConfigData();
    _baseUrl = _configData[AppConfig.baseUrl];
    try {
      _cancelToken = CancelToken();
      _dioOptions.baseUrl = _baseUrl;
      _dioOptions.responseType = ResponseType.json;
      _dioOptions.connectTimeout = const Duration(milliseconds: 200000);
      _dioOptions.receiveTimeout = const Duration(milliseconds: 200000);
      _dio = Dio(_dioOptions);
      // await sendSecureHTTPSRequest();
      await _addRHeaderToken();
      kDebugMode ? _initInterceptors() : null;
    } catch (e) {
      abhaLog.e('initApiDetails exception is ${e.toString()}');
    }
  }

  // Future<void> sendSecureHTTPSRequest() async {
  //   // Obtain the raw byte data of the client & root CA certificates and private key file contents
  //   ByteData rootCACertificate =
  //       await rootBundle.load("assets/keys/ca.pem"); // take from backend
  //   // ByteData clientCertificate = await rootBundle.load("assets/keys/cert.pem");   // take from backend
  //   // ByteData privateKey = await rootBundle.load("assets/keys/key.pem");   // take from backend
  //
  //   (dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {

  //     // ----------------first way (accept any certificate so we need to verify it)--------------------
  //     // String publicKeyPem =
  //     //     "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7Zq7YKcjmccSBnR9CDHd6IX96V7D/a2XSMs+yCgejSe956mqjA/0Q9h+Xnx7ZZdwe2Tf2Jq/mWXa+gYdnta58otreXg/5oGnNV3Edlixz1Oc8tJg5bG4sIUCGZcbEQGSbm1iC+Fp1kS+YLVG4Su8KoRxcCvRJI2QkfqAruX3JoFjggOkv0TgWCo9z6NV6PPmPN3UsXyH3OPDi3Ewnvd64ngCUKPSBiIDwhLj2yYSShcxH8aWbrz00SJodBJzqgjvCfZuljBXXIN4Ngi/nzqEJ7woKQ1kNgWoHFZy7YL74PihW//4OlniSRoITX+7ChILIv2ezSmAdIjpNJ9Dg9XKcQIDAQAB";
  //     // client.badCertificateCallback =
  //     //     (X509Certificate cert, String host, int port) {
  //     //   abhaLog.i(client);
  //     //   abhaLog.i(cert.pem);
  //     //   if (cert.pem == publicKeyPem) {
  //     //     // Verify the certificate
  //     //     return true;
  //     //   }
  //     //   return false;
  //     // };
  //
  //     // ------------------- second way (accept our signed certificate)----------------------
  //     SecurityContext context = SecurityContext(withTrustedRoots: true);
  //     context
  //         .setTrustedCertificatesBytes(rootCACertificate.buffer.asUint8List());
  //     // context.useCertificateChainBytes(clientCertificate.buffer.asUint8List());
  //     // context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
  //     HttpClient httpClient = HttpClient(context: context);
  //     abhaLog.i(httpClient);
  //     return httpClient;
  //   };
  // }

  void _initInterceptors() {
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          abhaLog.i(
            '******************************  START CALL   *************************************',
          );
          abhaLog.i(
            'REQUEST => [${requestOptions.method}]  PATH: ${requestOptions.baseUrl}${requestOptions.path}',
          );
          if (!Validator.isNullOrEmpty(requestOptions.headers)) {
            // abhaLog.i('REQUEST => HEADERS: ${requestOptions.headers}');
            abhaLog.i('REQUEST => HEADERS:');
            requestOptions.headers.forEach((key, value) {
              abhaLog.i('$key: $value');
            });
          }
          if (!Validator.isNullOrEmpty(requestOptions.queryParameters)) {
            abhaLog.i(
              'REQUEST => QUERYPARAMETER: ${requestOptions.queryParameters}',
            );
          }
          if (!Validator.isNullOrEmpty(requestOptions.data)) {
            abhaLog.i('REQUEST => BODY: ${requestOptions.data}');
          }
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          abhaLog
              .i('RESPONSE => [${response.statusCode}] =>  ${response.data}');
          abhaLog.i(
            '##############################  END SUCCESS  ######################################\n',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          if (Validator.isTestRunning()) {
            error.response?.statusCode = 200;
            error.response?.data = {};
            return handler.resolve(error.response!);
          }

          abhaLog.i(
            "ERROR => [${error.response?.statusCode}] =>  ${error.response?.data}'",
          );
          abhaLog.i(
            '------------------------------  END ERROR   -------------------------------------\n',
          );
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> updateBaseUrl(String baseUrl) async {
    _dioOptions.baseUrl = baseUrl;
    _dio?.options = _dioOptions;
  }

  // R-token -> refresh token with 15 days validity which is used to get the x-token when app is opened
  Future<void> _addRHeaderToken() async {
    String rToken = await abhaSingleton.getSharedPref
        .get(SharedPref.apiRHeaderToken, defaultValue: '');
    Validator.isNullOrEmpty(rToken) ? null : setHeaderToken(rToken: rToken);
  }

  // T-token -> temporary token with 5 mnt validity which is used after otp verification
  void addTHeaderToken(Map tempResponseData) {
    String tToken = tempResponseData[ApiKeys.responseKeys.tokens]
        [ApiKeys.responseKeys.token];
    setHeaderToken(tToken: tToken);
  }

  // Authorization -> temporary session token with 5 mnt validity which is used for ABHA-ID apis
  // void addAHeaderToken(Map tempResponseData) {
  //   String authToken = tempResponseData[ApiKeys.responseKeys.accessToken];
  //   setHeaderToken(authToken: authToken);
  // }

  // X-Auth-Token -> permanent token with 30 mnt validity which is used for HIE_CM apis
  void addXAuthHeaderToken(Map tempResponseData) {
    String xAuthToken = tempResponseData[ApiKeys.responseKeys.token];
    this.xAuthToken = xAuthToken;
    setHeaderToken(xAuthToken: xAuthToken);
  }

  // X-token -> permanent token with 30 mnt validity which is used for login, reg, profile apis
  void addXHeaderToken(Map tempResponseData) {
    bool isValid = true;
    String xToken = '';
    String rToken = '';
    String tokens = ApiKeys.responseKeys.tokens;
    String token = ApiKeys.responseKeys.token;
    if (tempResponseData.containsKey(tokens)) {
      xToken = tempResponseData[tokens][token];
      rToken = tempResponseData[tokens][ApiKeys.responseKeys.refreshToken];
    } else if (tempResponseData.containsKey(token)) {
      xToken = tempResponseData[token];
      rToken = tempResponseData[ApiKeys.responseKeys.refreshToken];
    } else {
      isValid = false;
    }
    if (isValid) {
      abhaSingleton.getSharedPref.set(SharedPref.apiRHeaderToken, rToken);
      this.xToken = xToken;
      setHeaderToken(xToken: xToken);
    }
  }

  void setHeaderToken({
    String? tToken,
    String? xToken,
    String? rToken,
    String? xAuthToken,
    String? authToken,
  }) {
    try {
      Map<String, dynamic> header = !Validator.isNullOrEmpty(xToken)
          ? {
              ApiKeys.headersKeys.xToken: '$_headerSuffix $xToken',
              ApiKeys.headersKeys.xAuthToken: this.xAuthToken,
              ApiKeys.headersKeys.xCmId: _configData[AppConfig.xCmId]
            }
          : !Validator.isNullOrEmpty(xAuthToken)
              ? {
                  ApiKeys.headersKeys.xToken: '$_headerSuffix ${this.xToken}',
                  ApiKeys.headersKeys.xAuthToken: '$xAuthToken',
                  ApiKeys.headersKeys.xCmId: _configData[AppConfig.xCmId]
                }
              : !Validator.isNullOrEmpty(rToken)
                  ? {ApiKeys.headersKeys.rToken: '$_headerSuffix $rToken'}
                  : !Validator.isNullOrEmpty(tToken)
                      ? {ApiKeys.headersKeys.tToken: '$_headerSuffix $tToken'}
                      : {
                          ApiKeys.headersKeys.authorization:
                              '$_headerSuffix $authToken'
                        };
      _dioOptions.headers = header;
      _dio?.options = _dioOptions;
    } catch (e) {
      abhaLog.e(e.toString());
    }
  }

  void clearHeaders() {
    try {
      xToken = '';
      xAuthToken = '';
      _dioOptions.headers.clear();
      _dio?.options = _dioOptions;
    } catch (e) {
      abhaLog.e(e.toString());
    }
  }

  Future<Options?> _handleHeaders(String url, Options? options) async {
    int offset =0;
    if (kReleaseMode && !kIsWeb){
       offset = await NTP.getNtpOffset(localTime: DateTime.now(), lookUpAddress: 'time.google.com');
    }
    Map<String, dynamic> fixHeaders = {
      ApiKeys.headersKeys.requestId: const Uuid().v4(),
    ApiKeys.headersKeys.timestamp:
    kReleaseMode && !kIsWeb
    ? DateTime.now().add(Duration(milliseconds: offset)).copyWith(microsecond: 0).toUtc().toIso8601String()
    : DateTime.now().copyWith(microsecond: 0).toUtc().toIso8601String(),
      ApiKeys.headersKeys.apikey: _configData[AppConfig.apikey],
    };
    if (Validator.isNullOrEmpty(options)) {
      options = Options(headers: fixHeaders);
    } else {
      fixHeaders.addAll(options?.headers ?? {});
      options?.headers = fixHeaders;
    }
    return options;
  }

  /// @Here function request provides the responses from the different Api Methods like
  /// post, get, put, patch, delete etc. This api methods used different parameter i.e
  /// url path , data payload, cancel token, option etc. to process the Api request.
  /// This methods provides various error codes in response thrown in some exception case. Param used:-
  ///       [method] of type APIMethods: Provides the different api request methods.
  ///       [url] of type String: Used for API Path.
  ///       [dataPayload] of type dynamic: Used to pass request data.
  ///       [downloadFileLocalPath] of type String.
  ///       [options] of type String: request can pass an Options object which will be merged with Dio.

  Future<dynamic> onEncryptData(String data,{Options? options}) async {
    Response? response = await request(
      method: APIMethod.post,
      url: ApiPath.encryptDataApi,
      options: options,
      dataPayload: {
        ApiKeys.responseKeys.data: data,
      },
    );

    dynamic localData = response?.data;
    if (localData != null) {
      return Future.value(
        localData.containsKey('encryptedData')
            ? localData['encryptedData']
            : '',
      );
    } else {
      return null;
    }
  }

  void cancelRequest() {
    _cancelToken.cancel();
  }

  Future<dynamic> request({
    required APIMethod method,
    required String url,
    dynamic dataPayload,
    String? downloadFileLocalPath,
    Options? options,
    bool ignoreHeaders = false,
  })  async {
    // Options(responseType: ResponseType.bytes) -  It is used to receive the bytes data instead of json data. Use it with post api.
    // Options(contentType: 'multipart/form-data') -  it is used to send files as multipart. Use it with post api.
    if(!ignoreHeaders){
      options = await _handleHeaders(url, options);
    }


    Response? response;
    try {
      if (method == APIMethod.post) {
        response = await _dio?.post(
          url,
          data: dataPayload,
          cancelToken: _cancelToken,
          options: options,
        );
      } else if (method == APIMethod.get) {
        response = await _dio?.get(
          url,
          queryParameters: dataPayload,
          cancelToken: _cancelToken,
          options: options,
        );
      } else if (method == APIMethod.delete) {
        response = await _dio?.delete(url, cancelToken: _cancelToken);
      } else if (method == APIMethod.download) {
        Dio dioDownload = Dio();
        response = await dioDownload.download(
          url,
          downloadFileLocalPath,
          cancelToken: _cancelToken,
        );
      } else if (method == APIMethod.put) {
        response = await _dio?.put(
          url,
          data: dataPayload,
          cancelToken: _cancelToken,
          options: options,
        );
      } else if (method == APIMethod.patch) {
        response = await _dio?.patch(url, cancelToken: _cancelToken);
      } else {}
      return response; // success error code 200 & 201 & 202
    } on DioException catch (dioError) {
      updateBaseUrl(_configData[AppConfig.baseUrl]);
      abhaLog.e(dioError);
      if (dioError.error is SocketException) {
        _formatLocalJsonError(
          ApiErrorCodes.noInternetConnection,
          message: 'No Internet Connection',
        );
      } else if (dioError.error is FormatException) {
        _formatLocalJsonError(
          ApiErrorCodes.badResponse,
          message: 'Bad Response Format',
        );
      } else {
        switch (dioError.response?.statusCode) {
          case 400:
            _formatRemoteJsonError('Request Invalid', dioError);
            break;
          case 401:
          case 403:
            _formatRemoteJsonError('Unauthorised/Expired', dioError);
            break;
          case 404:
            _formatRemoteJsonError('Request Not Found', dioError);
            break;
          case 408:
            _formatRemoteJsonError('Request Timeout', dioError);
            break;
          case 414:
            _formatRemoteJsonError('Server Process Failed', dioError);
            break;
          case 422:
            _formatRemoteJsonError('Verification Pending', dioError);
            break;
          case 429:
            _formatRemoteJsonError('Too Many Requests', dioError);
            break;
          case 440:
            _formatRemoteJsonError('Login Timeout', dioError);
            break;
          case 460:
            _formatRemoteJsonError(
              'Client Closed Request (AWS Elastic Load Balancer)',
              dioError,
            );
            break;
          case 499:
            _formatRemoteJsonError('Client Closed Request (ngnix)', dioError);
            break;
          case 500:
            _formatRemoteJsonError('Internal Server Error', dioError);
            break;
          case 501:
            _formatRemoteJsonError('Unknown Exception', dioError);
            break;
          case 502:
            _formatRemoteJsonError('BadGateway', dioError);
            break;
          case 503:
            _formatRemoteJsonError('Service Unavailable', dioError);
            break;
          case 504:
            _formatRemoteJsonError('Gateway Timeout', dioError);
            break;
          case 520:
            _formatRemoteJsonError(
              'Web Server Returned Unknown Error',
              dioError,
            );
            break;
          case 521:
            _formatRemoteJsonError('Web Server Is Down', dioError);
            break;
          case 522:
            _formatRemoteJsonError('Origin Is Unreachable', dioError);
            break;
          case 523:
            _formatRemoteJsonError('Origin Is Unreachable', dioError);
            break;
          case 524:
            _formatRemoteJsonError('Timeout Occurred', dioError);
            break;
          case 525:
            _formatRemoteJsonError('SSL Handshake Failed', dioError);
            break;
          case 527:
            _formatRemoteJsonError('Railgun Error', dioError);
            break;
          case 598:
            _formatRemoteJsonError('Network Read Timeout Error', dioError);
            break;
          case 599:
            _formatRemoteJsonError('Network Connect Timeout Error', dioError);
            break;
          default:
            _cancelToken.isCancelled ? _cancelToken = CancelToken() : null;
            _formatRemoteJsonError(
              "'Error occurred while communication with server with StatusCode",
              dioError,
            );
        }
      }
    } catch (e) {
      abhaLog.e(e);
      _formatLocalJsonError(0, message: 'something went wrong');
    }
  }

  /// @Here this function provides the format of Remote json Error. Param used:-
  ///    [message] of type String.
  ///    [dioError] of type DioError.
  void _formatRemoteJsonError(String message, DioException dioError) {
    throw Exception(
      '$message [${dioError.response?.statusCode ?? 0}] - ${dioError.response?.data.toString() ?? "{ ${ApiKeys.responseKeys.code}: 0 , ${ApiKeys.responseKeys.message}: Unknown Error }"}',
    );
  }

  /// @Here this function provides the format of Local json Error. Param used:-
  ///    [message] of type String.
  ///    [dioError] of type DioError.
  void _formatLocalJsonError(int errorCode, {String? message}) {
    throw Exception(
      '{ ${ApiKeys.responseKeys.code}: $errorCode, ${ApiKeys.responseKeys.message}: $message }',
    );
  }
}
