import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/animated_widget/expanded_view.dart';

class ConsentLockerRequestExpansionWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool showArrow;
  final bool expanded;

  const ConsentLockerRequestExpansionWidget({
    required this.title,
    required this.child,
    super.key,
    this.showArrow = false,
    this.expanded = false,
  });

  @override
  State<ConsentLockerRequestExpansionWidget> createState() =>
      _ConsentLockerRequestExpansionWidgetState();
}

class _ConsentLockerRequestExpansionWidgetState
    extends State<ConsentLockerRequestExpansionWidget> {
  bool expanded = false;

  @override
  void initState() {
    expanded = widget.expanded;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: WidgetUtility.spreadWidgets(
        [
          GestureDetector(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: WidgetUtility.spreadWidgets(
                [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: CustomTextStyle.titleLarge(context)?.apply(
                        fontWeightDelta: (!expanded) ? 2 : -1,
                        color: (!expanded)
                            ? AppColors.colorAppBlue
                            : AppColors.colorBlack,
                      ),
                    ),
                  ),
                  if (widget.showArrow)
                    Icon(
                      expanded
                          ? IconAssets.navigateUp
                          : IconAssets.navigateDown,
                    )
                ],
                interItemSpace: Dimen.d_10,
              ),
            ).paddingSymmetric(vertical: Dimen.d_15),
          ),
          ExpandedView(
            expand: expanded,
            child: widget.child,
          ),
        ],
        interItemSpace: Dimen.d_0,
        flowHorizontal: false,
      ),
    );
  }
}
