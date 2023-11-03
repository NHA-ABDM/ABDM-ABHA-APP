import 'package:abha/app/app_intro/app_intro_controller.dart';
import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/token/token_controller.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class DeleteControllers {
  Future<void> deleteAll() async {
    await Get.deleteAll(force: true);
  }

  Future<void> deleteSplash() async {
    Get.delete<SplashController>();
  }

  Future<void> deleteDashboard(HiveBoxes box) async {
    if (!kIsWeb) {
      box.closeAllBox();
      Get.delete<DashboardController>();
      Get.delete<ProfileController>();
      Get.delete<HealthRecordController>();
      Get.delete<LinkedFacilityController>();
      Get.delete<TokenController>();
    }
  }

  Future<void> deleteConsent() async {
    if (!kIsWeb) {
      Get.delete<ConsentController>();
    }
  }

  Future<void> deleteSettings() async {
    if (!kIsWeb) {
      Get.delete<SettingsController>();
    }
  }

  Future<void> deleteAppIntro() async {
    if (!kIsWeb) {
      Get.delete<AppIntroController>();
      Get.delete<LoginController>();
      Get.delete<RegistrationController>();
    }
  }

  Future<void> deleteDiscoveryLinking() async {
    if (!kIsWeb) {
      Get.delete<DiscoveryLinkingController>();
    }
  }

  Future<void> deleteLinkUnlink() async {
    if (!kIsWeb) {
      Get.delete<LinkUnlinkController>();
    }
  }

  Future<void> deleteAbhaNumber() async {
    if (!kIsWeb) {
      Get.delete<AbhaNumberController>();
    }
  }

  Future<void> deleteAbhaCard() async {
    if (!kIsWeb) {
      Get.delete<AbhaCardController>();
    }
  }

  Future<void> deleteHealthLocker() async {
    if (!kIsWeb) {
      Get.delete<HealthLockerController>();
    }
  }

  Future<void> deleteNotification({bool forceDelete = false}) async {
    if (!kIsWeb || forceDelete) {
      Get.delete<NotificationController>();
    }
  }

  Future<void> deleteQrCodeScanner() async {
    if (!kIsWeb) {
      Get.delete<QrCodeScannerController>();
    }
  }

  Future<void> deleteShareProfiler() async {
    if (!kIsWeb) {
      Get.delete<ShareProfileController>();
    }
  }
}
