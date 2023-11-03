part of 'extension.dart';

extension ExtBuildContext on BuildContext {
  ThemeData get themeData => Theme.of(this);

  MediaQueryData get mediaQuerySize => MediaQuery.of(this);

  double get height => mediaQuerySize.size.height;

  double get bottomPadding => mediaQuerySize.padding.bottom;

  double get width => mediaQuerySize.size.width;

  double get devicePixelRatio => mediaQuerySize.devicePixelRatio;

  String get currentPath => GoRouter.of(this).location;

  /// performs a simple [Navigator.pop] action and returns given [result]
  void navigateBack({dynamic result}) => GoRouter.of(this).pop(result);

  bool navigateCanPop() => GoRouter.of(this).canPop();

  Future<dynamic> navigateBackAndPush(String location, {var arguments}) async {
    navigateBack();
    navigatePush(location, arguments: arguments);
  }

  /// performs a simple [Navigator.push] action with given [route]
  Future<dynamic> navigateToScreen(
    Widget screen, {
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    return Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            screen,
        transitionDuration: duration,
      ),
    );
  }

  String navigateNamedLocation(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    return GoRouter.of(this).namedLocation(
      name,
      params: params,
      queryParams: queryParams,
    );
  }

  void navigateGoNamedLocation(
    String name, {
    Object? arguments,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    GoRouter.of(this).go(
      navigateNamedLocation(name, params: params, queryParams: queryParams),
      extra: arguments,
    );
  }

  void navigateGo(String location, {Object? arguments}) =>
      GoRouter.of(this).go(location, extra: arguments);

  void navigateGoNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? arguments,
  }) =>
      GoRouter.of(this).goNamed(
        name,
        params: params,
        queryParams: queryParams,
        extra: arguments,
      );

  Future<dynamic> navigatePush(String location, {var arguments}) async {
    return GoRouter.of(this).push(location, extra: arguments);
    // return Navigator.of(this).push(screen);
  }

  Future<dynamic> navigatePushNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? arguments,
  }) async {
    return GoRouter.of(this).pushNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: arguments,
    );
    // return Navigator.pushNamed(this, name, arguments: arguments);
  }

  void navigatePushReplacement(String location, {Object? arguments}) =>
      GoRouter.of(this).pushReplacement(location, extra: arguments);

  Future<dynamic> navigatePushReplacementNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? arguments,
  }) async {
    return GoRouter.of(this).pushReplacementNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: arguments,
    );
    // return Navigator.pushReplacementNamed(this, name, arguments: arguments);
  }

  void navigateReplace(String location, {Object? arguments}) =>
      GoRouter.of(this).replace(location, extra: arguments);

  void navigateReplaceNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? arguments,
  }) =>
      GoRouter.of(this).replaceNamed(name, extra: arguments);

  Future<dynamic> openDialog(
    Widget screen, {
    bool barrierDismissible = false,
    bool backDismissible = false,
  }) async {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: this,
      builder: (_) => WillPopScope(
        onWillPop: () => Future.value(backDismissible),
        child: screen,
      ),
    );
  }
}
