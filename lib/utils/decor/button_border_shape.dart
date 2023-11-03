import 'package:abha/export_packages.dart';

class ButtonBorderShape {
  CircleBorder getCircularButton({Color color = AppColors.colorAppBlue}) {
    return CircleBorder(side: BorderSide(color: color));
  }

  RoundedRectangleBorder getSquareButton({
    Color color = AppColors.colorAppBlue,
    double radius = 10,
    double borderWidth = 2,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: color, width: borderWidth),
    );
  }
}
