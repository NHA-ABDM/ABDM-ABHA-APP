import 'package:abha/export_packages.dart';

class ViewDetailsCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onClick;
  final Color boxShadowColor;
  final Color borderColor;
  final Color backgroundColor;
  final double borderSize;
  final bool isDeskTopView;

  const ViewDetailsCard({
    required this.child,
    required this.onClick,
    Key? key,
    this.boxShadowColor = AppColors.colorGreyLight1,
    this.borderColor = AppColors.colorTransparent,
    this.backgroundColor = AppColors.colorWhite,
    this.borderSize = 6.0,
    this.isDeskTopView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        isLow: true,
        color: backgroundColor,
        borderColor: borderColor,
        boxShadowColor: boxShadowColor,
        size: borderSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Divider(
            height: Dimen.d_2,
            color: AppColors.colorPurple4,
          ).marginOnly(left: Dimen.d_8, right: Dimen.d_8),
          if (isDeskTopView)
            Expanded(
              child: viewDetailsButton(context)
                  .marginSymmetric(horizontal: Dimen.d_1),
            )
          else
            viewDetailsButton(context).marginSymmetric(horizontal: Dimen.d_1)
        ],
      ),
    );
  }

  Material viewDetailsButton(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(borderSize),
        bottomRight: Radius.circular(borderSize),
      ),
      child: InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.remove_red_eye_outlined,
              color: AppColors.colorBlueDark1,
            ).marginOnly(right: Dimen.d_6),
            Text(
              LocalizationHandler.of().viewDetails,
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorAppBlue),
            ),
          ],
        ).paddingSymmetric(horizontal: Dimen.d_10, vertical: Dimen.d_10),
      ),
    );
  }
}
