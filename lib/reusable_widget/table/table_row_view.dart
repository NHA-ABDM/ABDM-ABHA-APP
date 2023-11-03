import 'package:abha/export_packages.dart';

class TableRowView extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onClick;
  final Color backgroundColor;

  const TableRowView({
    required this.children,
    required this.backgroundColor,
    Key? key,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        size: 0,
        borderColor: AppColors.colorTransparent,
        color: backgroundColor,
        isLow: true,
      ),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ).paddingSymmetric(vertical: Dimen.d_16, horizontal: Dimen.d_14),
        ),
      ),
    );
  }
}
