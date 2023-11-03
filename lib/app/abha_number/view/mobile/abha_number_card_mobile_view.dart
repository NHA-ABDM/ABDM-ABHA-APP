import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberCardMobileView extends StatefulWidget {
  const AbhaNumberCardMobileView({super.key});

  @override
  AbhaNumberCardMobileViewState createState() =>
      AbhaNumberCardMobileViewState();
}

class AbhaNumberCardMobileViewState extends State<AbhaNumberCardMobileView> {
  final AbhaNumberController _abhaNumberController =
      Get.find<AbhaNumberController>();

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
    return abhaNumberCardWidget().paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_15);
  }

  Widget abhaNumberCardWidget() {
    return Column(
      children: [
        Image.memory(
          Uint8List.fromList(_abhaNumberController.abhaCardImageList),
          fit: BoxFit.cover,
        ).sizedBox(width: context.width, height: context.height * 0.55),
        Column(
          children: [
            ElevatedButtonBlueBorder.mobile(
              text: LocalizationHandler.of().download,
              onPressed: () async {
                await _abhaNumberController
                    .downloadFile(_abhaNumberController.abhaCardImageList);
              },
            ).marginOnly(top: Dimen.d_30),
            ElevatedButtonBlueBorder.mobile(
              text: abhaSingleton.getAppData.getLogin()
                  ? LocalizationHandler.of().go_to_home
                  : LocalizationHandler.of().go_to_login,
              onPressed: () {
                bool isLogin = abhaSingleton.getAppData.getLogin();
                String route = '';
                if (isLogin) {
                  route = RoutePath.routeDashboard;
                } else {
                  route = RoutePath.routeAppIntro;
                }
                context.navigateGo(route);
              },
            ).marginOnly(top: Dimen.d_20),
          ],
        )
      ],
    );
  }
}
