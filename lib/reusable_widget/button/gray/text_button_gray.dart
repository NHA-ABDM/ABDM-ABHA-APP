import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:abha/utils/global/global_key.dart';

// ignore: must_be_immutable
class TextButtonGray extends StatelessWidget {
  final String text;
  late double height;
  final Function()? onPressed;
  final String? leading;
  final IconData? tailing;
  final bool isButtonEnable;

  late TextStyle? style;

  TextButtonGray({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_50;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorWhite);
  }

  TextButtonGray.desktop({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = 46;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorWhite, fontSizeDelta: -2);
  }

  TextButtonGray.mobile({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = 46;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorWhite, fontSizeDelta: -2);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isButtonEnable) {
          onPressed!();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.colorGreyLight6,
        fixedSize: Size.fromHeight(height),
        padding:
            EdgeInsets.symmetric(vertical: Dimen.d_12, horizontal: Dimen.d_24),
        shape: ButtonBorderShape().getSquareButton(
          color: AppColors.colorGreyLight6,
          radius: Dimen.d_5,
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
    );
  }
}
