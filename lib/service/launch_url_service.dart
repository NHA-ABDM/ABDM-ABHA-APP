import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

/// @Here abstract class LaunchURLService declares the method
/// [launchInBrowserLink] and [openInAppWebView] of type Future<void>.
abstract class LaunchURLService {
  /// launchInBrowserLink() opens the url in Browser and having params :-
  ///     [url] of type Uri.
  Future<void> launchInBrowserLink(Uri url);

  /// openInAppWebView() opens the url in WebView and having params :-
  ///     [context] of type BuildContext.
  ///     [title] of type String.
  ///     [url] of type String.
  Future<void> openInAppWebView(
    BuildContext context, {
    String? title,
    String? url,
  });
}

/// @Here class [LaunchURLServiceImpl] Implements  [LaunchURLService] class and defines the
/// function [launchInBrowserLink] and [openInAppWebView].

class LaunchURLServiceImpl implements LaunchURLService {
  @override
  Future<void> launchInBrowserLink(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Future<void> openInAppWebView(
    BuildContext context, {
    String? title,
    String? url,
    String? scopeType,
  }) async {
    if (kIsWeb) {
      launchInBrowserLink(Uri.parse(url ?? ''));
    } else {
      final arguments = {IntentConstant.title: title ?? '', IntentConstant.url: url ?? '',IntentConstant.sourceType : scopeType ?? ''};
      context.navigatePush(
        RoutePath.routeWebView,
        arguments: arguments,
      );
    }
  }
}
