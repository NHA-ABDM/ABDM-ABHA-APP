import 'package:abha/app/token/token_model.dart';
import 'package:abha/app/token/token_repo.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class TokenController extends BaseController {
  String tokenNo = '0';
  List<TokenModel>? tokenDetailModelList;
  late TokenRepo _tokenRepo;
  int remainsTimeInSeconds = 0;
  int expiryTime = 0;
  int offset = 0;
  TokenModel tokenDetailModel = TokenModel();
  bool isUserDetailsShared = true;

  TokenController(TokenRepoImpl tokenRepoImpl) : super(TokenController) {
    _tokenRepo = tokenRepoImpl;
  }

  /// Here is the function to get the difference between two date time.
  /// This function provides the differences in seconds, milliseconds, minutes, day, and hours.
  /// param [createdDate] DateTime.
  /// return  [diff] int.
  int _getDifference(DateTime createdDateTime) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime currentTime =
    kReleaseMode && !kIsWeb
        ? dateFormat.parse(DateTime.now().add(Duration(milliseconds: offset)).toString())
        : dateFormat.parse(DateTime.now().toString());
    // DateTime currentTime = dateFormat.parse(DateTime.now().toString());
    createdDateTime = dateFormat.parse(createdDateTime.toString());
    int diff = currentTime.difference(createdDateTime.toUtc()).inSeconds;
    return diff;
  }

  /// Function to get Utc Time
  /// param [createdDate] DateTime
  DateTime utcTime(DateTime createdDate) {
    final utcTime = DateTime.utc(
      createdDate.year,
      createdDate.month,
      createdDate.day,
      createdDate.hour,
      createdDate.minute,
      createdDate.second,
    );
    return utcTime;
  }

  Future<void> getHipTokenDetails() async {
    var tempResponseData = await _tokenRepo.onHipTokenDetails();
    String tempData = jsonEncode(tempResponseData);
    tokenDetailModelList = dashboardTokenModelFromMap(tempData);
    ///First check token is present in shared preference or not else show token from API call
    // String? tokenString = await abhaSingleton.getSharedPref.get(SharedPref.tokenDetails);
    // if(!Validator.isNullOrEmpty(tokenString)) {
    //   TokenModel tokenModel = TokenModel.fromMap(jsonDecode(tokenString!));
    //   _getTimeForTokenExpiry(tokenModel);
    //   if(remainsTimeInSeconds <=0) {
    //     abhaSingleton.getSharedPref.set(SharedPref.tokenDetails, '');
    //     _showTokenFromHistory();
    //   }
    // } else {
      await _showTokenFromHistory();
  }

  Future<void> _showTokenFromHistory() async {
    if (tokenDetailModelList?.isNotEmpty == true) {
      tokenDetailModelList
          ?.sort((a, b) => b.dateCreated!.compareTo(a.dateCreated!));
      tokenDetailModel = tokenDetailModelList?[0] ?? TokenModel();
      await getTimeForTokenExpiry();
    }
  }

  Future<void> getTimeForTokenExpiry() async {
    if (kReleaseMode && !kIsWeb) {
      offset = await NTP.getNtpOffset(localTime: DateTime.now(), lookUpAddress: 'time.google.com');
    }
    tokenNo = tokenDetailModel.tokenNumber ?? '0';
    expiryTime = tokenDetailModel.expiresIn?.toInt() ?? 0; // time is in seconds
    int elapsedTimeInSec = _getDifference(tokenDetailModel.dateCreated ?? DateTime.now()); // get the elapsed time
    remainsTimeInSeconds = expiryTime - elapsedTimeInSec; // calculate the remaining time
  }

  // Future<bool> getTokenTimerActivated() async {
  //   return await abhaSingleton.getSharedPref
  //       .get(SharedPref.isShareTokenActivated, defaultValue: false);
  // }

  String getCountText(AnimationController animController) {
    Duration count = animController.duration! * animController.value;
    return remainsTimeInSeconds <= 0
        ? LocalizationHandler.of().timeOut
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}'
            ':${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void startTimer(AnimationController animController) {
    animController.reverse(
      from: animController.value == 0 ? 1.0 : animController.value,
    );
  }

  void stopTimer(AnimationController animController) {
    remainsTimeInSeconds = 0;
    isUserDetailsShared = false;
    animController.stop();
    // abhaSingleton.getSharedPref.set(SharedPref.isShareTokenActivated, false);
  }
}
