import 'package:abha/app/registration/controller/reg_form_controller.dart';
import 'package:abha/app/registration/view/desktop/registration_form_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_form_mobile_view.dart';
import 'package:abha/export_packages.dart';

class RegistrationFormView extends StatefulWidget {
  final Map arguments;

  const RegistrationFormView({required this.arguments, super.key});

  @override
  RegistrationFormViewState createState() => RegistrationFormViewState();
}

class RegistrationFormViewState extends State<RegistrationFormView> {
  late RegistrationController _registrationController;
  late RegistrationFormController _registrationFormController;
  late String _screenTitle = '';
  late String _fromScreenString;
  late String _sentToString;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _registrationController =
        Get.put(RegistrationController(RegistrationRepoImpl()));
    _registrationFormController = Get.put(RegistrationFormController());
    _sentToString = widget.arguments[IntentConstant.sentToString];
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _onGetStates();
      // _onGenerateYears();
      // _onGenerateDates();
    });
  }

  @override
  void dispose() {
    Get.delete<RegistrationFormController>();
    super.dispose();
  }

  /// @Here function set the title as selected registration type in [_screenTitle]
  /// and email value or mobile value into the string [emailTextController.text]
  void initScreenTitleText() {
    if (_fromScreenString == 'registrationEmail') {
      _screenTitle =
          LocalizationHandler.of().registrationWithEmail.toTitleCase();
      _registrationFormController.emailTEC.text = _sentToString;
    } else if (_fromScreenString == 'registrationMobile') {
      _screenTitle =
          LocalizationHandler.of().registrationWithMobileNumber.toTitleCase();
      _registrationFormController.mobileNumberTEC.text = _sentToString;
    }
  }

  /// @Here function submit the map data on click of submit button into the api.
  Future<void> onFormSubmission(Map formObject) async {
    FocusManager.instance.primaryFocus?.unfocus();

    /// Below code is V1 API which is not required in V3 API hence commenting the code
    /*await _registrationController.functionHandler(
      function: () =>
          _registrationController.getRegistrationFormSubmission(formObject),
      isLoaderReq: true,
    );
    if (_registrationController.responseHandler.status == Status.success) {
      navigate();
    }*/

    /// Below code is handled with V3 API
    _registrationController.saveFormDetails(formObject);
    navigate();
  }

  /// @Here is the function to navigate AbhaAddressForm screen
  void navigate() {
    // Map data = _registrationController.responseHandler.data;
    // if (data.isNotEmpty) {
    var arguments = {
      IntentConstant.fromScreen: _fromScreenString,
    };
    context.navigatePushReplacement(
      RoutePath.routeRegistrationAbhaAddress,
      arguments: arguments,
    );
    // }
  }

  /// @Here function used to show the states.
  void _onGetStates() async {
    await _registrationController.functionHandler(
      function: () => _registrationController.getStates(context: context),
      isLoaderReq: true,
    );
    if (_registrationController.responseHandler.status == Status.success) {
      List data = _registrationController.responseHandler.data;
      if (!Validator.isNullOrEmpty(data)) {
        List<StateEntry> localArr = [];
        for (var i = 0; i < data.length; i++) {
          localArr.add(StateEntry.fromMap(data[i]));
        }
        localArr.sort((a, b) => a.title.compareTo(b.title));
        setState(() {
          _registrationFormController.states = localArr;
        });
      }
    }
  }

  /* ///@Here function used to show the list of Years.
  void _onGenerateYears() {
    var currentYear = DateTime(DateTime.now().year);
    List<String> localArr = [];
    for (var i = currentYear.year; i >= currentYear.year - 120; i--) {
      localArr.add('$i');
    }
    setState(() {
      _registrationFormController.birthYears = localArr;
    });
  }

  /// @Here function to show the list of dates
  void _onGenerateDates() {
    List<String> localArr = [];
    for (var i = 1; i <= 31; i++) {
      localArr.add('$i');
    }
    setState(() {
      _registrationFormController.dates = localArr;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    initScreenTitleText();
    return BaseView(
      paddingValueMobile: Dimen.d_0,
      title: _screenTitle,
      type: RegistrationFormView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: RegistrationFormMobileView(
        arguments: widget.arguments,
        onFormSubmission: onFormSubmission,
        registrationFormController: _registrationFormController,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: RegistrationFormDesktopView(
        arguments: widget.arguments,
        onFormSubmission: onFormSubmission,
        registrationFormController: _registrationFormController,
        isButtonEnable: isButtonEnable,
      ),
    );
  }
}
