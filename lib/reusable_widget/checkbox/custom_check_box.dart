import 'package:abha/export_packages.dart';

class CustomCheckBox extends StatefulWidget {
  final Widget? iconEnabledWidget;
  final Widget? iconDisbledWidget;
  final Widget labelWidget;
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final bool enable;
  final bool shoulToggleOpacity;
  final double? width;
  final bool isDesktopView;

  const CustomCheckBox({
    required this.iconEnabledWidget,
    required this.iconDisbledWidget,
    required this.labelWidget,
    super.key,
    this.onChanged,
    this.value = false,
    this.enable = true,
    this.shoulToggleOpacity = true,
    this.width,
    this.isDesktopView = false,
  });

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _selected;

  @override
  void initState() {
    _selected = widget.value;

    super.initState();
  }

  void _onTap() {
    setState(() {
      _selected = !_selected;
    });
    if (!Validator.isNullOrEmpty(widget.onChanged)) {
      widget.onChanged!(_selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimen.d_50,
      decoration: (widget.isDesktopView)
          ? abhaSingleton.getBorderDecoration.getRectangularBorder(
              borderColor: _selected == true
                  ? AppColors.colorAppOrange
                  : AppColors.colorPurple4,
              size: 5,
              width: _selected == true ? 2 : 1,
            )
          : abhaSingleton.getBorderDecoration.getRectangularBorder(
              borderColor: _selected == true
                  ? AppColors.colorAppBlue
                  : AppColors.colorGreyLight7,
              size: 5,
            ),
      child: Material(
        child: InkWell(
          onTap: widget.enable
              ? () {
                  _onTap();
                }
              : null,
          child: Row(
            children: <Widget>[
              if (_selected == true)
                widget.iconEnabledWidget!
              else
                widget.iconDisbledWidget!,
              SizedBox(
                width: Dimen.d_10,
              ),
              Center(
                child: widget.shoulToggleOpacity
                    ? Opacity(
                        opacity: _selected ? 1.0 : 0.5,
                        child: widget.labelWidget,
                      )
                    : Container(
                        child: widget.labelWidget,
                      ),
              ),
            ],
          ).paddingAll(Dimen.d_10),
        ),
      ),
    );
  }
}
