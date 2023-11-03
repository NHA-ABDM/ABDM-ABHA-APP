import 'package:abha/export_packages.dart';

class StepsMobileView extends StatelessWidget {
  final String? steps;
  final String title;
  final IconData? icon;
  final Color? bgColor;
  final Color? fgColor;
  final double radius;

  const StepsMobileView({
    required this.title,
    super.key,
    this.steps,
    this.icon,
    this.bgColor,
    this.fgColor,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: bgColor ?? AppColors.colorGreyLight9,
          child: ClipOval(
            child: Validator.isNullOrEmpty(icon)
                ? Center(
                    child: Text(
                      steps ?? '',
                      style: CustomTextStyle.headlineSmall(context)
                          ?.apply(color: fgColor ?? AppColors.colorGreyLight1),
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.colorWhite,
                    size: Dimen.d_30,
                  ),
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontWeightDelta: 2,
            fontSizeDelta: -2,
          ),
        )
            .sizedBox(
              width: Dimen.d_70,
            )
            .marginOnly(top: Dimen.d_3),
      ],
    );
  }
}
