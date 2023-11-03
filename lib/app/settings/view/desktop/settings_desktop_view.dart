import 'package:abha/export_packages.dart';

class SettingsDesktopView extends StatefulWidget {
  const SettingsDesktopView({super.key});

  @override
  SettingsDesktopViewState createState() => SettingsDesktopViewState();
}

class SettingsDesktopViewState extends State<SettingsDesktopView> {
  /// instance variable of SettingsController
  late SettingsController _settingsController;
  final List<String> _listData = [
    LocalizationHandler.of().setting_reset_password,
    LocalizationHandler.of().setting_submit_feeback,
    LocalizationHandler.of().setting_create_abha_number,
  ];

  @override
  void initState() {
    _settingsController = Get.find<SettingsController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.abhaLogo,
      title: LocalizationHandler.of().setting,
      child: _settingsWidget().sizedBox(height: context.height * 0.4),
    );
  }

  Widget _settingsWidget() {
    return Column(
      children: WidgetUtility.childrenBuilder((p0) {
        for (int i = 0; i < _listData.length; i++) {
          p0.add(
            Column(
              children: [
                ListTile(
                  title: Text(
                    _listData[i],
                    style: CustomTextStyle.titleMedium(context)?.apply(),
                  ),
                  onTap: () {
                    // String routePath='' ;
                    i == 0
                        ? context
                            .navigatePush(RoutePath.routeSettingsResetPassword)
                        : i == 1
                            ? context
                                .navigatePush(RoutePath.routeSubmitFeedback)
                            : i == 2
                                ? CreateAbhaNumberUrl.abhaNumberCreateViaWeb(
                                    context,
                                  )
                                : context
                                    .navigatePush(RoutePath.routeNotification);
                  },
                ),
                const Divider(
                  color: AppColors.colorGreyLight1,
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
