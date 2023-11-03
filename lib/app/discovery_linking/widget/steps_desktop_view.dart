import 'package:abha/export_packages.dart';

class StepsDesktopView extends StatelessWidget {
  final String? steps;
  final String title;
  final Color? bgColor;
  final Color? fgColor;
  final double radius;

  const StepsDesktopView({
    required this.title,
    super.key,
    this.steps,
    this.bgColor,
    this.fgColor,
    this.radius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        borderColor: AppColors.colorGrey4,
        color: AppColors.colorWhite,
        size: Dimen.d_0,
        isLow: true,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: radius,
                backgroundColor: bgColor ?? AppColors.colorGreyLight9,
                child: ClipOval(
                  child: Center(
                    child: Text(
                      steps ?? '',
                      style: CustomTextStyle.titleMedium(context)
                          ?.apply(color: fgColor ?? AppColors.colorGreyLight1),
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: CustomTextStyle.bodyMedium(context)?.apply(),
              ).marginOnly(left: Dimen.d_15),
            ],
          ).paddingSymmetric(vertical: Dimen.d_15, horizontal: Dimen.d_20),
          Divider(
            color: bgColor ?? AppColors.colorGrey4,
            height: 2,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
