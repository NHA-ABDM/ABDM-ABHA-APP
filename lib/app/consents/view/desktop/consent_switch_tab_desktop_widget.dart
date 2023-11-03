import 'package:abha/export_packages.dart';

const double leftAlign = -1;
const double rightAlign = 1;

typedef OnTabSwitch = Function(int index);

class ConsentSwitchTabDesktopWidget extends StatefulWidget {
  final OnTabSwitch onTabSwitch;
  final int index;

  const ConsentSwitchTabDesktopWidget({
    required this.onTabSwitch,
    required this.index,
    super.key,
  });

  @override
  State<ConsentSwitchTabDesktopWidget> createState() =>
      _ConsentSwitchTabDesktopWidgetState();
}

class _ConsentSwitchTabDesktopWidgetState
    extends State<ConsentSwitchTabDesktopWidget> {
  late double currentAlign;
  final double height = Dimen.d_50;
  int selectedIndex = 0;
  Color activatedColor = AppColors.colorWhite;
  Color deActivatedColor = AppColors.colorGreyLight11;

  @override
  void initState() {
    selectedIndex = widget.index;
    currentAlign = selectedIndex == 1 ? rightAlign : leftAlign;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.30;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: deActivatedColor,
        border: Border.all(color: AppColors.colorGreyWildSand),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimen.d_6),
          topRight: Radius.circular(Dimen.d_6),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(currentAlign, 0),
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.colorAppBlue1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimen.d_6),
                  topRight: Radius.circular(Dimen.d_6),
                ),
              ),
            ),
          ),
          Row(
            children: [
              InkResponse(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                    currentAlign = leftAlign;
                  });
                  widget.onTabSwitch(0);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            LocalizationHandler.of().tab_requests,
                            style: CustomTextStyle.titleSmall(context)?.apply(
                              color: (selectedIndex == 0)
                                  ? activatedColor
                                  : AppColors.colorBlack,
                              fontSizeDelta: 1,
                            ),
                          ).centerWidget,
                        ),
                        Container(
                          height: Dimen.d_4,
                          color: (selectedIndex == 0)
                              ? AppColors.colorAppOrange
                              : AppColors.colorGreyDark8,
                        )
                      ],
                    ),
                  ).sizedBox(width: width * 0.5),
                ),
              ),
              InkResponse(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    currentAlign = rightAlign;
                  });
                  widget.onTabSwitch(1);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            LocalizationHandler.of().approved,
                            style: CustomTextStyle.titleSmall(context)?.apply(
                              color: (selectedIndex == 1)
                                  ? activatedColor
                                  : AppColors.colorBlack,
                              fontSizeDelta: 1,
                            ),
                          ).centerWidget,
                        ),
                        Container(
                          height: Dimen.d_4,
                          color: (selectedIndex == 1)
                              ? AppColors.colorAppOrange
                              : AppColors.colorGreyDark8,
                        )
                      ],
                    ),
                  ).sizedBox(width: width * 0.5),
                ),
              ),
            ],
          )
        ],
      ).sizedBox(width: width, height: height),
    );
  }
}
