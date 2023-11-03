import 'package:abha/export_packages.dart';

class TableHeaderView extends StatelessWidget {
  final List<Widget> children;

  const TableHeaderView({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        size: 0,
        borderColor: AppColors.colorAppBlue1,
        color: AppColors.colorAppBlue1,
        isLow: true,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ).paddingSymmetric(vertical: Dimen.d_16, horizontal: Dimen.d_14),
    );
  }
}
