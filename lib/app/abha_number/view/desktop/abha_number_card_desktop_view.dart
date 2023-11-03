import 'package:abha/export_packages.dart';

class AbhaNumberCardDesktopView extends StatefulWidget {
  const AbhaNumberCardDesktopView({super.key});

  @override
  AbhaNumberCardDesktopViewState createState() =>
      AbhaNumberCardDesktopViewState();
}

class AbhaNumberCardDesktopViewState extends State<AbhaNumberCardDesktopView> {
  final AbhaNumberController _abhaNumberController = Get.find();

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
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.abhaAppIntro2,
      title: LocalizationHandler.of().createAbhaNumber,
      child: abhaNumberCardWidget(),
    );
  }

  Widget abhaNumberCardWidget() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        if (_abhaNumberController.responseHandler.status != Status.success) {
          return Container();
        } else {
          var data = _abhaNumberController.responseHandler.data ?? '';
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButtonBlueBorder.desktop(
                    text: LocalizationHandler.of().download,
                    onPressed: () async {
                      await _abhaNumberController.downloadFile(data);
                    },
                  ).marginOnly(
                    top: Dimen.d_30,
                  ),
                  ElevatedButtonBlueBorder.desktop(
                    text: LocalizationHandler.of().go_to_login,
                    onPressed: () {
                      bool isLogin = abhaSingleton.getAppData.getLogin();
                      String route = '';
                      if (isLogin) {
                        route = RoutePath.routeAccount;
                      } else {
                        route = RoutePath.routeLogin;
                      }
                      context.navigateGo(route);
                    },
                  ).marginOnly(
                    top: Dimen.d_30,
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }
}
