import 'package:abha/export_packages.dart';

/// @Here is the Class use for url constants related to Privacy policy, Privacy Notice,
///  Terms and condition, Aadhaar consents, User Info Agreement. which can
///  be available into different languages and flavours.
class AbdmUrlConstant {
  /// get Base url
  static final String _abdmUrlLink =
      abhaSingleton.getAppConfig.getConfigData()[AppConfig.abdmBaseUrl];

  /// get language code
  static const String _languageCode = LocalizationConstant.englishCode;

  /// @here is the function to get Term and Condition url with different language code
  static String getTermsConditionsUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}abha-terms-conditions-english';
    } else {
      return '${_abdmUrlLink}abha-terms-conditions-hindi';
    }
  }

  /// @here  get FAQ url with different language code
  static final String faqUrl = '${_abdmUrlLink}faq/abhamobileapp';

  /// @here is the function to get Privacy Notice url with different language code
  static String getPrivacyNoticeUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}abha-app-data-privacy-notice-english';
    } else {
      return '${_abdmUrlLink}abha-app-data-privacy-notice-hindi';
    }
  }

  /// @here is the function to get Privacy Notice url with different language code
  static String getPersonalDataUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}abha-personal-data-processing-english';
    } else {
      return '${_abdmUrlLink}abha-personal-data-processing-hindi';
    }
  }

  /// @here is the function to get Privacy Policy url with different language code
  static String getPrivacyPolicyUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}abha-PRIVACY-POLICY-english';
    } else {
      return '${_abdmUrlLink}abha-PRIVACY-POLICY-hindi';
    }
  }

  /// @here is the function to get Aadhaar Consent url with different language code
  static String getAadhaarConsentUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}english-aadhaar-consent';
    } else {
      return '${_abdmUrlLink}hindi-aadhaar-consent';
    }
  }

  /// @here is the function to get User Info Agreement url with different language code
  static String getUserInfoAgreementUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}english-user-information-agreement';
    } else {
      return '${_abdmUrlLink}hindi-user-information-agreement';
    }
  }

  /// @here is the function to get Privacy Notice url with different language code
  static String getUserInfoAgreeAbhaNoUrl() {
    if (abhaSingleton.getAppData.getLanguageCode() == _languageCode) {
      return '${_abdmUrlLink}user-information-agreement-abha-no-english';
    } else {
      return '${_abdmUrlLink}user-information-agreement-abha-no-hindi';
    }
  }

  /// @here is the function to get Health Data Policy url
  static String getHealthDataPolicy() {
    return 'https://ndhm.gov.in/publications/policies_regulations/health_data_management_policy';
  }

  /// @here is the function to get Grievance Portal url
  static String getGrievancePortal() {
    if (abhaSingleton.getAppConfig.getConfigData()[AppConfig.flavorName] ==
        'prod') {
      return 'https://grievance.abdm.gov.in/grievance_form.php';
    } else {
      return 'https://grievancebeta1.abdm.gov.in/grievance/v3/register';
    }
  }

  /// @here is the function to get ABDM url
  static String getABDMUrl() {
    return _abdmUrlLink;
  }

  /// @here is the function to get Ministry of Health and Family Welfare url
  static String getMinistryOfHealthAndFamilyWelfareUrl() {
    return 'https://www.mohfw.gov.in';
  }

  /// @here is the function to get About ABDM url
  static String getAboutABDMUrl() {
    return 'https://abdm.gov.in/abdm';
  }

  /// @here is the function to get About NHA url
  static String getAboutNHAUrl() {
    return 'https://abdm.gov.in/nha';
  }

  /// @here is the function to get Health Data Management url
  static String getHealthDataManagementUrl() {
    return 'https://abdm.gov.in/in-the-news';
  }

  /// @here is the function to get news and media url
  static String getNewsAndMediaUrl() {
    return 'https://abdm.gov.in/in-the-news';
  }

  /// @here is the function to get app store url
  static String getAppStoreUrl() {
    return 'https://apps.apple.com/in/app/abha-abdm/id1630917266';
  }

  /// @here is the function to get play store url
  static String getPlayStoreUrl() {
    return 'https://play.google.com/store/apps/details?id=in.ndhm.phr';
  }

  /// @here is the function to get url of National Health Authority
  static String getNationalHealthAuthorityUrl() {
    return 'https://nha.gov.in/';
  }

  /// @here is the function to get url of Ministry Of Electronics And IT
  static String getMinistryOfElectronicAndITUrl() {
    return 'https://www.meity.gov.in/';
  }

  /// @here is the function to get url of India Government
  static String getIndiaGovernmentUrl() {
    return 'https://www.india.gov.in/';
  }

  /// @here is the function to get url of Ministry Of Electronics And IT
  static String getDigitalIndiaGovtUrl() {
    return 'https://digitalindia.gov.in/';
  }

  /// @here is the function to get Facebook url
  static String getFacebookUrl() {
    return 'https://www.facebook.com/AyushmanBharatGoI';
  }

  /// @here is the function to get Youtube url
  static String getYoutubeUrl() {
    return 'https://www.youtube.com/channel/UCkd7w2rww0HQB4lZ-l3dB6g';
  }

  /// @here is the function to get X url
  static String getXUrl() {
    return 'https://twitter.com/AyushmanNHA';
  }

  /// @here is the function to get Instagram url
  static String getInstagramUrl() {
    return 'https://www.instagram.com/ayushmannha/';
  }

  /// @here is the function to get data privacy policy url
  static String getDataPrivacyPolicy() {
    return 'https://abdm.gov.in:8081/uploads/privacypolicy_178041845b.pdf';
  }
}
