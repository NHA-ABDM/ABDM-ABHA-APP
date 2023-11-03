import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/webview/webview_abs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AbhaCardMobileView extends StatefulWidget {
  final ProfileModel? profileModel;

  const AbhaCardMobileView({super.key, this.profileModel});

  @override
  AbhaCardMobileViewState createState() => AbhaCardMobileViewState();
}

class AbhaCardMobileViewState extends State<AbhaCardMobileView>
    implements WebViewAbs {
  late AbhaCardController _abhaCardController;
  InAppWebViewController? inAppWebViewController;

  @override
  void initState() {
    super.initState();
    _abhaCardController = Get.put(AbhaCardController(AbhaCardRepoImpl()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onFetchAbhaCard();
    });
  }

  @override
  void dispose() {
    DeleteControllers().deleteAbhaCard();
    super.dispose();
  }

  /// fetch ABHA card by calling [callAbhaCard] metod in controller
  Future<void> _onFetchAbhaCard() async {
    await _abhaCardController.functionHandler(
      function: () => _abhaCardController.getAbhaCard(),
      isLoaderReq: true,
      isUpdateUi: true,
    );
  }

  @override
  void onWebViewCreated(inAppWebViewController) {
    this.inAppWebViewController = inAppWebViewController;
  }

  @override
  Widget build(BuildContext context) {
    return _abhaCardWidgetForMobile();
  }

  Widget _abhaCardWidgetForMobile() {
    return GetBuilder<AbhaCardController>(
      builder: (_) {
        var data = _abhaCardController.responseHandler.data ?? '';
        return Column(
          children: [
            if (Validator.isNullOrEmpty(data))
              Container()
            else
              Image.memory(
                Uint8List.fromList(_abhaCardController.phrCardImageList),
                width: context.width,
              ),
            if (!kIsWeb)
              ElevatedButtonBlueBorder.mobile(
                text: LocalizationHandler.of().shareAbhaCard,
                onPressed: () async {
                  await _abhaCardController.shareFile();
                },
              ).marginOnly(
                top: Dimen.d_10,
                left: Dimen.d_10,
                right: Dimen.d_10,
              ),
            ElevatedButtonBlueBorder.mobile(
              text: LocalizationHandler.of().viewDownloadCard,
              onPressed: () async {
                await _abhaCardController.downloadFile(
                  inAppWebViewController,
                );
              },
            ).marginOnly(
              top: Dimen.d_15,
              bottom: Dimen.d_10,
              left: Dimen.d_10,
              right: Dimen.d_10,
            ),
          ],
        );
      },
    );
  }
}
