import 'package:abha/export_packages.dart';

enum UpdateQrUiBuilderIds {
  toggleFlash,
  toggleCamera,
}

class QrCodeScannerController extends BaseController {
  // late QrCodeScannerRepo _qrCodeScannerRepo;
  String? hipId;
  String? counterId;
  String? consentRequestID;

  QrCodeScannerController(QrCodeScannerRepoImpl repo)
      : super(QrCodeScannerController) {
    // _qrCodeScannerRepo = repo;
  }

  /// @Here Function fetch the HipId and counterID from the Barcode scanned data.
  /// Returns true if data found else return false.
  /// params [scanData] Barcode.
  bool getQrCodeDataHandler(String? qrDataOrLink) {
    bool isValidQrCodeData = false;
    try {
      final data = qrDataOrLink ?? '';
      if (data.contains(StringConstants.https)) {
        Uri uri = Uri.parse(data);
        String qrCodeHost =
            abhaSingleton.getAppConfig.getConfigData()[AppConfig.qrCodeHost];
        var host = uri.host;
        List<String> params = uri.pathSegments;
        if (params.isNotEmpty) {
          var firstParam = params[0];
          if (host == qrCodeHost &&
              firstParam == StringConstants.shareProfile) {
            hipId = uri.queryParameters[ApiKeys.responseKeys.hip_id];
            counterId = uri.queryParameters[ApiKeys.responseKeys.counterId];
            if (!Validator.isNullOrEmpty(hipId) &&
                !Validator.isNullOrEmpty(counterId)) {
              isValidQrCodeData = true;
            }
          } else if (host == StringConstants.consentRequestUrl &&
              firstParam == StringConstants.consentManager) {
            var secondParam = params[1];
            if (secondParam == StringConstants.consentRequest) {
              consentRequestID = params[2];
              isValidQrCodeData = true;
            }
          }
        }
      } else {
        Map qrCodeData = jsonDecode(data);
        hipId = qrCodeData[ApiKeys.responseKeys.hipId];
        counterId = qrCodeData[ApiKeys.responseKeys.code];
        if (!Validator.isNullOrEmpty(hipId) &&
            !Validator.isNullOrEmpty(counterId)) {
          isValidQrCodeData = true;
        }
      }
    } on Exception catch (e) {
      abhaLog.e(e);
    }
    return isValidQrCodeData;
  }
}
