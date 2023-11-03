import 'package:abha/export_packages.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  late SplashController _splashController;

  @override
  void initState() {
    _init();
    _checkDeviceSafety();
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteSplash();
    super.dispose();
  }

  void _init() {
    _splashController = Get.put(SplashController(SplashRepoImpl()));
  }

  void _checkDeviceSafety() {
    final isTest = Validator.isTestRunning();
    _splashController.checkAppSafety().then((isSafeDevice) async {
      if (isSafeDevice && !isTest) {
        _splashController.checkRemoteConfig(context);
      } else {
        CustomDialog.showPopupDialog(
          backDismissible: false,
          'Device Not Safe',
          positiveButtonTitle: LocalizationHandler.of().ok.toUpperCase(),
          onPositiveButtonPressed: () {
            CustomDialog.dismissDialog();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isAppBar: false,
      type: SplashView,
      bodyMobile: _splashScreenWidget(),
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }

  Widget _splashScreenWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          image: ImageLocalAssets.abhaLogo,
          width: Dimen.d_150,
          height: Dimen.d_150,
        ),
        Text(
          LocalizationHandler.of().yourhealthyourchoice,
          style: CustomTextStyle.bodyLarge(context)?.apply(
            color: AppColors.colorBlack,
          ),
        ).marginOnly(top: Dimen.d_10),
      ],
    ).alignAtCenter();
  }
}
