import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';
import 'package:abha/reusable_widget/webview/webview_abs.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomWebView extends StatefulWidget {
  final Map arguments;

  const CustomWebView({required this.arguments, super.key});

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  late String _title;
  late String _urlOrHtmlData;
  late String _sourceType;
  bool? _isAppBar;
  bool _isLoading = true;
  late InAppWebViewController _inAppWebViewController;
  WebViewAbs? _abhaCardAbs;
  double progress = 0;

  @override
  void initState() {
    _title = widget.arguments[IntentConstant.title] ?? '';
    _urlOrHtmlData = widget.arguments[IntentConstant.url];
    _sourceType = widget.arguments[IntentConstant.sourceType] ?? '';
    _isAppBar = widget.arguments[IntentConstant.appBar];
    _abhaCardAbs = widget.arguments[IntentConstant.object];
    abhaLog.e(_urlOrHtmlData);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initWebViewController() {
    _abhaCardAbs?.onWebViewCreated(_inAppWebViewController);
    _inAppWebViewController.addJavaScriptHandler(
      handlerName: 'ABHA-PHR',
      callback: (args) {
        return args.reduce((curr, next) => curr + next);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      paddingValueMobile: Dimen.d_0,
      isAppBar: _isAppBar ?? true,
      title: _title,
      type: CustomWebView,
      bodyMobile: webView(),
    );
  }

  Widget webView() {
    return Stack(
      children: [
        InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform:
                InAppWebViewOptions(useShouldOverrideUrlLoading: true),
          ),
          // initialUrlRequest: URLRequest(
          //   url: _sourceType.contains(StringConstants.html)
          //       ? Uri.dataFromString(
          //           base64Encode(const Utf8Encoder().convert(_urlOrHtmlData ?? '')),
          //           mimeType: 'text/html',
          //           encoding: Encoding.getByName('utf-8')
          //         )
          //       : Uri.parse(_urlOrHtmlData),
          // ),
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          onWebViewCreated: (controller) async {
            _inAppWebViewController = controller;
            _initWebViewController();
            if (_sourceType.contains(StringConstants.html)) {
              _inAppWebViewController.loadData(data: _urlOrHtmlData);
            } else {
              _inAppWebViewController.loadUrl(
                urlRequest: URLRequest(
                  url: Uri.parse(_urlOrHtmlData),
                ),
              );
            }
          },
          onLoadStart: (controller, url) {},
          onLoadStop: (controller, url) {},
          onProgressChanged: (InAppWebViewController controller, int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
            // setState(() {
            //   this.progress = progress / 100;
            // });
          },
          onReceivedServerTrustAuthRequest: (
            InAppWebViewController controller,
            URLAuthenticationChallenge challenge,
          ) async {
            return ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            );
          },
          onConsoleMessage: (
            InAppWebViewController controller,
            ConsoleMessage consoleMessage,
          ) {
            abhaLog.i('console message: ${consoleMessage.message}');
          },
          // shouldOverrideUrlLoading:
          //     (controller, shouldOverrideUrlLoadingRequest) async {
          //   Uri url = shouldOverrideUrlLoadingRequest.request.url ?? Uri();
          //   // var uri = Uri.parse(url);
          //   if ((url.toString()).startsWith('https://google.com')) {
          //     return ShouldOverrideUrlLoadingAction.ALLOW;
          //   } else {
          //     // launchURL(uri.toString());
          //     return ShouldOverrideUrlLoadingAction.CANCEL;
          //   }
          // },
        ).sizedBox(
          height: context.height,
          width: context.width,
        ),
        if (_isLoading) const CustomLoadingView() else const SizedBox.shrink(),
      ],
    );
  }
}
