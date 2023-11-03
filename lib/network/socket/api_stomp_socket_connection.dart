import 'dart:async';
import 'dart:convert';
import 'package:abha/app/abha_app.dart';
import 'package:abha/localization/localization_handler.dart';
import 'package:abha/network/api_keys.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:abha/reusable_widget/dialog/custom_dialog.dart';
import 'package:abha/reusable_widget/toast/message_helper.dart';
import 'package:abha/utils/config/app_config.dart';
import 'package:abha/utils/singleton/abha_singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ApiStompSocketConnection {
  static const int _defaultErrorCode = 10;
  final int _connectionTimeOutErrorCode = 20;
  final int _webSocketError = 30;
  late StompClient _stompClient;
  String _requestId = '';
  String _publishApi = '';
  String _subscribeApi = '';
  Map _reqBody = {};
  late Function(ApiSocketLocalResponseModel responseModel) _callBackFunc;
  late Timer _timer;

  // to establish connection with socket
  void initConnection({
    required String reqId,
    required String publishApiCall,
    required String subscribeApiCall,
    required Map reqBody,
    required Function(ApiSocketLocalResponseModel responseModel) callBack,
  }) {
    _requestId = reqId;
    _publishApi = publishApiCall;
    _subscribeApi = subscribeApiCall;
    _reqBody = reqBody;
    _callBackFunc = callBack;
    _timer = Timer(const Duration(seconds: 60), _initConnectionTimeOut);
    String baseUrl =
        abhaSingleton.getAppConfig.getConfigData()[AppConfig.baseUrlWebSocket];
    String accessToken = abhaSingleton.getAppData.getAccessToken();

    /// TO-IMPLEMENT: commenting this due to CORS issue
    String url = baseUrl + accessToken;
    String flavorName =
        abhaSingleton.getAppConfig.getConfigData()[AppConfig.flavorName];
    if (flavorName == '' || flavorName == '') {
      url = baseUrl;
    }

    /// TO-IMPLEMENT: remove below line once CORS issue for gateway session API is fixed
    // String url = baseUrl;

    _stompClient = StompClient(
      config: StompConfig(
        // connectionTimeout: const Duration(seconds: 90), // not working
        url: url,
        stompConnectHeaders: {'name': _requestId},
        webSocketConnectHeaders: {'name': _requestId},
        beforeConnect: () {
          CustomDialog.showCircularDialog();
          return Future.value();
        },
        onConnect: (StompFrame frame) async {
          await _initPublish();
          _initSubscribe(frame);
        },
        onWebSocketError: (dynamic error) {
          abhaLog.e('On Websocket Error $error');
          _errorHandler(_webSocketError);
          // _callBackFunc.call(_responseModel);
          _initDisconnect();
        },
        onStompError: (dynamic error) => abhaLog.e('On Stomp Error $error'),
        onDebugMessage: (dynamic debugMsg) =>
            abhaLog.d('On Debug Message $debugMsg'),
        onUnhandledFrame: (dynamic unhandledFrame) =>
            abhaLog.e('On Unhandled Frame $unhandledFrame'),
        onUnhandledMessage: (dynamic unhandledMsg) =>
            abhaLog.e('On Unhandled Message $unhandledMsg'),
        onUnhandledReceipt: (dynamic unhandledReceipt) =>
            abhaLog.e('On Unhandled Receipt $unhandledReceipt'),
        onDisconnect: (dynamic disconnectData) {
          abhaLog.e('On Disconnect $disconnectData');
        },
        onWebSocketDone: () {},
      ),
    );
    _stompClient.activate();
  }

  // to call the api with data
  Future<void> _initPublish() async {
    int offset = 0;
    if (kReleaseMode && !kIsWeb) {
      offset = await NTP.getNtpOffset(
        localTime: DateTime.now(),
        lookUpAddress: 'time.google.com',
      );
    }
    Map<String, String> headers = {
      ApiKeys.headersKeys.requestId: _requestId,
      ApiKeys.headersKeys.timestamp: kReleaseMode && !kIsWeb
          ? DateTime.now()
              .add(Duration(milliseconds: offset))
              .copyWith(microsecond: 0)
              .toUtc()
              .toIso8601String()
          : DateTime.now().copyWith(microsecond: 0).toUtc().toIso8601String(),
      ApiKeys.requestKeys.abhaAddress:
          abhaSingleton.getAppData.getAbhaAddress(),
      ApiKeys.headersKeys.authorization:
          abhaSingleton.getAppConfig.getConfigData()[AppConfig.apikey],
      ApiKeys.headersKeys.xAuthToken: abhaSingleton.getApiProvider.xAuthToken,
    };
    abhaLog.d('Publish Api - $_publishApi');
    _stompClient.send(
      destination: _publishApi,
      headers: headers,
      body: jsonEncode(_reqBody),
    );
    abhaLog.d('Request Body - $_reqBody');
  }

  // to get the response
  void _initSubscribe(StompFrame frame) {
    _stompClient.subscribe(
      destination: '$_subscribeApi$_requestId',
      callback: (frame) {
        _initDisconnect();
        Future.delayed(const Duration(milliseconds: 200), () {
          Map<String, dynamic> parseData = {
            ApiKeys.responseKeys.data: frame.body,
          };
          ApiSocketLocalResponseModel responseModel =
              ApiSocketLocalResponseModel.fromJson(parseData);
          Map responseData = jsonDecode(responseModel.data ?? '');
          bool isErrored = responseData.containsKey(ApiKeys.responseKeys.error);
          if (isErrored) {
            _errorHandler(_defaultErrorCode);
          } else {
            _callBackFunc.call(responseModel);
          }
        });
      },
    );
  }

  // to disconnect socket
  void _initDisconnect() {
    CustomDialog.dismissDialog();
    _timer.cancel();
    _stompClient.deactivate();
  }

  // to handle connection timeout
  void _initConnectionTimeOut() {
    _initDisconnect();
    _errorHandler(_connectionTimeOutErrorCode);
  }

  // to handle the error
  void _errorHandler(int errorCode) {
    late String msg;
    if (errorCode == _connectionTimeOutErrorCode) {
      msg = LocalizationHandler.of().unableToCompleteRequest;
    } else if (errorCode == _webSocketError) {
      msg = LocalizationHandler.of().socketError;
    } else if (errorCode == _defaultErrorCode) {
      msg = LocalizationHandler.of().somethingWrong;
    } else {
      msg = LocalizationHandler.of().somethingWrong;
    }
    MessageBar.showToastDialog(msg);
  }
}
