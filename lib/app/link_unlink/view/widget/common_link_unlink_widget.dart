import 'package:abha/export_packages.dart';

class CommonLinkUnlinkWidget extends StatelessWidget {
  final String image;
  final Widget child;

  const CommonLinkUnlinkWidget({
    required this.image,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 4,
            child: CustomSvgImageView(
              image,
              height: Dimen.d_260,
            ).centerWidget,
          ),
          Container(
            width: Dimen.d_1,
            color: AppColors.colorGreyWildSand,
          ).marginSymmetric(vertical: Dimen.d_10),
          Expanded(
            flex: 6,
            child: child.marginSymmetric(
              vertical: Dimen.d_20,
              horizontal: Dimen.d_30,
            ),
          )
        ],
      ),
    );
  }
}
