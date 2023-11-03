import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AbhaCardController extends BaseController {
  late AbhaCardRepo abhaCardRepo;
  final FileService _fileService = FileServiceImpl();
  final ShareService _shareService = ShareServiceImpl();
  List<int> phrCardImageList = [];

  AbhaCardController(AbhaCardRepoImpl repo) : super(AbhaCardController) {
    abhaCardRepo = repo;
  }

  /// @Here is the method getProfileQrCodeFetch() gets the tempResponseData by calling the
  /// callAbhaCard() method which is define inside the AbhaCardRepo class.
  Future<void> getAbhaCard() async {
    tempResponseData = await abhaCardRepo.callAbhaCard();
    phrCardImageList = tempResponseData;
  }

  /// Check device type for Mobile platform use [inAppWebView] to capture screenshot.
  /// For Web platform .svg file will be downloaded
  Future<void> downloadFile(
    InAppWebViewController? inAppWebViewController,
  ) async {
    try {
      if (!Validator.isNullOrEmpty(phrCardImageList)) {
        File? file = await _fileService.writeToStorage(
          fileName: generateFileName(),
          data: Uint8List.fromList(phrCardImageList),
          directoryType: DirectoryType.download,
        );
        OpenFile.open(file?.path);
      } else {
        failedDownloadMsg();
      }
    } catch (e) {
      abhaLog.e(e.toString());
      failedDownloadMsg();
    }
  }

  void failedDownloadMsg() {
    if (navKey.currentContext != null) {
      MessageBar.showToastError(
        LocalizationHandler.of().file_download_failure,
      );
    }
  }

  /// Check device type for Mobile platform use [inAppWebView] to capture screenshot.
  /// For Web platform .svg file will be shared
  Future<void> shareFile() async {
    try {
      File? file = await _fileService.writeToStorage(
        fileName: generateFileName(),
        data: Uint8List.fromList(phrCardImageList),
        directoryType: DirectoryType.temporary,
      );
      _shareService.shareFile(filePath: [file!.path]);
    } catch (e) {
      abhaLog.e(e.toString());
    }
  }

  /// Generate unique file name for ABHA_CARD using profile id
  String generateFileName() {
    return 'abha_card_${abhaSingleton.getAppData.getUserName()}.png';
  }

  bool getKycDetail(ProfileModel? profileModel) {
    String kycStatus = profileModel?.kycStatus ?? '';
    return kycStatus == StringConstants.kycStatus ? true : false;
  }
}
