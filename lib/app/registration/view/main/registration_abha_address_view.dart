import 'package:abha/app/registration/view/desktop/registration_abha_address_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_abha_address_mobile_view.dart';
import 'package:abha/export_packages.dart';

class RegistrationAbhaAddressView extends StatefulWidget {
  final Map arguments;

  const RegistrationAbhaAddressView({required this.arguments, super.key});

  @override
  RegistrationAbhaAddressViewState createState() =>
      RegistrationAbhaAddressViewState();
}

class RegistrationAbhaAddressViewState
    extends State<RegistrationAbhaAddressView> {
  late RegistrationController _registrationController;

  late String _screenTitle = '';
  late String _fromScreenString;
  Map configData = abhaSingleton.getAppConfig.getConfigData();

  @override
  void initState() {
    super.initState();
    _registrationController = Get.put<RegistrationController>(
      RegistrationController(RegistrationRepoImpl()),
    );

    _fromScreenString = widget.arguments['fromScreen'];
    _registrationController = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _onGetSuggestedAbhaAddress();
    });
  }

  @override
  void dispose() {
    _registrationController.abhaAddressTEC.text = '';
    _registrationController.passwordTEC.text = '';
    _registrationController.confirmPasswordTEC.text = '';
    _registrationController.passwordVisible = false;
    _registrationController.confirmPasswordVisible = false;
    _registrationController.suggestedAbhaAddress = null;
    _registrationController.isAbhaAddressExist = null;
    _registrationController.showAbhaAddressAvailability = false;
    _registrationController.abhaAddressSelectedValue = null;
    super.dispose();
  }

  void initScreenTitleText() {
    if (_fromScreenString == 'registrationEmail') {
      _screenTitle =
          LocalizationHandler.of().registrationWithEmail.toTitleCase();
    } else if (_fromScreenString == 'registrationMobile') {
      _screenTitle =
          LocalizationHandler.of().registrationWithMobileNumber.toTitleCase();
    } else if (_fromScreenString == 'registrationAbha') {
      _screenTitle = LocalizationHandler.of().registrationWithABHANUmber;
    }
  }

  /// This method is used to submit the form object for registration in Abha.
  /// It calls the [functionHandler] of [_registrationController] and sets the [isLogin] value of [SharedPref] to true.
  /// Then it navigates to the [routeDashboard] page with arguments containing the abha address.
  Future<void> onAbhaFormSubmission(Map formObject) async {
    await _registrationController
        .functionHandler(
      function: () =>
          _registrationController.getRegistrationAbhaFormSubmission(formObject),
      isLoaderReq: true,
    )
        .whenComplete(() async {
      if (_registrationController.responseHandler.status == Status.success) {
        /// Now we don't need to call verify user API to fetch the x header token
        /// We are directly getting those in register API
        abhaSingleton.getApiProvider
            .addXHeaderToken(_registrationController.tempResponseData);

        // if (_registrationController.responseHandler.status == Status.success) {
        abhaSingleton.getSharedPref.setLogin().whenComplete(() {
          var arguments = {
            IntentConstant.abhaAddress:
                '${_registrationController.abhaAddressTEC.text}${configData[AppConfig.abhaAddressSuffix]}'
          };
          context.navigateGo(
            RoutePath.routeDashboard,
            arguments: arguments,
          );
        });
        // }
      }
    });
  }

  /// This method is used to get the suggested Abha address from the server.
  /// It calls the [_registrationController.functionHandler] method with a function that returns the suggested Abha address and sets a boolean value for [isLoaderReq] to true.
  /// If the response status is successful, it stores the data in a map and sets the state of [_suggestedAbhaAddress] to the value of 'suggestedPhrAddress'.
  void _onGetSuggestedAbhaAddress() async {
    await _registrationController.functionHandler(
      function: () => _registrationController.getSuggestedAbhaAddress(),
      isLoaderReq: true,
    );
    if (_registrationController.responseHandler.status == Status.success) {
      Map data = _registrationController.responseHandler.data;
      if (!Validator.isNullOrEmpty(data)) {
        setState(() {
          _registrationController.suggestedAbhaAddress =
              data['abhaAddressList'];
        });
      }
    }
  }

  /// Checks if the given [abhaAddress] exists in the database.
  ///
  /// The [_onIsAbhaAddressExist] method calls the [_registrationController.getIsAbhaAddressExist] function and sets the [_isAbhaAddressExist] boolean to true if the address exists in the database.
  ///
  /// @param abhaAddress The address to be checked for existence.
  void _onIsAbhaAddressExist(String abhaAddress) async {
    _registrationController.showLoader.value = true;
    await _registrationController.functionHandler(
      function: () =>
          _registrationController.getIsAbhaAddressExist(abhaAddress),
      isLoaderReq: false,
    );
    bool status = true;
    if (_registrationController.responseHandler.status == Status.success) {
      // Map data = _registrationController.responseHandler.data;
      dynamic data = _registrationController.responseHandler.data;
      if (!Validator.isNullOrEmpty(data)) {
        // status = data['status'] as bool;
        status = data as bool;
      }
    }
    _registrationController.showLoader.value = false;
    setState(() {
      _registrationController.isAbhaAddressExist = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenTitleText();
    return BaseView(
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      title: _screenTitle,
      type: RegistrationAbhaAddressView,
      bodyMobile: RegistrationAbhaAddressMobileView(
        arguments: widget.arguments,
        onAbhaFormSubmission: onAbhaFormSubmission,
        onIsAbhaAddressExist: _onIsAbhaAddressExist,
      ),
      bodyDesktop: RegistrationAbhaAddressDesktopView(
        arguments: widget.arguments,
        onAbhaFormSubmission: onAbhaFormSubmission,
        onIsAbhaAddressExist: _onIsAbhaAddressExist,
      ),
    );
  }
}
