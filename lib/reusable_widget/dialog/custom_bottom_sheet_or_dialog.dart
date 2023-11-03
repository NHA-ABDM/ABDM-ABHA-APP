import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class CustomBottomSheetOrDialogHandler {
  static Future<dynamic> bottomSheetOrDialog({
    required BuildContext mContext,
    required Widget child,
    Color color = AppColors.colorWhite,
    double? width,
    double? height,
    String? title,
    String? subTitle,
    bool isScrollControlled = false,
  }) async {
    return kIsWeb
        ? _showDialog(
            mContext: mContext,
            child: child,
            width: width,
            height: height,
            title: title,
            subTitle: subTitle,
          )
        : _showBottomModalSheet(
            mContext: mContext,
            child: child,
            color: color,
            height: height,
            isScrollControlled: isScrollControlled,
          );
  }

  static Future<dynamic> _showDialog({
    required BuildContext mContext,
    required Widget child,
    String? title,
    String? subTitle,
    double? width,
    double? height,
  }) async {
    return mContext.openDialog(
      CustomSimpleDialog(
        title: title,
        subTitle: subTitle,
        showCloseButton: true,
        paddingLeft: Dimen.d_0,
        size: Dimen.d_6,
        child: child.sizedBox(
          width: width ?? mContext.width * 0.40,
          height: height ?? mContext.width * 0.30,
        ),
      ),
    );
  }

  static Future<dynamic> _showBottomModalSheet({
    required BuildContext mContext,
    required Widget child,
    Color color = AppColors.colorWhite,
    double? height,
    bool isScrollControlled = false,
  }) async {
    return showModalBottomSheet<Future<dynamic>>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: mContext,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            color: color,
            constraints:
                BoxConstraints(maxHeight: height ?? context.height * 0.8),
            child: child,
          ),
        );
      },
    ).then((value) {});
  }
}
