import 'package:abha/export_packages.dart';

class CustomRadioTileWidget extends StatefulWidget {
  final Widget titleWidget;
  final Object radioValue;
  final Object? radioGroupValue;
  final ValueChanged<dynamic> onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? tileHeight;
  final double? horizontalMargin;

  const CustomRadioTileWidget({
    required this.titleWidget,
    required this.radioValue,
    required this.radioGroupValue,
    required this.onChanged,
    super.key,
    this.selectedColor = AppColors.colorBlueLight7,
    this.unselectedColor = AppColors.colorTransparent,
    this.tileHeight,
    this.horizontalMargin,
  });

  @override
  State<CustomRadioTileWidget> createState() => CustomRadioTileWidgetState();
}

class CustomRadioTileWidgetState extends State<CustomRadioTileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: widget.tileHeight ?? Dimen.d_64,
          color: widget.radioGroupValue == widget.radioValue
              ? widget.selectedColor
              : widget.unselectedColor,
          child: InkWell(
            onTap: () {
              widget.onChanged(widget.radioValue);
            },
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Radio(
                    value: widget.radioValue,
                    groupValue: widget.radioGroupValue,
                    onChanged: widget.onChanged,
                  ),
                ),
                Expanded(
                  child: widget.titleWidget
                      .paddingSymmetric(horizontal: Dimen.d_5),
                ),
              ],
            ).marginSymmetric(
              horizontal: widget.horizontalMargin ?? Dimen.d_15,
            ),
          ),
        ),
        Container(
          color: AppColors.colorGreyLight11,
          height: Dimen.d_1,
        ),
      ],
    );
  }
}
