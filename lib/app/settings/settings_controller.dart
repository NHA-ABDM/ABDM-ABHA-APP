import 'package:abha/export_packages.dart';
import 'package:encrypt/encrypt.dart';

/// Here is the enum class contains some constants.
enum UpdateSettingsUiBuilderIds {
  passwordValidationHint,
  passwordMatches,
  updateContinueButton
}

class SettingsController extends BaseController {
  /// instance variable of SettingsRepo
  late SettingsRepo _settingsRepo;

  /// constructor of SettingsController having
  /// param [repo]  SettingsRepoImpl
  SettingsController(SettingsRepoImpl repo) : super(SettingsController) {
    _settingsRepo = repo;
  }

  /// @Here is the callUpdatePassword() method use param [password] of type String. This parameter
  /// is used to pass into callUpdatePassword() method which returns the response after calling
  /// api into the variable tempResponseData. Password is get Encrypted by method getEncryptedData().
  Future<void> callUpdatePassword(String password) async {
    tempResponseData = await _settingsRepo
        .callUpdatePassword(await updateAbhaPassRequestData(password));
  }

  Future<void> callSendFeedback(
    String email,
    String subject,
    String feedback,
  ) async {
    tempResponseData = await _settingsRepo
        .callSendFeedback(await feedbackRequestData(email, subject, feedback));
  }

  Future<Map> feedbackRequestData(
    String email,
    String subject,
    String feedback,
  ) async {
    var authConfirmData = {};
    authConfirmData.addAll({
      ApiKeys.requestKeys.healthId: abhaSingleton.getAppData.getAbhaAddress(),
      ApiKeys.requestKeys.body: feedback,
      ApiKeys.requestKeys.emailId: email,
      ApiKeys.requestKeys.title: subject
    });

    return authConfirmData;
  }

  /// @Here is the method to Encrypt the data and returns the [payloadData]
  Future<Map> getEncryptedData(String data) async {
    var payloadData = {};

    /// Encrypt the data
    Encrypted encrypt = await Validator.encryptData(data);

    /// Add encrypted data into payloadData
    payloadData.addAll({ApiKeys.requestKeys.password: encrypt.base64});

    ///returns the data
    return payloadData;
  }

  Future<Map> updateAbhaPassRequestData(String password) async {
    tempResponseData =
        await abhaSingleton.getApiProvider.onEncryptData(password);
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaAddressProfile,
        ApiKeys.requestValues.scopePasswordVerify
      ],
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [
          ApiKeys.requestValues.authMethodsPassword
        ],
        ApiKeys.requestKeys.password: {
          ApiKeys.requestKeys.abhaAddress:
              abhaSingleton.getAppData.getAbhaAddress(),
          ApiKeys.requestKeys.password: tempResponseData
        },
      },
    };
    return authConfirmData;
  }
}
