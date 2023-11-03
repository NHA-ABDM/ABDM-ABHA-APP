import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';

class RegistrationFormController extends BaseController {
  final fullNameTEC = AppTextController(
    inputFormatters: Validator.personNameFormatter(),
  );
  final mobileNumberTEC =
      AppTextController(inputFormatters: Validator.numberFormatter());
  final emailTEC = AppTextController();
  final dayTEC = AppTextController();
  final monthTEC = AppTextController();
  final yearTEC = AppTextController();
  final genderTEC = AppTextController();
  final addressTEC =
      AppTextController(inputFormatters: Validator.addressFormatter());
  final stateTEC = AppTextController();
  final districtTEC = AppTextController();
  final pinCodeTEC =
      AppTextController(inputFormatters: Validator.numberFormatter());
  String? selectedGenderValue;
  DateTime date = DateTime(2022, 11, 23);

  DateOfBirth birthDate = DateOfBirth();

  final StateEntry initialStateValue = StateEntry(
    stateCode: 00,
    stateName: 'Select State',
  );
  final DistrictEntry initialDistrictValue = DistrictEntry(
    districtCode: 00,
    districtName: 'Select District',
  );
  StateEntry? selectedStateValue;
  DistrictEntry? selectedDistrictValue;

  /// TO-IMPLEMENT: uncomment after word remaining options in genders field
  final List<Map> genders = [
    {'name': 'Male', 'code': 'M'},
    {'name': 'Female', 'code': 'F'},
    {'name': 'Others', 'code': 'O'},
    //{'name': "I Don't Want To Disclose", 'code': 'U'},
  ];
  List<String> birthYears = [];
  List<String> dates = [];
  final List<Map> months = [
    {'name': 'January', 'code': '01'},
    {'name': 'February', 'code': '02'},
    {'name': 'March', 'code': '03'},
    {'name': 'April', 'code': '04'},
    {'name': 'May', 'code': '05'},
    {'name': 'June', 'code': '06'},
    {'name': 'July', 'code': '07'},
    {'name': 'August', 'code': '08'},
    {'name': 'September', 'code': '09'},
    {'name': 'October', 'code': '10'},
    {'name': 'November', 'code': '11'},
    {'name': 'December', 'code': '12'},
  ];
  List<StateEntry> states = [];
  List<DistrictEntry> districts = [];

  bool checkbox1 = false;
  bool isYearSelected = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  final FlutterTts _flutterTts = FlutterTts();
  bool isAudioPlaying = false;

  RegistrationFormController() : super(RegistrationFormController);

  Future<void> startSpeech(String textToSpeech) async {
    try {
      isAudioPlaying = true;
      String audioLang = abhaSingleton.getAppData.getLanguageAudioCode();
      await _flutterTts.setLanguage(audioLang);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.speak(textToSpeech);
      updateUiOnTtsCompletion();
    } catch (E) {
      abhaLog.e(E);
    }
  }

  void updateUiOnTtsCompletion() {
    // Update the UI on Tts Completion.
    _flutterTts.setCompletionHandler(() {
      isAudioPlaying = false;
      functionHandler(isUpdateUi: true);
    });
  }

  Future<void> stopSpeech() async {
    isAudioPlaying = false;
    await _flutterTts.stop();
  }

  Map createFormReqData(FullNameModel fullNameModel) {
    String? selectedDate;
    if (!Validator.isNullOrEmpty(birthDate.date)) {
      selectedDate = birthDate.date! < 10
          ? '0${birthDate.date}'
          : birthDate.date.toString();
    }
    String? selectedMonth;
    if (!Validator.isNullOrEmpty(birthDate.month)) {
      selectedMonth = birthDate.month! < 10
          ? '0${birthDate.month}'
          : birthDate.month.toString();
    }
    return {
      'address': addressTEC.text.trim(),
      'countryCode': StringConstants.countryCode,
      'dateOfBirth': {
        'date': selectedDate,
        'month': selectedMonth,
        'year': birthDate.year.toString()
      },
      'districtCode': selectedDistrictValue?.districtCode,
      'districtName': selectedDistrictValue?.districtName,
      'email': emailTEC.text.trim(),
      'gender': selectedGenderValue,
      'mobile': mobileNumberTEC.text.trim(),
      'name': {
        'first': fullNameModel.firstName,
        'middle': fullNameModel.middleName,
        'last': fullNameModel.lastName,
      },
      'pinCode': pinCodeTEC.text,
      'sessionId': '_sessionId',
      'stateCode': selectedStateValue?.stateCode,
      'stateName': selectedStateValue?.stateName
    };
  }

  // @override
  // void dispose() {
  //   fullNameTEC.dispose();
  //   mobileNumberTEC.dispose();
  //   emailTEC.dispose();
  //   dayTEC.dispose();
  //   monthTEC.dispose();
  //   yearTEC.dispose();
  //   genderTEC.dispose();
  //   addressTEC.dispose();
  //   stateTEC.dispose();
  //   districtTEC.dispose();
  //   pinCodeTEC.dispose();
  //   selectedGenderValue = null;
  //   super.dispose();
  // }
}
