import 'package:abha/export_packages.dart';

class CustomDesktopBackView extends StatelessWidget {
  final Color backgroundColor;
  final double width;
  const CustomDesktopBackView({
    Key? key,
    this.backgroundColor = AppColors.colorWhite,
    this.width = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateBack();
      },
      child: Text(
        LocalizationHandler.of().back,
        style: CustomTextStyle.bodyMedium(context)?.apply(
          color: AppColors.colorAppBlue1,
          decoration: TextDecoration.underline,
        ),
      ).alignAtTopLeft(),
    );
    //   TextButtonCustom(
    //   width: width,
    //   fontSizeDelta: -1,
    //   text: MaterialLocalizations.of(context).backButtonTooltip,
    //   onPressed: () {
    //     context.navigateBack();
    //   },
    //   leadingIcon: IconAssets.navigatePrv,
    //   backgroundColor: backgroundColor,
    //   borderColor: backgroundColor,
    // ).alignAtTopLeft();
  }
}
