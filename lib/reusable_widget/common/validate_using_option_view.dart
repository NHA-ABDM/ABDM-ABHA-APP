import 'package:abha/export_packages.dart';

class ValidateUsingOptionView extends StatelessWidget {
  final VoidCallback onClick;
  final bool selectedValidationMethod;
  final String text;
  final String icon;
  final double? iconWidth;
  final double? iconHeight;

  const ValidateUsingOptionView({
    required this.onClick,
    required this.text,
    required this.icon,
    super.key,
    this.selectedValidationMethod = false,
    this.iconWidth,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: context.width * 0.38,
      // height: context.width * 0.38,
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        size: Dimen.d_5,
        color: selectedValidationMethod
            ? AppColors.colorGreyLight4
            : AppColors.colorWhite,
        borderColor: AppColors.colorGreyLight7,
      ),
      child: Material(
        color: selectedValidationMethod
            ? AppColors.colorGreyLight4
            : AppColors.colorWhite,
        child: InkWell(
          onTap: onClick,
          child: Column(
            children: [
              CustomCircularBackground(
                image: icon,
                width: iconWidth,
                height: iconHeight,
              ),
              Container(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.bodySmall(context),
                ).marginOnly(top: Dimen.d_1),
              ),
            ],
          ).paddingSymmetric(vertical: Dimen.d_25, horizontal: Dimen.d_25),
        ),
      ),
    );
  }
}
