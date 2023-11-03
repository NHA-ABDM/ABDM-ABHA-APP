import 'package:abha/app/abha_app.dart';
import 'package:flutter/material.dart';

class RouteObserverCustom extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    abhaLog.d('Route didPush: $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    abhaLog.d('Route didPop: $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    abhaLog.d('Route didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    abhaLog.d('Route didReplace: $newRoute');
  }
}
