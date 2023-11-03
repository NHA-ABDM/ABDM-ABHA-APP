import 'package:abha/utils/route/route_name.dart';
import 'package:flutter/foundation.dart';

class RoutePath {
  static const String routeDefault = '/';
  static String routeAppIntro = kIsWeb ? routeDefault : routeDefault + RouteName.appIntro;

  // abha card flow
  static const String routeAbhaCard = routeDefault + RouteName.abhaCard;
  static const String routeAboutUs = routeDefault + RouteName.aboutUs;
  static const String routeSupport = routeDefault + RouteName.support;
  static const String routeContactUs = routeDefault + RouteName.contactUs;

  // dashboard flow
  static String routeDashboard = routeDefault + RouteName.dashboard;
  static const String routeDashboardTokenHistory = routeDefault + RouteName.dashboardTokenHistory;


  // facility linking flow
  static const String routeLinkFacility = routeDefault + RouteName.linkFacility;

  // discovery and linking flow
  static const String routeDiscoveryLinking = routeLinkFacility + routeDefault + RouteName.discoveryLinking;
  static const String routeDiscoverHip = routeDiscoveryLinking + routeDefault + RouteName.discoverHip;
  static const String routeLinkingHip = routeDiscoverHip + routeDefault + RouteName.linkingHip;
  static const String routeLinkingOtpHip = routeLinkingHip + routeDefault + RouteName.linkingOtpHip;

  // health record flow
  static const String routeHealthRecordDetail = routeDefault + RouteName.healthRecordDetail;
  static const String routeHealthRecordSearch = routeDefault + RouteName.healthRecordSearch;

  //
  static const String routeLocalization = routeDefault + RouteName.localization;

  // link unlink abha  number flow
  static const String routeAbha = routeDefault + RouteName.abha;
  static const String routeLinkAbhaNumber = routeAbha + routeDefault + RouteName.linkAbhaNumber;
  static const String routeUnlinkAbhaNumber = routeDefault + RouteName.unlinkAbhaNumber;
  static const String routeUnlinkAbhaNumberValidator = routeDefault + RouteName.unlinkAbhaNumberValidator;
  static const String routeLinkUnlinkOtpView = routeDefault + RouteName.linkUnlinkOtpView;
  static const String routeLinkUnlinkConfirmView = routeDefault + RouteName.linkUnlinkConfirmView;

  // notification flow
  static const String routeNotification = routeDefault + RouteName.notification;
  static const String routePermissionConsent = routeDefault + RouteName.permissionApproval;
  static const String routeQrCodeScanner = routeDefault + RouteName.qrCodeScanner;

  //
  static const String routeSplash = routeDefault;

  // share profile flow
  static const String routeShareProfile = routeDefault + RouteName.shareProfile;
  static const String routeShareProfileWeb = routeDefault + RouteName.shareProfileWeb;

  //
  static const String routeUhi = routeDefault + RouteName.uhi;
  static const String routeWebView = routeDefault + RouteName.webView;

  /// Consent Flow routes
  static const String routeConsent = routeDefault + RouteName.consent;
  static const String routeConsentDetails = routeConsent + routeDefault + RouteName.consentDetails;
  static const String routeConsentDetailsMine = routeConsent + routeDefault + RouteName.consentDetailsMine;
  static const String routeConsentsMine = routeConsent + routeDefault + RouteName.consentMine;
  static const String routeConsentEdit = routeConsent + routeDefault + RouteName.consentEdit;
  static const String routeConsentArtefactsDetail = routeDefault + RouteName.consentArtefactsDetail;

  /// Login Flow routes
  static const String routeLogin = routeDefault + RouteName.login;
  static const String routeLoginMobile = routeLogin + routeDefault + RouteName.loginMobile;
  static const String routeLoginAbhaAddress = routeLogin + routeDefault + RouteName.loginAbhaAddress;
  static const String routeLoginEmail = routeLogin + routeDefault + RouteName.loginEmail;
  static const String routeLoginAbhaNumber = routeLogin + routeDefault + RouteName.loginAbhaNumber;
  static const String routeLoginOtp = routeLogin + routeDefault + RouteName.loginOtp;
  static const String routeLoginConfirm = routeLogin + routeDefault + RouteName.loginConfirm;

