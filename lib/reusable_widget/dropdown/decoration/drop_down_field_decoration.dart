import 'package:abha/export_packages.dart';

class DropDownDecoration {
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
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      hintStyle: InputFieldStyleDesktop.hintTextStyle,
      prefixIconConstraints:
        BoxConstraints(maxHeight: Dimen.d_30, minHeight: Dimen.d_30,maxWidth: Dimen.d_32),
    suffixIconConstraints:
    BoxConstraints(maxHeight: Dimen.d_32, minWidth: Dimen.d_52),
      helperStyle: InputFieldStyleDesktop.errorTextStyle,
      errorStyle: InputFieldStyleDesktop.errorTextStyle,
      errorText: (Validator.isNullOrEmpty(errorText)) ? null : errorText,
      isDense: true,
      counterText: '',
      contentPadding:
          EdgeInsets.symmetric(vertical: Dimen.d_13, horizontal: Dimen.d_12),
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
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints(maxHeight: Dimen.d_32, minWidth: 0),
      suffixIconConstraints:
          BoxConstraints(maxHeight: Dimen.d_32, minWidth: 52),
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
}
