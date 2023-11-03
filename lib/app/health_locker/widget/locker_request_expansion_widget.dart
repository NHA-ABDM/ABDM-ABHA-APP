import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/animated_widget/expanded_view.dart';

class LockerRequestExpansionWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool expanded;

  const LockerRequestExpansionWidget({
    required this.title,
    required this.child,
    super.key,
    this.expanded = false,
  });

  @override
  State<LockerRequestExpansionWidget> createState() =>
      _LockerRequestExpansionWidgetState();
}

class _LockerRequestExpansionWidgetState
    extends State<LockerRequestExpansionWidget> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    expanded = widget.expanded;
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
                        fontWeightDelta: (!expanded) ? 1 : -1,
                      ),
                    ),
                  ),
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
