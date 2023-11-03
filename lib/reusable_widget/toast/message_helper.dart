import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

class MessageBar {
  static showToastError(String? message, {int seconds = 5}) {
    if (kIsWeb) {
      Fluttertoast.showToast(
        msg: message ?? '',
        toastLength: seconds <= 3 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: seconds,
        backgroundColor: Colors.black,
        textColor: const Color(0xFFE33D19),
        fontSize: Dimen.d_20,
        webShowClose: true,
        webPosition: 'center',
        webBgColor: '#FFE0D9',
      );
    } else {
      _showToast(message);
    }
  }

  static showToastSuccess(String? message, {int seconds = 5}) {
    if (kIsWeb) {
      Fluttertoast.showToast(
        msg: message ?? '',
        toastLength: seconds <= 3 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: seconds,
        backgroundColor: Colors.black,
        textColor: const Color(0xFF1F6648),
        fontSize: Dimen.d_20,
        webShowClose: true,
        webPosition: 'center',
        webBgColor: '#DAF1E8',
      );
    } else {
      _showToast(message);
    }
  }

  static _showToast(String? message, {int seconds = 5}) {
    Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: seconds <= 3 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: seconds,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: Dimen.d_20,
      webShowClose: true,
      webPosition: 'center',
      webBgColor: '#DAF1E8',
    );
  }

  static showToastDialog(
    String? message, {
    Function()? onPositiveButtonPressed,
  }) {
    CustomDialog.showPopupDialog(
      message,
      onPositiveButtonPressed: () {
        onPositiveButtonPressed == null ? null : onPositiveButtonPressed();
        CustomDialog.dismissDialog();
      },
    );
  }

  static showSnackBarTop(
    String message, {
    BuildContext? context,
    SnackPosition snackPosition = SnackPosition.TOP,
    int seconds = 5,
  }) async {
    Get.closeAllSnackbars();
    Get.snackbar(
      '',
      '',
      messageText: Container(
        height: 30,
        alignment: Alignment.center,
        child: Text(
          message,
          style: CustomTextStyle.titleLarge(context ?? navKey.currentContext!)
              ?.apply(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      snackPosition: snackPosition,
      duration: Duration(seconds: seconds),
    );
  }

  static showDefaultSnackBar(
    String msg, {
    BuildContext? context,
    int seconds = 5,
  }) {
    ScaffoldMessenger.of(context ?? navKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: CustomTextStyle.titleLarge(context ?? navKey.currentContext!)
              ?.apply(
            color: AppColors.colorWhite,
          ),
        ),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static showCustomSnackBar(
    String message, {
    BuildContext? context,
    int seconds = 5,
  }) {
    final snackBar = SnackBar(
      content: Container(
        height: 30,
        alignment: Alignment.center,
        child: Text(
          message,
          style: CustomTextStyle.titleLarge(context ?? navKey.currentContext!)
              ?.apply(
            color: AppColors.colorWhite,
          ),
        ),
      ),
      duration: Duration(seconds: seconds),
      backgroundColor: AppColors.colorBlack2,
    );
    ScaffoldMessenger.of(context ?? navKey.currentContext!)
        .showSnackBar(snackBar);
  }

  static showSnackBarWithOption(
    String title,
    String body, {
    VoidCallback? onPositiveButtonPressed,
    VoidCallback? onNegativeButtonPressed,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    bool dismissible = true,
  }) {
    final snackBar = SnackBar(
      dismissDirection:
          dismissible ? DismissDirection.down : DismissDirection.none,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomTextStyle.titleLarge(navKey.currentContext!)?.apply(
              color: AppColors.colorAppBlue,
            ),
          ),
          Text(
            body,
            style: CustomTextStyle.titleLarge(navKey.currentContext!)?.apply(
              color: AppColors.colorAppBlue,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onNegativeButtonPressed,
                child: Text(
                  negativeButtonTitle?.toUpperCase() ??
                      LocalizationHandler.of().cancel,
                  style: const TextStyle(color: AppColors.colorAppOrange),
                ),
              ),
              TextButton(
                onPressed: onPositiveButtonPressed,
                child: Text(
                  positiveButtonTitle?.toUpperCase() ??
                      LocalizationHandler.of().ok.toUpperCase(),
                  style: const TextStyle(color: AppColors.colorAppOrange),
                ),
              ),
            ],
          )
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.colorWhite.withOpacity(0.9),
    );
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(snackBar);
  }

  static dismissSnackBar({
    BuildContext? context,
  }) {
    ScaffoldMessenger.of(context ?? navKey.currentContext!)
        .removeCurrentSnackBar();
  }
}
