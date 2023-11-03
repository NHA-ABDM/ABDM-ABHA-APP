import 'package:abha/export_packages.dart';

class CustomPopUpMenuButtonView extends StatelessWidget {
  final String? tooltip;
  final String title;
  final String? icon;
  final String? image;
  final PopupMenuItemSelected? onSelected;
  final PopupMenuItemBuilder itemBuilder;
  final double? iconSize;
  final Color? titleColor;
  final Color? bgColor;
  final bool showArrow;
  final double? shapeSize;
  final Widget? widget;
  final bool isReqArrowCenter;
  final Widget? leading;

  const CustomPopUpMenuButtonView({
    required this.title,
    required this.itemBuilder,
    super.key,
    this.tooltip = '',
    this.icon,
    this.image,
    this.onSelected,
    this.iconSize,
    this.titleColor,
    this.bgColor,
    this.showArrow = true,
    this.shapeSize,
    this.widget,
    this.isReqArrowCenter = true, this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPopupButton(context);
  }

  PopupMenuButton _buildPopupButton(BuildContext context) {
    return PopupMenuButton(
      tooltip: tooltip,
      color: bgColor ?? AppColors.colorBlueDark1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(shapeSize ?? Dimen.d_0),
        ),
      ),
      offset: Offset(-Dimen.d_20, Dimen.d_60),
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
      child: Row(

        children: [
          if (!Validator.isNullOrEmpty(leading))
            Container(child: leading),
          Row(
            crossAxisAlignment: isReqArrowCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: CustomTextStyle.titleSmall(context)?.apply(color: titleColor ?? AppColors.colorWhite),
                  ).marginOnly(left: Dimen.d_5),
                  Container(
                    child: widget,
                  ).marginOnly(left: Dimen.d_5)
                ],
              ).marginOnly(left: Dimen.d_5),
              if (showArrow)
                Icon(
                  IconAssets.navigateDown,
                  size: Dimen.d_18,
                  color: titleColor ?? AppColors.colorWhite,
                ).marginOnly(left: Dimen.d_4),
            ],
          )
        ],
      ),
    );
  }
}