  /// Registration Flow routes
  static const String routeRegistration = routeDefault + RouteName.registration;
  static const String routeRegistrationEmail = routeRegistration + routeDefault + RouteName.registrationEmail;
  static const String routeRegistrationMobile = routeRegistration + routeDefault + RouteName.registrationMobile;
  static const String routeRegistrationAbha = routeRegistration + routeDefault + RouteName.registrationAbha;
  static const String routeRegistrationOtp = routeRegistration + routeDefault + RouteName.registrationOtp;
  static const String routeRegistrationAbhaConfirm = routeRegistration + routeDefault + RouteName.registrationAbhaConfirm;
  static const String routeRegistrationForm = routeRegistration + routeDefault + RouteName.registrationForm;
  static const String routeRegistrationAbhaAddress = routeRegistration + routeDefault + RouteName.registrationAbhaAddress;

  /// Health Locker Flow routes
  static const String routeHealthLocker = routeDefault + RouteName.healthLocker;
  static const String routeHealthLockerInfo = routeHealthLocker + routeDefault + RouteName.healthLockerInfo;
  static const String routeHealthLockerInfoSubItem = routeHealthLocker + routeDefault + RouteName.healthLockerInfoSubItem;
  static const String routeHealthLockerAutoAccessData = routeHealthLocker + routeDefault + RouteName.healthLockerAutoAccess;
  static const String routeHealthLockerAuthorizationRequest = routeHealthLocker + routeDefault + RouteName.healthLockerAuthorizationRequest;
  static const String routeHealthLockerEditSubscription = routeHealthLocker + routeDefault + RouteName.healthLockerEditSubscription;

  /// Settings Flow routes
  static const String routeAccount = routeDefault + RouteName.account;
  static const String routeSettingsResetPassword = routeAccount + routeDefault + RouteName.settingsResetPassword;
  static const String routeSettingsResetPasswordResult = routeSettingsResetPassword + routeDefault + RouteName.settingsResetPasswordResult;
  static const String routeSubmitFeedback = routeAccount + routeDefault + RouteName.submitFeedback;
  /// Profile Flow routes
  static const String routeProfileView = routeAccount + routeDefault + RouteName.profileView;
  static const String routeProfileUpdateAddress = routeAccount   + routeDefault + RouteName.profileEdit;
  static const String routeSwitchAccount = routeAccount   + routeDefault + RouteName.switchAccount;


  /// ABHA Number Flow routes
  static const String routeAbhaNumber = routeDefault + RouteName.abhaNumber;
  static const String routeAbhaNumberOption = routeAbhaNumber + routeDefault + RouteName.abhaNumberOption;
  static const String routeAbhaNumberMobile = routeAbhaNumber + routeDefault + RouteName.abhaNumberMobile;
  static const String routeAbhaNumberOtp = routeAbhaNumber + routeDefault + RouteName.abhaNumberOtp;
  static const String routeAbhaNumberCard = routeAbhaNumber + routeDefault + RouteName.abhaNumberCard;
  static const String routeAbhaNumberForget = routeDefault + RouteName.abhaNumberForget;
  static const String routeAbhaNumberForgetViaAadhaarMobile = routeAbhaNumberForget + routeDefault + RouteName.abhaNumberForgetViaAadhaarMobile;
  static const String routeAbhaNumberForgotCardDetail = routeAbhaNumberForget + routeDefault + RouteName.abhaNumberForgetCardDetail;
  static const String routeAbhaNumberForgetOtp = routeAbhaNumberForget + routeDefault + RouteName.abhaNumberForgetOtp;
}
