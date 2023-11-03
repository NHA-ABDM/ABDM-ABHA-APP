import 'package:abha/export_packages.dart';

class AppTextFormDecoration {
  InputDecoration circularBorderDecoration({
    required BuildContext context,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
  }) {
    return InputDecoration(
      helperText: helperText,
      suffixIcon: suffixIcon != null
          ? Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 0),
        child: suffixIcon,
      )
          : null,
      prefixIcon: prefixIcon != null
          ? Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: prefixIcon,
      )
          : null,
      hintText: hintText,
      hintStyle: InputFieldStyleDesktop.hintTextStyle,
      prefixIconConstraints:
          BoxConstraints(maxHeight: Dimen.d_30, minHeight: Dimen.d_30,maxWidth: Dimen.d_32),
      suffixIconConstraints:
          BoxConstraints(maxHeight: Dimen.d_32, minWidth: Dimen.d_52),
      helperStyle: InputFieldStyleDesktop.errorTextStyle,
      errorStyle: InputFieldStyleDesktop.errorTextStyle,
      errorMaxLines: 2,
      errorText: (Validator.isNullOrEmpty(errorText)) ? null : errorText,
      isDense: true,
      counterText: '',
      contentPadding:
          EdgeInsets.symmetric(vertical: Dimen.d_16, horizontal: Dimen.d_12),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleDesktop.focusedBorderColor,
          width: InputFieldStyleDesktop.borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleDesktop.errorBorderColor,
          width: InputFieldStyleDesktop.borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleDesktop.enableBorderColor,
          width: InputFieldStyleDesktop.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleDesktop.focusedBorderColor,
          width: InputFieldStyleDesktop.focusedBorderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleDesktop.focusedErrorBorderColor,
          width: InputFieldStyleDesktop.focusedBorderWidth,
        ),
      ),
      disabledBorder: const OutlineInputBorder(),
    );
  }

  InputDecoration underLineBorderDecoration({
    required BuildContext context,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
  }) {
    return InputDecoration(
      helperText: helperText,
      hintText: hintText,
      hintStyle: InputFieldStyleMobile.hintTextStyle,
      suffixIcon: suffixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: suffixIcon,
            )
          : null,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: prefixIcon,
            )
          : null,
      prefixIconConstraints: BoxConstraints(maxHeight: Dimen.d_32, minWidth: 0),
      suffixIconConstraints: BoxConstraints(
        maxHeight: Dimen.d_32,
        minWidth: 52,
        minHeight: Dimen.d_10,
      ),
      helperStyle: InputFieldStyleMobile.errorTextStyle,
      errorStyle: InputFieldStyleMobile.errorTextStyle,
      isDense: true,
      counterText: '',
      contentPadding:
          EdgeInsets.symmetric(vertical: Dimen.d_4, horizontal: Dimen.d_0),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleMobile.focusedBorderColor,
          width: InputFieldStyleMobile.borderWidth,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: InputFieldStyleMobile.focusedBorderColor,
          width: InputFieldStyleMobile.focusedBorderWidth,
        ),
      ),
    );
  }

  InputDecoration getDefaultDecoration({
    required BuildContext context,
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
    TextStyle? errorStyle,
    bool filled = false,
    bool borderEnabled = true,
    Color filledColor = AppColors.colorAppBlue,
    double? contentPaddingVertical,
    double? contentPaddingHorizontal,
    Color borderColor = AppColors.colorAppBlue,
    Color hintColor = AppColors.colorGrey,
    Color counterColor = AppColors.colorGreenLight,
    double borderRadius = 5.0,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(color: hintColor),
      counterText: '',
      helperText: helperText,
      helperStyle: CustomTextStyle.bodyMedium(context)?.apply(
        color: counterColor,
      ),
      helperMaxLines: 100,
      filled: filled,
      isDense: true,
      fillColor: filledColor,
      errorText: (Validator.isNullOrEmpty(errorText)) ? null : errorText,
      // errorStyle: errorStyle ?? CustomTextStyle.bodySmall(context)?.apply(fontWeightDelta: -2, color: AppColors.colorRed),
      enabledBorder: borderEnabled
          ? OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const UnderlineInputBorder(),
      focusedBorder: borderEnabled
          ? OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const UnderlineInputBorder(),
      border: borderEnabled
          ? OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : const UnderlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        vertical: contentPaddingVertical ?? 16,
        horizontal: contentPaddingHorizontal ?? 12,
      ),
    );
  }
}
