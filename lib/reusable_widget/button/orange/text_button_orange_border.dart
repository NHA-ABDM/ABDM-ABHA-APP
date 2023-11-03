import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:abha/utils/global/global_key.dart';

// ignore: must_be_immutable
class TextButtonOrangeBorder extends StatefulWidget {
  final String text;
  late double height;
  final Function()? onPressed;
  final String? leading;
  final IconData? tailing;
  final bool isButtonEnable;
  double width = 0.0;
  late TextStyle? style;

  TextButtonOrangeBorder.mobile({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = Dimen.d_50;
    width = navKey.currentContext!.width;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorAppOrange);
  }

  TextButtonOrangeBorder.desktop({
    required this.text,
    required this.onPressed,
    super.key,
    this.leading,
    this.tailing,
    this.isButtonEnable = true,
  }) {
    height = 46;
    style = CustomTextStyle.bodyMedium(navKey.currentContext!)
        ?.apply(color: AppColors.colorAppOrange, fontSizeDelta: -2);
  }

  @override
  State<TextButtonOrangeBorder> createState() => _TextButtonOrangeBorderState();
}

class _TextButtonOrangeBorderState extends State<TextButtonOrangeBorder> {
  Color color = AppColors.colorWhite;
  Color styleColor = AppColors.colorAppOrange;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.isButtonEnable,
      child: TextButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: (widget.width > 0.0)
              ? Size(widget.width, widget.height)
              : Size.fromHeight(widget.height),
          padding:
              EdgeInsets.symmetric(vertical: Dimen.d_12, horizontal: Dimen.d_24),
          backgroundColor: color,
          shape: ButtonBorderShape().getSquareButton(
            radius: Dimen.d_5,
            color: AppColors.colorAppOrange,
          ),
        ),
        onHover: (isHover) {
          setState(() {
            if (isHover) {
              color = AppColors.colorAppOrange;
              styleColor = AppColors.colorWhite;
            } else {
              color = AppColors.colorWhite;
              styleColor = AppColors.colorAppOrange;
            }
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: WidgetUtility.spreadWidgets(
            [
              if (widget.leading != null)
                CustomSvgImageView(
                  width: Dimen.d_18,
                  widget.leading ?? '',
                  color: styleColor,
                )
              else
                Container(width: Dimen.d_1),
              Flexible(
                child: FittedBox(
                  child: Text(
                    widget.text,
                    style: widget.style?.apply(color: styleColor),
                  ),
                ),
              ),
              if (widget.tailing != null)
                Icon(
                  size: Dimen.d_30,
                  widget.tailing,
                  color: styleColor,
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
