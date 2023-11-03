import 'package:abha/reusable_widget/dialog/custom_alert_dialog.dart';
import 'package:abha/utils/extensions/extension.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:abha/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  // static bool _isDialogOpen = false;

  static void showCircularDialog({BuildContext? mContext}) {
    // if(_isDialogOpen==true) dismissDialog();
    // _isDialogOpen=true;
    BuildContext context = mContext ?? navKey.currentContext!;
    context.openDialog(
      const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.colorAppOrange,
          color: AppColors.colorAppBlue,
        ),
      ),
    );
  }

  static void showPopupDialog(
    String? msg, {
    BuildContext? mContext,
    String? title,
    bool backDismissible = true,
    bool barrierDismissible = false,
    VoidCallback? onPositiveButtonPressed,
    VoidCallback? onNegativeButtonPressed,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    bool showCloseButton = false,
  }) {
    // if(_isDialogOpen==true) dismissDialog();
    // _isDialogOpen=true;
    BuildContext context = mContext ?? navKey.currentContext!;
    context.openDialog(
      barrierDismissible: barrierDismissible,
      backDismissible: backDismissible,
      CustomAlertDialog(
        title: title,
        msg: msg,
        onPositiveButtonPressed: onPositiveButtonPressed,
        onNegativeButtonPressed: onNegativeButtonPressed,
        positiveButtonTitle: positiveButtonTitle,
        negativeButtonTitle: negativeButtonTitle,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static void dismissDialog({
    BuildContext? mContext,
  }) {
    BuildContext context = mContext ?? navKey.currentContext!;
    context.navigateBack();
    // _isDialogOpen=false;
  }
}
