import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile.dart';

class LocalizationMobileView extends StatefulWidget {
  final LocalizationHandler localizationHandler;
  final LocalizationModel languageModel;
  final List<String> languageNameList;
  final String selectedLanguageName;

  const LocalizationMobileView({
    required this.localizationHandler,
    required this.languageModel,
    required this.languageNameList,
    required this.selectedLanguageName,
    super.key,
  });

  @override
  LocalizationMobileViewState createState() => LocalizationMobileViewState();
}

class LocalizationMobileViewState extends State<LocalizationMobileView> {
  late LocalizationHandler _localizationHandler;
  late LocalizationModel _languageModel;
  final bool _isLogin = abhaSingleton.getAppData.getLogin();
  late List<String> _languageNameList;
  late String _selectedLanguageName = '';

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _localizationHandler = widget.localizationHandler;
    _languageModel = widget.languageModel;
    _languageNameList = widget.languageNameList;
    _selectedLanguageName = widget.selectedLanguageName;
  }

  /// @Here method changes the localization in app.
  /// @param  [language]  of type LanguageModel.
  Future<void> _setLanguage() async {
    if (_isLogin) {
      if (_selectedLanguageName == widget.selectedLanguageName) {
        context.navigateBack();
        return;
      }
      _localizationHandler.setSelectedLanguage(_languageModel, context);
    } else {
      context.navigateGo(RoutePath.routePermissionConsent);
      abhaSingleton.getSharedPref
          .set(SharedPref.isLanguageSelected, true); // set value to shared pref
    }
  }

  void _onLanguageItemTap(value) {
    _selectedLanguageName = value.toString();
    setState(() {
      _languageModel =
          _localizationHandler.onTapActionPerform(_selectedLanguageName);

      /// set the selected language name into variable
      if (!_isLogin) {
        _localizationHandler.setSelectedLanguage(_languageModel, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectLanguageRadioButton();
  }

  Widget _selectLanguageRadioButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _languageNameList.length,
          itemBuilder: (context, position) {
            var item = _languageNameList[position];
            return CustomRadioTile(
              title: item,
              radioValue: item,
              radioGroupValue: _selectedLanguageName,
              onChanged: (value) {
                _onLanguageItemTap(value);
              },
            );
          },
        ),
        TextButtonOrange.mobile(
          key: const Key(KeyConstant.continueBtn),
          text: LocalizationHandler.of().continuee,
          onPressed: () {
            Validator.isNullOrEmpty(_selectedLanguageName)
                ? MessageBar.showToastError(
                    LocalizationHandler.of().labelSelectLanguage,
                  )
                : _setLanguage();
          },
        ).marginSymmetric(
          vertical: context.bottomPadding + Dimen.d_16,
          horizontal: Dimen.d_16,
        )
      ],
    );
  }
}
