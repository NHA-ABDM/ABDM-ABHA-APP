import 'package:abha/export_packages.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerView extends StatefulWidget {
  const QrCodeScannerView({super.key});

  @override
  QrCodeScannerViewState createState() => QrCodeScannerViewState();
}

class QrCodeScannerViewState extends State<QrCodeScannerView> {
  late QrCodeScannerController _qrCodeController;
  final MobileScannerController _cameraController = MobileScannerController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void initState() {
    _qrCodeController = Get.find<QrCodeScannerController>();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   cameraController.start();
    // }
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().qrScanner,
      type: QrCodeScannerView,
      bodyMobile: _scannerWidget(),
    );
  }

  Widget _scannerWidget() {
    return Column(
      children: <Widget>[
        Container(child: optionToScanWidget()).marginOnly(bottom: Dimen.d_10),
        Expanded(child: _buildQrView(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GetBuilder<QrCodeScannerController>(
              id: UpdateQrUiBuilderIds.toggleFlash,
              builder: (_) {
                return IconButton(
                  onPressed: () async {
                    await _cameraController.toggleTorch();
                    _qrCodeController.functionHandler(
                      isUpdateUi: true,
                      updateUiBuilderIds: [UpdateQrUiBuilderIds.toggleFlash],
                    );
                  },
                  icon: ValueListenableBuilder(
                    valueListenable: _cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state) {
                        case TorchState.off:
                          return _toggleIcon(IconAssets.flashOff);
                        case TorchState.on:
                          return _toggleIcon(IconAssets.flashOn);
                      }
                    },
                  ),
                );
              },
            ),
            GetBuilder<QrCodeScannerController>(
              id: UpdateQrUiBuilderIds.toggleCamera,
              builder: (_) {
                return IconButton(
                  onPressed: () async {
                    await _cameraController.switchCamera();
                    _qrCodeController.functionHandler(
                      isUpdateUi: true,
                      updateUiBuilderIds: [UpdateQrUiBuilderIds.toggleCamera],
                    );
                  },
                  icon: ValueListenableBuilder(
                    valueListenable: _cameraController.cameraFacingState,
                    builder: (context, state, child) {
                      switch (state) {
                        case CameraFacing.front:
                          return _toggleIcon(IconAssets.frontCamera);
                        case CameraFacing.back:
                          return _toggleIcon(IconAssets.backCamera);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ).marginSymmetric(vertical: Dimen.d_10)
      ],
    );
  }

  Widget optionToScanWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: _columnIconAndText(
            '1',
            LocalizationHandler.of().scanQrAtHosptial,
          ),
        ),
        Flexible(
          child: _columnIconAndText(
            '2',
            LocalizationHandler.of().confirmAllDetails,
          ),
        ),
        Flexible(
          child: _columnIconAndText(
            '3',
            LocalizationHandler.of().shareYourDetail,
          ),
        ),
      ],
    );
  }

  Widget _columnIconAndText(String textNumber, String subTitle) {
    return Column(
      children: [
        Stack(
          children: [
            Icon(
              IconAssets.darkCircle,
              color: AppColors.colorGreen,
              size: Dimen.d_80,
            ),
            Text(
              textNumber,
              style: CustomTextStyle.displayMedium(context)?.apply(
                color: AppColors.colorWhite,
              ),
            ).marginOnly(left: Dimen.d_30, top: Dimen.d_16),
          ],
        ),
        Center(
          child: Text(
            subTitle,
            softWrap: true,
            maxLines: 2,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorAppBlue,
            ),
            textAlign: TextAlign.center,
          ).sizedBox(width: Dimen.d_100),
        )
      ],
    );
  }

  Widget _toggleIcon(IconData icon) {
    return Icon(
      icon,
      size: Dimen.d_40,
    );
  }

  Widget _buildQrView(BuildContext context) {
    return MobileScanner(
      controller: _cameraController,
      onDetect: (capture) {
        _cameraController.stop();
        bool isValidQrCodeData = _qrCodeController
            .getQrCodeDataHandler(capture.barcodes.first.rawValue);
        if (isValidQrCodeData) {
          _navHandler();
        } else {
          CustomDialog.showPopupDialog(
            LocalizationHandler.of().invalidQrCode,
            backDismissible: false,
            positiveButtonTitle: LocalizationHandler.of().ok.toUpperCase(),
            onPositiveButtonPressed: () {
              CustomDialog.dismissDialog();
              _cameraController.start();
            },
          );
        }
      },
    );
  }

  void _navHandler() {
    var arguments = {
      IntentConstant.hipId: _qrCodeController.hipId,
      IntentConstant.counterId: _qrCodeController.counterId,
    };
    context
        .navigatePush(RoutePath.routeShareProfile, arguments: arguments)
        .then((isDataShared) {
      context.navigateBack(result: isDataShared ?? false);
    });
  }
}
