part of 'extension.dart';

extension TxtStyle on TextStyle {
  TextStyle get bold => TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
      );

  TextStyle get semiBold => TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      );

  // TextStyle? get normal => CustomTextStyle.bodyText1(context)?.apply();
}
