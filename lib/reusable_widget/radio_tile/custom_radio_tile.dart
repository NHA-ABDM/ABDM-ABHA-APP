import 'package:abha/export_packages.dart';

class CustomRadioTile extends StatefulWidget {
  final String title;
  final Object radioValue;
  final Object? radioGroupValue;
  final ValueChanged<dynamic> onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CustomRadioTile({
    required this.title,
    required this.radioValue,
    required this.radioGroupValue,
    required this.onChanged,
    super.key,
    this.selectedColor = AppColors.colorBlueLight7,
    this.unselectedColor = AppColors.colorTransparent,
  });

  @override
  State<CustomRadioTile> createState() => CustomRadioTileState();
}

class CustomRadioTileState extends State<CustomRadioTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Dimen.d_80,
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
                  child: Text(
                    widget.title,
                    maxLines: 4,
                    style: CustomTextStyle.bodyMedium(context)?.apply(
                      color: widget.radioGroupValue == widget.radioValue
                          ? AppColors.colorBlack
                          : AppColors.colorAppBlue,
                    ),
                  ).paddingSymmetric(horizontal: Dimen.d_5),
                ),
              ],
            ).marginSymmetric(horizontal: Dimen.d_15),
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
