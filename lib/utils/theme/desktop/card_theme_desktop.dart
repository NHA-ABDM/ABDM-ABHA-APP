import 'package:abha/export_packages.dart';

class CardThemeDesktop {
  static double get borderRadius => Dimen.d_6;

  static Color get backgroundColor => AppColors.colorWhite;

  static BoxBorder get border => Border.all(color: AppColors.colorBorder, width: 1.0);

  static List<BoxShadow> get shadow => [
        const BoxShadow(
          color: AppColors.colorGreyLight1,
          blurRadius: 3.0,
          spreadRadius: 0.0,
          offset: Offset(0.0, 1.0),
        ),
      ];

  static EdgeInsets get padding => EdgeInsets.symmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20);
}
