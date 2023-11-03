import 'package:abha/export_packages.dart';

class CustomExpandedCardView extends StatefulWidget {
  final Widget header;
  final Widget child;
  final bool isCurrentRoute;

  const CustomExpandedCardView({
    required this.header,
    required this.child,
    required this.isCurrentRoute,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomExpandedCardView> createState() => _CustomExpandedCardViewState();
}

class _CustomExpandedCardViewState extends State<CustomExpandedCardView> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isCurrentRoute ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            height: abhaSingleton.getAppData.showDrawer.value
                ? Dimen.d_60
                : Dimen.d_80,
            decoration: BoxDecoration(
              border: const Border(
                bottom: BorderSide(
                  color: AppColors.colorGreyLight7,
                  width: 1.5,
                ),
              ),
              color: isExpanded ? AppColors.colorPurple4 : AppColors.colorWhite,
            ),
            child: (abhaSingleton.getAppData.showDrawer.value)
                ? Row(
                    children: [
                      Container(
                        height: Dimen.d_60,
                        width: Dimen.d_8,
                        color: AppColors.colorPurple4,
                      ),
                      Expanded(
                        child: widget.header.paddingOnly(left: Dimen.d_12),
                      ),
                      Icon(
                        !isExpanded
                            ? Icons.keyboard_arrow_down_outlined
                            : Icons.keyboard_arrow_up_outlined,
                      ).marginOnly(left: Dimen.d_10, right: Dimen.d_8)
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        height: Dimen.d_80,
                        width: Dimen.d_8,
                        color: AppColors.colorPurple4,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: widget.header),
                            Icon(
                              !isExpanded
                                  ? Icons.keyboard_arrow_down_outlined
                                  : Icons.keyboard_arrow_up_outlined,
                            )
                          ],
                        ).paddingOnly(left: Dimen.d_12),
                      ),
                    ],
                  ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: isExpanded ? widget.child : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
