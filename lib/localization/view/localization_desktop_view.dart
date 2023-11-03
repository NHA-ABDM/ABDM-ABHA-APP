import 'package:abha/export_packages.dart';

class LocalizationDesktopView extends StatefulWidget {
  final LocalizationHandler localizationHandler;
  final LocalizationModel languageModel;
  final List<String> languageNameList;
  final String selectedLanguageName;

  const LocalizationDesktopView({
    required this.localizationHandler,
    required this.languageModel,
    required this.languageNameList,
    required this.selectedLanguageName,
    super.key,
  });

  @override
  LocalizationDesktopViewState createState() => LocalizationDesktopViewState();
}

class LocalizationDesktopViewState extends State<LocalizationDesktopView> {
  late LocalizationHandler _localizationHandler;
  late LocalizationModel _languageModel;
  late List<String> _languageNameList;
  late String _selectedLanguageName;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _localizationHandler = widget.localizationHandler;
    _languageModel = widget.languageModel;
    _languageNameList = widget.languageNameList;
    _selectedLanguageName = widget.selectedLanguageName;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: '',
      offset: Offset(0.0, Dimen.d_30),
      itemBuilder: (BuildContext context) {
        return _languageNameList.map((String data) {
          return PopupMenuItem(
            value: data,
            height: Dimen.d_32,
            textStyle: CustomTextStyle.titleMedium(context)
                ?.apply(color: AppColors.colorBlack),
            onTap: () {
              _selectedLanguageName = data.toString();
              _languageModel = _localizationHandler
                  .onTapActionPerform(_selectedLanguageName);
              _localizationHandler.setSelectedLanguage(
                _languageModel,
                context,
              );
            },
            child: Text(
              data,
              textAlign: TextAlign.center,
            ),
          );
        }).toList();
      },
      child: Row(
        children: [
          Text(
            _selectedLanguageName,
            style: CustomTextStyle.labelLarge(context)
                ?.apply(color: AppColors.colorAppBlue1, fontSizeDelta: -2),
          ),
          Icon(
            IconAssets.navigateDown,
            size: Dimen.d_20,
            color: AppColors.colorAppBlue1,
          ).marginOnly(
            left: Dimen.d_4,
          ),
        ],
      ),
    );
  }
}
