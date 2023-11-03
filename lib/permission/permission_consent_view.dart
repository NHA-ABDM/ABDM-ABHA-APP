import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class PermissionConsentView extends StatefulWidget {
  const PermissionConsentView({super.key});

  @override
  PermissionConsentViewState createState() => PermissionConsentViewState();
}

class PermissionConsentViewState extends State<PermissionConsentView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkForPermission() async {
    bool isStoragePermission =
        await PermissionHandler.requestStoragePermission();
    bool isCameraPermission = await PermissionHandler.requestCameraPermission();
    bool isLocationPermission =
        await PermissionHandler.requestLocationPermission();
    if (!kIsWeb) {
      await PermissionHandler.requestPushNotificationPermission();
    }

    return isStoragePermission && isCameraPermission && isLocationPermission;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().app_permission,
      isTopSafeArea: true,
      type: PermissionConsentView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: _consentWidget(),
    );
  }

  Widget _consentWidget() {
    return ColoredBox(
      color: AppColors.colorWhite2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomSvgImageView(
            ImageLocalAssets.appPermissionImg,
            height: context.height * 0.3,
          ),
          Container(
            height: context.height * 0.55,
            decoration:
                abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
              topLeft: Dimen.d_20,
              topRight: Dimen.d_20,
              bottomLeft: 0,
              bottomRight: 0,
              color: AppColors.colorAppBlue1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [titleAndDetailsOfPermission(), rowButtons()],
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget titleAndDetailsOfPermission() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            appPermissionView(
              LocalizationHandler.of().cameraQrcode,
              LocalizationHandler.of().cameraQrcodeContent,
            ),
            appPermissionView(
              LocalizationHandler.of().dataSharing,
              LocalizationHandler.of().dataSharingContent,
            ).marginOnly(top: Dimen.d_20),
            appPermissionView(
              LocalizationHandler.of().accessExternal,
              LocalizationHandler.of().accessExternalContent,
            ).marginOnly(top: Dimen.d_20),
            appPermissionView(
              LocalizationHandler.of().gps,
              LocalizationHandler.of().gpsContent,
            ).marginOnly(top: Dimen.d_20),
          ],
        ).marginOnly(bottom: Dimen.d_10),
      ).paddingOnly(top: Dimen.d_40),
    );
  }

  Widget rowButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: WidgetUtility.spreadWidgets(
        [
          TextButtonPurple.mobile(
            text: LocalizationHandler.of().decline,
            onPressed: () async {
              exitApp();
            },
          ).expand(),
          TextButtonOrange.mobile(
            text: LocalizationHandler.of().agree,
            onPressed: () async {
              checkForPermission().then((value) {
                if (!value) {
                  CustomDialog.showPopupDialog(
                    LocalizationHandler.of().permissionDialogMsg,
                    positiveButtonTitle: LocalizationHandler.of().okay,
                    onPositiveButtonPressed: CustomDialog.dismissDialog,
                  );
                } else {
                  abhaSingleton.getSharedPref
                      .set(SharedPref.isPermissionConsent, true);
                  context.navigateGo(RoutePath.routeAppIntro);
                }
              });
            },
          ).expand(),
        ],
        interItemSpace: Dimen.d_16,
      ),
    ).marginOnly(
      bottom: context.bottomPadding + Dimen.d_16,
      left: Dimen.d_16,
      right: Dimen.d_16,
      top: Dimen.d_16,
    );
  }

  Widget appPermissionView(
    String title,
    String description, {
    String? image,
    Color? color = AppColors.colorWhite,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          GradientBackground(
            child: Image.asset(
              image,
              width: Dimen.d_300,
              height: Dimen.d_300,
              fit: BoxFit.contain,
            ).centerWidget,
          )
        else
          Container(),
        Text(
          title,
          style: CustomTextStyle.bodyLarge(context)?.apply(color: color),
        ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
        Text(
          description,
          style: CustomTextStyle.bodyMedium(context)?.apply(
            fontWeightDelta: -1,
            color: color,
            fontSizeDelta: -1,
            heightDelta: .3,
          ),
          textAlign: TextAlign.justify,
        ).marginOnly(top: Dimen.d_12, left: Dimen.d_20, right: Dimen.d_20),
      ],
    );
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
