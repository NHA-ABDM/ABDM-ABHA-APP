import 'package:abha/export_packages.dart';

const double leftAlign = -1;
const double rightAlign = 1;

typedef OnTabSwitch = Function(int index);

class ConsentSwitchTabWidget extends StatefulWidget {
  final OnTabSwitch onTabSwitch;

  const ConsentSwitchTabWidget({required this.onTabSwitch, super.key});

  @override
  State<ConsentSwitchTabWidget> createState() => _ConsentSwitchTabWidgetState();
}

class _ConsentSwitchTabWidgetState extends State<ConsentSwitchTabWidget> {
  late double currentAlign;
  final double height = Dimen.d_45;
  int selectedIndex = 0;

  @override
  void initState() {
    currentAlign = leftAlign;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.colorAppBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimen.d_50),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(currentAlign, 0),
            duration: const Duration(milliseconds: 200),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.colorWhite,
                border: Border.all(color: AppColors.colorAppBlue),
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimen.d_50),
                ),
              ),
            ).sizedBox(width: width * 0.5, height: height),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currentAlign = leftAlign;
                selectedIndex = 0;
              });
              widget.onTabSwitch(0);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: ColoredBox(
                color: Colors.transparent,
                child: Text(
                  LocalizationHandler.of().tab_requests,
                  key: const Key(KeyConstant.requestedTab),
                  style: TextStyle(
                    color: (selectedIndex == 0)
                        ? AppColors.colorAppBlue
                        : AppColors.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).centerWidget.sizedBox(width: width * 0.5),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currentAlign = rightAlign;
                selectedIndex = 1;
              });
              widget.onTabSwitch(1);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: ColoredBox(
                color: Colors.transparent,
                child: Text(
                  LocalizationHandler.of().approved,
                  key: const Key(KeyConstant.approvedTab),
                  style: TextStyle(
                    color: (selectedIndex == 1)
                        ? AppColors.colorAppBlue
                        : AppColors.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).centerWidget.sizedBox(width: width * 0.5),
            ),
          ),
        ],
      ).sizedBox(width: width, height: height).centerWidget,
    );
  }
}
