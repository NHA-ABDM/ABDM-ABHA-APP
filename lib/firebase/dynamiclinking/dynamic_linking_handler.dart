import 'package:abha/app/abha_app.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkHandler {
  /// this function is used to setup the firebase config based on specific platform
  Future<void> initDynamicLinking() async {
    _dynamicLinks();
  }

  /// this function is used to get the link through which the app is opened
  Future<void> _dynamicLinks() async {
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    String deepLinkURL = _handleDeepLinkUrL(deepLink);
    String deepLinkURLQueryParameter =
        _handleDeepLinkQueryParameter(deepLink).toString();
    abhaLog.d(deepLinkURL);
    abhaLog.d(deepLinkURLQueryParameter);
  }

  String _handleDeepLinkUrL(var deepLink) {
    String data = '';
    if (deepLink != null) {
      data = deepLink.toString();
    }
    return data;
  }

  String? _handleDeepLinkQueryParameter(Uri? deepLink) {
    String? data = '';
    if (deepLink != null) {
      data = deepLink.queryParameters.toString();
    }
    return data;
  }
}
