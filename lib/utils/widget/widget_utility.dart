import 'package:flutter/material.dart';

/// [WidgetUtility] provides functionality to adding spacing between widgets and filter null views.

typedef Children = void Function(List<Widget>);

class WidgetUtility {
  static bool notNull(Object o) => o != null;

  static List<Widget> childrenBuilder(Children children) {
    List<Widget> children0 = [];

    children(children0);

    return children0.where(notNull).toList();
  }

  static List<Widget?> childrenFilter(List<Widget?> children) {
    return children.where((element) => element != null).toList();
  }

  static List<Widget> spreadWidgets(
    List<Widget?> widgets, {
    bool flowHorizontal = true,
    Color background = Colors.transparent,
    EdgeInsets padding = EdgeInsets.zero,
    double interItemSpace = 1,
    double? width,
    double? height,
  }) {
    List<Widget> spacedWidgets = [];
    List<Widget?> widgets0 = WidgetUtility.childrenFilter(widgets);
    for (int index = 0; index < widgets0.length; index++) {
      spacedWidgets.add(widgets0[index]!);
      if (index < (widgets0.length - 1)) {
        if (flowHorizontal) {
          spacedWidgets.add(
            SizedBox(
              width: interItemSpace, // widht of spacer
              child: Container(
                color: background,
                height: height,
                margin:
                    EdgeInsets.only(top: padding.top, bottom: padding.bottom),
              ),
            ),
          );
        } else {
          spacedWidgets.add(
            SizedBox(
              height: interItemSpace, // height of spacer
              child: Container(
                color: background,
                width: width,
                margin:
                    EdgeInsets.only(left: padding.left, right: padding.right),
              ),
            ),
          );
        }
      }
    }
    return spacedWidgets;
  }
}
