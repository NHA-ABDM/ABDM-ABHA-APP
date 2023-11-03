import 'package:abha/export_packages.dart';

class ConsentEditCheckBoxWidget extends StatelessWidget {
  final ValueChanged<bool?>? onChanged;
  final bool? value;
  final Widget title;
  final bool enable;
  final Color color;
  final Widget iconEnabledWidget;
  final void Function()? onTap;
  final Widget iconDisabledWidget;
  final bool isDesktopView;

  const ConsentEditCheckBoxWidget({
    required this.value,
    required this.title,
    required this.iconEnabledWidget,
    required this.iconDisabledWidget,
    super.key,
    this.onChanged,
    this.enable = true,
    this.color = AppColors.colorAppBlue,
    this.onTap,
    this.isDesktopView = false,
  });

  @override
  Widget build(BuildContext context) {
    return isDesktopView
        ? InkWell(
            onTap: enable ? onTap : null,
            child: DecoratedBox(
              decoration:
                  abhaSingleton.getBorderDecoration.getRectangularBorder(
                borderColor: AppColors.colorPurple2,
                color: value! ? AppColors.colorPurple2 : AppColors.colorWhite,
                size: Dimen.d_0,
                //isLow: true,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: WidgetUtility.spreadWidgets(
                  [
                    Checkbox(
                      activeColor: color,
                      value: value,
                      onChanged: enable ? onChanged : null,
                    )
                        .sizedBox(height: Dimen.d_25, width: Dimen.d_25)
                        .marginOnly(left: Dimen.d_10, right: Dimen.d_0),
                    title,
                    if (value!) iconEnabledWidget else iconDisabledWidget
                  ],
                  interItemSpace: Dimen.d_10,
                ),
              ).paddingAll(Dimen.d_12),
            ),
          )
        : InkWell(
            onTap: enable ? onTap : null,
            child: Column(
              children: [
                DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    borderColor: AppColors.colorWhite,
                    color:
                        value! ? AppColors.colorPurple2 : AppColors.colorWhite,
                    size: Dimen.d_0,
                    //isLow: true,
                  ),
                  child: Row(
                    children: WidgetUtility.spreadWidgets(
                      [
                        Checkbox(
                          activeColor: color,
                          value: value,
                          onChanged: enable ? onChanged : null,
                        )
                            .sizedBox(height: Dimen.d_65, width: Dimen.d_25)
                            .marginOnly(left: Dimen.d_10, right: Dimen.d_10),
                        if (isDesktopView)
                          title
                        else
                          Expanded(flex: 1, child: title),
                        if (value!) iconEnabledWidget else iconDisabledWidget
                      ],
                      interItemSpace: Dimen.d_10,
                    ),
                  ).paddingOnly(top: Dimen.d_0, bottom: Dimen.d_0),
                ),
                Container(
                  height: Dimen.d_1,
                  color: AppColors.colorGreyLight7,
                )
              ],
            ),
          );
  }
}
