import 'package:abha/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BorderDecoration {
  ShapeDecoration getLinearGradientRectangularBorder({
    Color colorOne = AppColors.colorAppBlue,
    Color colorTwo = AppColors.colorOrangeDark,
    double topLeft = 10,
    double topRight = 10,
    double bottomLeft = 10,
    double bottomRight = 10,
  }) {
    return ShapeDecoration(
      gradient: LinearGradient(
        colors: [colorOne, colorTwo],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
      ),
    );
  }

  BoxDecoration getSweepGradientRectangularBorder({
    Color colorOne = AppColors.colorAppBlue,
    Color colorTwo = AppColors.colorOrangeDark,
    double size = 10,
  }) {
    return BoxDecoration(
      gradient: SweepGradient(
        colors: [colorOne, colorTwo],
      ),
      borderRadius: BorderRadius.all(Radius.circular(size)),
    );
  }

  ShapeDecoration getRectangularCornerBorder({
    Color color = AppColors.colorAppBlue,
    double topLeft = 10,
    double topRight = 10,
    double bottomLeft = 10,
    double bottomRight = 10,
  }) {
    return ShapeDecoration(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
      ),
    );
  }

  BoxDecoration getElevation({
    Color color = AppColors.colorAppBlue,
    Color borderColor = AppColors.colorAppBlue,
    Color boxShadowColor = AppColors.colorGreyLight1,
    double size = 10,
    bool isLow = false,
    bool isMedium = false,
    bool isHigh = false,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(size)),
      boxShadow: [
        BoxShadow(
          color: boxShadowColor,
          blurRadius: isLow
              ? 1.0
              : isMedium
                  ? 3.0
                  : isHigh
                      ? 4.0
                      : 1.0,
          spreadRadius: isLow
              ? 0.0
              : isMedium
                  ? 0.0
                  : isHigh
                      ? 0.0
                      : 1.0,
          offset: isLow
              ? const Offset(0.0, 1.0)
              : isMedium
                  ? const Offset(3.0, 3.0)
                  : isHigh
                      ? const Offset(4.0, 4.0)
                      : const Offset(
                          0.0,
                          2.5,
                        ),
        )
      ],
    );
  }

  BoxDecoration getVeryLowElevation({
    Color color = AppColors.colorAppBlue,
    Color borderColor = AppColors.colorAppBlue,
    double size = 10,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(size)),
      boxShadow: const [
        BoxShadow(
          color: AppColors.colorDropShadow,
          blurRadius: 1.0,
          spreadRadius: 1.0,
          offset: Offset(0.0, 2.5),
        ),
      ],
    );
  }

  BoxDecoration getHorizontalLine({
    Color color = AppColors.colorWhite,
    Color borderColor = AppColors.colorGreyLight7,
    double width = 1.5,
}){
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: borderColor,
          width: width,
        ),
      ),
      color: color,
    );
  }

  BoxDecoration getRectangularBorder({
    Color color = AppColors.colorWhite,
    Color borderColor = AppColors.colorGreyLight6,
    double size = 10,
    double width = 1,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
        width: width,
      ),
      borderRadius: BorderRadius.circular(size),
    );
  }

  ShapeBorder getRectangularShapeBorder({
    double size = 10,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(size),
    );
  }

  InputDecoration getDropdownRectangularBorder({
    Color color = AppColors.colorWhite,
    double size = 10,
  }) {
    return InputDecoration(
      // isDense: true,
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(size),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.0),
      ),
    );
  }

  BoxDecoration getCircularBorder({
    Color color = AppColors.colorWhite,
    Color colorBorder = AppColors.colorAppBlue,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: Border.all(color: colorBorder, width: 1.0),
    );
  }

  BoxDecoration getToggleRectangularBorder(bool isSelected, {double size = 5}) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: isSelected ? AppColors.colorAppBlue : Colors.transparent,
      border: Border.all(
        color: isSelected ? AppColors.colorAppBlue : AppColors.colorLavender,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(size),
    );
  }

  BoxDecoration getToggleCircularBorder(bool isSelected) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? AppColors.colorGreenLight : Colors.transparent,
      border: Border.all(
        color: isSelected ? AppColors.colorBlack : AppColors.colorGreyLight2,
        width: isSelected ? 2 : 1.5,
      ),
    );
  }
}
