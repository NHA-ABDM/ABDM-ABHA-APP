import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/reset/restart_widget.dart';
import 'package:abha/utils/global/global_key.dart';

class LocalizationHandler {
  static AppLocalizations of({BuildContext? mContext}) {
    BuildContext context = mContext ?? navKey.currentContext!;
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  List<String> getSupportedLanguage() {
    return [
      LocalizationConstant.english,
    ];
  }

  LocalizationModel getLanguageModel(String selectedLanguageName) {
    return Validator.isNullOrEmpty(selectedLanguageName)
        ? const LocalizationModel(
            LocalizationConstant.english,
            LocalizationConstant.englishCode,
            LocalizationConstant.englishAudioCode,
          )
        : LocalizationModel(
            selectedLanguageName,
            abhaSingleton.getAppData.getLanguageCode(),
            abhaSingleton.getAppData.getLanguageAudioCode(),
          );
  }

  LocalizationModel onTapActionPerform(String? language) {
    late LocalizationModel localizationModel;
    if (language == LocalizationConstant.english) {
      localizationModel = const LocalizationModel(
        LocalizationConstant.english,
        LocalizationConstant.englishCode,
        LocalizationConstant.englishAudioCode,
      );
    } else {}
    return localizationModel;
  }

  Future<void> setSelectedLanguage(
    LocalizationModel? languageModel,
    BuildContext context,
  ) async {
    String languageCode =
        languageModel?.languageCode ?? LocalizationConstant.englishCode;
    String languageName =
        languageModel?.languageName ?? LocalizationConstant.english;
    String languageAudioCode = languageModel?.languageAudioCode ??
        LocalizationConstant.englishAudioCode;
    abhaSingleton.getAppData
        .setLanguageCode(languageCode); // set value to local model
    abhaSingleton.getAppData
        .setLanguageName(languageName); // set value to local model
    abhaSingleton.getAppData
        .setLanguageAudioCode(languageAudioCode); // set value to local model
    abhaSingleton.getSharedPref.set(
      SharedPref.currentLanguageCode,
      languageCode,
    ); // set value to shared pref
    abhaSingleton.getSharedPref.set(
      SharedPref.currentLanguageName,
      languageName,
    ); // set value to shared pref
    // set language code for audio in shared preference
    abhaSingleton.getSharedPref.set(
      SharedPref.currentLanguageAudioCode,
      languageAudioCode,
    ); // set value to shared pref
    RestartWidget.restartApp(context);
  }
}
