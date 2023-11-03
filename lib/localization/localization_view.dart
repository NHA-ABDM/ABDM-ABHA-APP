import 'package:abha/export_packages.dart';
import 'package:abha/localization/view/localization_desktop_view.dart';
import 'package:abha/localization/view/localization_mobile_view.dart';
import 'package:flutter/foundation.dart';

class LocalizationView extends StatefulWidget {
  const LocalizationView({super.key});

  @override
  LocalizationViewState createState() => LocalizationViewState();
}

class LocalizationViewState extends State<LocalizationView> {
  final _localizationHandler = LocalizationHandler();
  late LocalizationModel _languageModel;
  late List<String> _languageNameList;
  final String _selectedLanguageName =
      abhaSingleton.getAppData.getLanguageName();
  final bool _isLogin = abhaSingleton.getAppData.getLogin();

  @override
  void initState() {
    _initLanguage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here method is used to initialize the list with languages name
  void _initLanguage() {
    _languageNameList = _localizationHandler.getSupportedLanguage();
    _languageModel =
        _localizationHandler.getLanguageModel(_selectedLanguageName);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? LocalizationDesktopView(
            localizationHandler: _localizationHandler,
            languageModel: _languageModel,
            languageNameList: _languageNameList,
            selectedLanguageName: _selectedLanguageName,
          )
        : BaseView(
            elevation: _isLogin ? Dimen.d_1_5 : Dimen.d_1_5,
            title: LocalizationHandler.of().labelSelectLanguage,
            paddingValueMobile: Dimen.d_0,
            type: LocalizationView,
            mobileBackgroundColor: AppColors.colorWhite,
            bodyMobile: LocalizationMobileView(
              localizationHandler: _localizationHandler,
              languageModel: _languageModel,
              languageNameList: _languageNameList,
              selectedLanguageName: _selectedLanguageName,
            ),
          );
  }
}
