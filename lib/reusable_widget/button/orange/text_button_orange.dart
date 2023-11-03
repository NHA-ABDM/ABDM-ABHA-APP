import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:abha/utils/global/global_key.dart';

// ignore: must_be_immutable
class TextButtonOrange extends StatelessWidget {
  final String text;
  late double height;
  final Function()? onPressed;
  final String? leading;
  final IconData? tailing;
  final bool isButtonEnable;
  double width = 0.0;
  late TextStyle? style;

  TextButtonOrange.mobile({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_50;
    width = navKey.currentContext!.width * 0.92;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorWhite);
  }

  TextButtonOrange.desktop({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_46;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorWhite, fontSizeDelta: -2);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !isButtonEnable,
      child: TextButton(
        onPressed: () {
          if (isButtonEnable) {
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonEnable
              ? AppColors.colorAppOrange
              : AppColors.colorAppOrange.withOpacity(0.6),
          fixedSize:
              (width > 0.0) ? Size(width, height) : Size.fromHeight(height),
          padding:
              EdgeInsets.symmetric(vertical: Dimen.d_12, horizontal: Dimen.d_24),
          shape: ButtonBorderShape().getSquareButton(
            color: isButtonEnable
                ? AppColors.colorAppOrange
                : AppColors.colorAppOrange.withOpacity(0),
            radius: Dimen.d_5,
            borderWidth: Dimen.d_0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: WidgetUtility.spreadWidgets(
            [
              if (leading != null)
                CustomSvgImageView(
                  width: Dimen.d_25,
                  leading ?? '',
                  color: AppColors.colorWhite,
                )
              else
                Container(width: Dimen.d_1),
              Flexible(
                child: FittedBox(
                  child: Text(text, style: style),
                ),
              ),
              if (tailing != null)
                Icon(
                  size: Dimen.d_30,
                  tailing,
                  color: AppColors.colorWhite,
                )
              else
                Container(width: Dimen.d_1),
            ],
            interItemSpace: Dimen.d_8,
          ),
        ),
      ),
    );
  }
}
