import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    if (!kIsWeb && abhaSingleton.getAppData.getLogin()) {
      RoutePath.routeDashboard = RoutePath.routeDefault;
      abhaSingleton.getAppData.setRouterGenerator();
    }
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}
