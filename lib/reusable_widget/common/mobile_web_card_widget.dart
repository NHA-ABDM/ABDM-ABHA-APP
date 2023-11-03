import 'package:abha/export_packages.dart';

class MobileWebCardWidget extends StatelessWidget {
  final Widget child;

  const MobileWebCardWidget({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: abhaSingleton.getBorderDecoration
          .getRectangularShapeBorder(size: Dimen.d_4),
      elevation: Dimen.d_1,
      child: child,
    ).paddingSymmetric(
      vertical: Dimen.d_16,
      horizontal:Dimen.d_16,
    );
  }
}
