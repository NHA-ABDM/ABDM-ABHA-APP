import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';

class InputFieldStyleDesktop {
  static TextStyle? get labelTextStyle => CustomTextStyle.titleMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorBlack6,
        fontSizeDelta: -1,
      );

  static TextStyle? get labelMandatoryTextStyle => CustomTextStyle.titleMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorRed,
        fontSizeDelta: 1,
      );

  static TextStyle? get inputFieldStyle => CustomTextStyle.bodySmall(navKey.currentContext!)?.apply(
        color: AppColors.colorBlack6,
        // fontSizeDelta: 1,
        heightFactor: -1.0,
      );

  static TextStyle? get errorTextStyle => CustomTextStyle.labelMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorDarkRed5,
        fontSizeDelta: 2,
      );

  static TextStyle? get helperTextStyle => CustomTextStyle.bodyMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorPurple4,
      );

  static TextStyle? get hintTextStyle => CustomTextStyle.bodySmall(navKey.currentContext!)?.apply(
        color: AppColors.colorGreyDark8,
        fontWeightDelta: -1,
      );

  static Color get enableBorderColor => AppColors.colorPurple4;

  static Color get focusedBorderColor => AppColors.colorAppBlue1;

  static Color get focusedErrorBorderColor => AppColors.colorDarkRed5;

  static Color get errorBorderColor => AppColors.colorDarkRed5;

  static double get borderWidth => 1.0;

  static double get focusedBorderWidth => 1.5;
}

class InputFieldStyleMobile {
  static TextStyle? get labelTextStyle => CustomTextStyle.titleMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorBlack6,
        fontSizeDelta: -1,
      );

  static TextStyle? get labelMandatoryTextStyle => CustomTextStyle.titleMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorRed,
        fontSizeDelta: 1,
      );

  static TextStyle? get inputFieldStyle => CustomTextStyle.bodyMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorBlack6,
        fontWeightDelta: 0,
        fontSizeDelta: 2,
      );

  static TextStyle? get errorTextStyle => CustomTextStyle.labelMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorDarkRed5,
        fontSizeDelta: 2,
      );

  static TextStyle? get helperTextStyle => CustomTextStyle.bodyMedium(navKey.currentContext!)?.apply(
        color: AppColors.colorPurple4,
      );

  static TextStyle? get hintTextStyle => CustomTextStyle.bodySmall(navKey.currentContext!)?.apply(
        color: AppColors.colorGreyDark8,
        fontWeightDelta: -1,
      );

  static Color get enableBorderColor => AppColors.colorPurple4;

  static Color get focusedBorderColor => AppColors.colorAppBlue1;

  static Color get focusedErrorBorderColor => AppColors.colorDarkRed5;

  static Color get errorBorderColor => AppColors.colorDarkRed5;

  static double get borderWidth => 1.0;

  static double get focusedBorderWidth => 1.5;
}
