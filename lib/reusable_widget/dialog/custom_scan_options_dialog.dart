import 'package:abha/app/token/token_controller.dart';
import 'package:abha/export_packages.dart';

class CustomScanOptionDialog {
  final QrCodeScannerController _qrCodeController =
      Get.put(QrCodeScannerController(QrCodeScannerRepoImpl()));
  final TokenController _tokenController = Get.find<TokenController>();

  /// @Here is the function to open dialog for showing options
  /// [Gallery] and [Camera] Scanning Qr code.
  Future<dynamic> scanOptionPopUp(BuildContext context, dynamic widget) async {
    bool? isDataShared = await context.openDialog(
      CustomSimpleDialog(
        size: 10,
        title: _tokenController.remainsTimeInSeconds > 0
            ? LocalizationHandler.of().alert
            : LocalizationHandler.of().scanOptions,
        paddingLeft: Dimen.d_15,
        showCloseButton: true,
        child: (_tokenController.remainsTimeInSeconds > 0)
            ? Text(
                LocalizationHandler.of().tokenGen,
                style: CustomTextStyle.bodyMedium(context)
                    ?.apply(color: AppColors.colorGreyDark3),
                textAlign: TextAlign.justify,
              ).paddingOnly(
                left: Dimen.d_30,
                right: Dimen.d_30,
                bottom: Dimen.d_30,
              )
            : Column(
                children: [
                  Text(
                    LocalizationHandler.of().scanAndShareSubtext,
                    style: CustomTextStyle.titleSmall(context)
                        ?.apply(color: AppColors.colorGreyDark3),
                    textAlign: TextAlign.justify,
                  ).paddingSymmetric(horizontal: Dimen.d_30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          PermissionHandler.requestCameraPermission()
                              .then((enabled) {
                            if (enabled) {
                              context
                                  .navigatePush(RoutePath.routeQrCodeScanner)
                                  .then((isDataShared) {
                                context.navigateBack(
                                  result: isDataShared ?? false,
                                );
                              });
                            } else {
                              context.navigateBack(result: false);
                              MessageBar.showToastDialog(
                                LocalizationHandler.of()
                                    .provideCameraPermission,
                              );
                            }
                          });
                        },
                        child: _commonWidget(
                          context,
                          LocalizationHandler.of().scanQrViaCamera,
                          ImageLocalAssets.optionQrScanCameraIconSvg,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pickAndValidateImageFile(
                            context,
                            ImageSource.gallery,
                            widget,
                          );
                        },
                        child: _commonWidget(
                          context,
                          LocalizationHandler.of().scanQrViaGallery,
                          ImageLocalAssets.optionQrScanGalleryIconSvg,
                        ),
                      )
                    ],
                  ).paddingSymmetric(
                    vertical: Dimen.d_10,
                    horizontal: Dimen.d_20,
                  ),
                ],
              ),
      ),
    );
    return Future.value(isDataShared);
  }

  Widget _commonWidget(
    BuildContext context,
    String text,
    String icon,
  ) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        color: AppColors.colorGreyLight10,
        borderColor: AppColors.colorGreyLight6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSvgImageView(
            icon,
            width: Dimen.d_43,
            height: Dimen.d_43,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: CustomTextStyle.labelMedium(context)?.apply(
              color: AppColors.colorBlack6,
              fontWeightDelta: 2,
            ),
          ).marginOnly(top: Dimen.d_10)
        ],
      ),
    )
        .paddingSymmetric(vertical: Dimen.d_10, horizontal: Dimen.d_10)
        .sizedBox(width: Dimen.d_150, height: Dimen.d_150);
  }

  /// @Here is the function to pick the Qr-Code image from gallery
  Future<dynamic> _pickAndValidateImageFile(
    BuildContext context,
    ImageSource source,
    dynamic widget,
  ) async {
    final ImagePicker picker = ImagePicker();
    picker
        .pickImage(
      source: source,
      imageQuality: 50,
    )
        .then((imagePath) {
      if (Validator.isNullOrEmpty(imagePath)) {
        context.navigateBack(result: false);
        // MessageBar.showToastDialog(LocalizationHandler.of().invalidQrFile);
      } else {
        QRCaptureController.getQrCodeByImagePath(imagePath?.path ?? '')
            .then((qrCodeResult) {
          if (Validator.isNullOrEmpty(qrCodeResult)) {
            context.navigateBack(result: false);
            MessageBar.showToastDialog(LocalizationHandler.of().invalidQrCode);
          } else {
            String? captureText = qrCodeResult.join('\n');
            bool isValidQrCodeData =
                _qrCodeController.getQrCodeDataHandler(captureText);
            if (isValidQrCodeData) {
              String hipId = _qrCodeController.hipId ?? '';
              String counterId = _qrCodeController.counterId ?? '';
              var arguments = {
                IntentConstant.hipId: hipId,
                IntentConstant.counterId: counterId
              };
              context
                  .navigatePush(
                RoutePath.routeShareProfile,
                arguments: arguments,
              )
                  .then((isDataShared) {
                context.navigateBack(result: isDataShared ?? false);
              });
            } else {
              context.navigateBack(result: false);
              MessageBar.showToastDialog(
                LocalizationHandler.of().invalidQrCode,
              );
            }
          }
        });
      }
    });
  }
}
