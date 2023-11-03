import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:abha/utils/global/global_key.dart';

// ignore: must_be_immutable
class TextButtonPurple extends StatelessWidget {
  final String text;
  late double height;
  final Function()? onPressed;
  final String? leading;
  final IconData? tailing;
  final bool isButtonEnable;

  late TextStyle? style;

  TextButtonPurple({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_50;
    style = CustomTextStyle.titleSmall(navKey.currentContext!)
        ?.apply(color: AppColors.colorGreyDark4);
  }

  TextButtonPurple.mobile({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_50;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorGreyDark4);
  }

  TextButtonPurple.desktop({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = 46;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorGreyDark4, fontSizeDelta: -2);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        padding:
            EdgeInsets.symmetric(vertical: Dimen.d_12, horizontal: Dimen.d_24),
        backgroundColor: AppColors.colorPurple4,
        shape: ButtonBorderShape().getSquareButton(
          color: AppColors.colorPurple4,
          radius: Dimen.d_5,
          borderWidth: 0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: WidgetUtility.spreadWidgets(
          [
            Text(
              text,
              style: style,
            )
          ],
          interItemSpace: Dimen.d_8,
        ),
      ),
    );
  }
}
