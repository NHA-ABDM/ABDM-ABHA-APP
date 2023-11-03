import 'package:abha/export_packages.dart';

class ValidateAuthOptionView extends StatelessWidget {
  final VoidCallback onClick;
  final bool isSelected;
  final String text;
  final String icon;
  final double? iconWidth;
  final double? iconHeight;

  const ValidateAuthOptionView({
    required this.onClick,
    required this.text,
    required this.icon,
    super.key,
    this.isSelected = false,
    this.iconWidth,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.43,
      height: Dimen.d_150,
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        size: Dimen.d_5,
        color: isSelected ? AppColors.colorGreyLight4 : AppColors.colorWhite,
        borderColor: AppColors.colorGreyLight7,
      ),
      child: Material(
        color: isSelected ? AppColors.colorGreyLight4 : AppColors.colorWhite,
        child: InkWell(
          onTap: onClick,
          child: Column(
            children: [
              CustomCircularBackground(
                image: icon,
                width: iconWidth,
                height: iconHeight,
              ),
              Flexible(
                child: Text(
                  text,
                  style: CustomTextStyle.bodySmall(context),
                ).marginOnly(top: Dimen.d_15),
              ),
            ],
          ).paddingAll(Dimen.d_10),
        ),
      ),
    );
  }
}
