import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/animated_widget/expanded_view.dart';

class ConsentLinkedProvidersSelectionWidget extends StatefulWidget {
  final Widget header;
  final Widget child;

  const ConsentLinkedProvidersSelectionWidget({
    required this.header,
    required this.child,
    super.key,
  });

  @override
  State<ConsentLinkedProvidersSelectionWidget> createState() =>
      _ConsentLinkedProvidersSelectionWidgetState();
}

class _ConsentLinkedProvidersSelectionWidgetState
    extends State<ConsentLinkedProvidersSelectionWidget> {
  bool expanded = false;

  @override
  void initState() {
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
          ColoredBox(
            color: AppColors.colorGreyLight4,
            child: Row(
              children: WidgetUtility.spreadWidgets(
                [
                  Expanded(
                    child: InkWell(
                      child: widget.header,
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Icon(
                      expanded
                          ? IconAssets.navigateUp
                          : IconAssets.navigateDown,
                      color: AppColors.colorAppBlue,
                    ),
                  )
                ],
                interItemSpace: Dimen.d_10,
              ),
            ).paddingAll(Dimen.d_10),
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
