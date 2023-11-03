import 'package:abha/export_packages.dart';

class AppCheckBox extends StatelessWidget {
  final ValueChanged<bool?>? onChanged;
  final bool? value;
  final Widget title;
  final bool enable;
  final Color color;
  final CrossAxisAlignment crossAxisAlignment;

  const AppCheckBox({
    required this.value,
    required this.title,
    super.key,
    this.onChanged,
    this.enable = true,
    this.color = AppColors.colorGreyDark7,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: WidgetUtility.spreadWidgets(
        [
          SizedBox(
            height: Dimen.d_23,
            width: Dimen.d_23,
            child: Checkbox(
              activeColor: color,
              value: value,
              onChanged: enable ? onChanged : null,
            ),
          ),
          Expanded(child: title)
        ],
        interItemSpace: Dimen.d_8,
      ),
    );
  }
}
