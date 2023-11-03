import 'package:abha/app/profile/view/main/profile_edit_view.dart';
import 'package:abha/app/registration/controller/reg_form_controller.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/agreement/user_info_agreement_view.dart';
import 'package:abha/reusable_widget/date_picker_view/date_picker.dart';
import 'package:abha/reusable_widget/dropdown/dropdown_field.dart';
import 'package:abha/service/lgd_service.dart';
import 'package:intl/intl.dart';

class RegistrationFormDesktopView extends StatefulWidget {
  final Map arguments;
  final Function(Map formObject) onFormSubmission;
  final RegistrationFormController registrationFormController;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationFormDesktopView({
    required this.arguments,
    required this.onFormSubmission,
    required this.registrationFormController,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationFormDesktopViewState createState() =>
      RegistrationFormDesktopViewState();
}

class RegistrationFormDesktopViewState
    extends State<RegistrationFormDesktopView> {
  late RegistrationController _registrationController;
  late RegistrationFormController _registrationFormController;
  final _formKey = GlobalKey<FormState>();
  late FullNameModel fullNameModel;
  late String _fromScreenString;
  PinCodeState pinCodeState = PinCodeState.hide;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find<RegistrationController>();
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _registrationFormController = widget.registrationFormController;
  }

  /// @Here function set the title as selected registration type in [_screenTitle]
  /// and email value or mobile value into the string [emailTextController.text]
  String initScreenTitleText() {
    if (_fromScreenString == 'registrationEmail') {
      return LocalizationHandler.of().registrationWithEmail.toTitleCase();
    } else if (_fromScreenString == 'registrationMobile') {
      return LocalizationHandler.of()
          .registrationWithMobileNumber
          .toTitleCase();
    }
    return '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here function used to display the districts
  void _onGetDistricts() async {
    if (_registrationFormController.selectedStateValue != null) {
      setState(() {
        _registrationFormController.districtTEC.text = '';
        _registrationFormController.districts = [];
      });
      await _registrationController.functionHandler(
        function: () => _registrationController.getDistricts(
          _registrationFormController.selectedStateValue!.stateCode.toString(),
        ),
        isLoaderReq: true,
      );
      if (_registrationController.responseHandler.status == Status.success) {
        List data = _registrationController.responseHandler.data;
        if (!Validator.isNullOrEmpty(data)) {
          List<DistrictEntry> localArr = [];
          for (var i = 0; i < data.length; i++) {
            localArr.add(DistrictEntry.fromMap(data[i]));
          }
          localArr.sort((a, b) => a.title.compareTo(b.title));
          setState(() {
            _registrationFormController.districtTEC.clear();
            _registrationFormController.districts = localArr;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _registrationFormWidget();
  }

  Widget _registrationFormWidget() {
    return Card(
      shape: abhaSingleton.getBorderDecoration.getRectangularShapeBorder(),
      elevation: Dimen.d_5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            initScreenTitleText(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).paddingSymmetric(vertical: Dimen.d_20).marginOnly(left: Dimen.d_20),
          Divider(
            height: Dimen.d_1,
            color: AppColors.colorGreyWildSand,
          ),
          Form(
            key: _formKey,
            autovalidateMode: _registrationFormController.autoValidateMode,
            child: Column(
              children: WidgetUtility.spreadWidgets(
                [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: WidgetUtility.spreadWidgets(
                      [
                        Expanded(
                          child: AppTextFormField.desktop(
                            context: context,
                            title: LocalizationHandler.of().fullName,
                            isRequired: true,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            textCapitalization: TextCapitalization.words,
                            hintText:
                                LocalizationHandler.of().hintEnterYourFullName,
                            key: const Key(KeyConstant.firstNameHintField),
                            textEditingController:
                                _registrationFormController.fullNameTEC,
                            validator: (value) {
                              if (Validator.isNullOrEmpty(value?.trim())) {
                                return LocalizationHandler.of()
                                    .enterValidFullName;
                              }
                              if (value!.trim().split(' ').length <= 1) {
                                return LocalizationHandler.of()
                                    .enterValidFullName;
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: AppTextFormField.desktop(
                            context: context,
                            title: LocalizationHandler.of()
                                .titleEnterResidentialAddress,
                            hintText: LocalizationHandler.of()
                                .hintEnterResidentialAddress,
                            isRequired: true,
                            key: const Key(KeyConstant.addressHintField),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            textEditingController:
                                _registrationFormController.addressTEC,
                            validator: (value) {
                              if (Validator.isNullOrEmpty(value?.trim())) {
                                return LocalizationHandler.of()
                                    .enterValidAddress;
                              }
                              if (!value!
                                  .trim()
                                  .startsWith(RegExp('[a-zA-Z0-9]'))) {
                                return LocalizationHandler.of()
                                    .addressShouldStartsWithCharacter;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                      interItemSpace: Dimen.d_24,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: WidgetUtility.spreadWidgets(
                      [
                        if (_fromScreenString == 'registrationEmail')
                          Expanded(
                            child: AppTextFormField.desktop(
                              context: context,
                              title: LocalizationHandler.of().enterMobileNumber,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              hintText: LocalizationHandler.of()
                                  .hintEnterMobileNumber,
                              key: const Key(KeyConstant.mobileNumberField),
                              textEditingController:
                                  _registrationFormController.mobileNumberTEC,
                              maxLength: 10,
                              validator: (value) {
                                if (!Validator.isNullOrEmpty(value)) {
                                  if (!Validator.isMobileValid(value!)) {
                                    return LocalizationHandler.of()
                                        .invalidMobile;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        if (_fromScreenString == 'registrationMobile')
                          Expanded(
                            child: AppTextFormField.desktop(
                              context: context,
                              title: LocalizationHandler.of().emailId,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              hintText: LocalizationHandler.of()
                                  .hintEnterEmailAddress,
                              key: const Key(KeyConstant.emailIdField),
                              textEditingController:
                                  _registrationFormController.emailTEC,
                              validator: (value) {
                                // if (Validator.isNullOrEmpty(value)) {
                                //   return LocalizationHandler.of()
                                //       .enterValidEmailID;
                                // }
                                if (!Validator.isNullOrEmpty(value)) {
                                  if (!Validator.isEmailValid(value!)) {
                                    return LocalizationHandler.of()
                                        .invalidEmailError;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        Expanded(
                          child: GetBuilder<RegistrationController>(
                            builder: (_) => SearchableDropdown<StateEntry>(
                              controller: _registrationFormController.stateTEC,
                              title: LocalizationHandler.of().state,
                              isRequired: true,
                              value: _registrationFormController
                                  .selectedStateValue,
                              hint: LocalizationHandler.of().pleaseSelectState,
                              searchHint: LocalizationHandler.of().searchState,
                              validator: (value) {
                                if (Validator.isNullOrEmpty(value) ||
                                    _registrationFormController.states
                                        .where(
                                          (element) =>
                                              element.stateName
                                                  ?.trim()
                                                  .toLowerCase() ==
                                              value?.stateName
                                                  ?.trim()
                                                  .toLowerCase(),
                                        )
                                        .isEmpty) {
                                  return LocalizationHandler.of()
                                      .pleaseSelectState;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _registrationFormController
                                      .selectedStateValue = value as StateEntry;
                                  _registrationFormController
                                      .selectedDistrictValue = null;
                                  updatePinCodeState(
                                    pinCode: _registrationFormController
                                        .pinCodeTEC.text,
                                  );
                                  _onGetDistricts();
                                });
                              },
                              items: _registrationFormController.states
                                  .map(
                                    (item) => DropdownMenuItem<StateEntry>(
                                      value: item,
                                      child: Text(
                                        item.title.toTitleCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: InputFieldStyleDesktop
                                            .inputFieldStyle,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                      interItemSpace: Dimen.d_24,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: WidgetUtility.spreadWidgets(
                      [
                        Expanded(
                          child: DatePicker.desktop(
                            selectedDate: _registrationFormController.birthDate,
                            isFromDesktop: true,
                            context: context,
                            onDateChange: (date) {
                              setState(() {
                                _registrationFormController.birthDate = date!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: GetBuilder<RegistrationController>(
                            builder: (_) => SearchableDropdown<DistrictEntry>(
                              title: LocalizationHandler.of().district,
                              isRequired: true,
                              controller:
                                  _registrationFormController.districtTEC,
                              value: _registrationFormController
                                  .selectedDistrictValue,
                              hint:
                                  LocalizationHandler.of().pleaseSelectDistrict,
                              searchHint:
                                  LocalizationHandler.of().searchDistrict,
                              validator: (value) {
                                if (Validator.isNullOrEmpty(value) ||
                                    _registrationFormController.districts
                                        .where(
                                          (element) =>
                                              element.districtName
                                                  ?.trim()
                                                  .toLowerCase() ==
                                              value?.districtName
                                                  ?.trim()
                                                  .toLowerCase(),
                                        )
                                        .isEmpty) {
                                  return LocalizationHandler.of()
                                      .pleaseSelectDistrict;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _registrationFormController
                                          .selectedDistrictValue =
                                      value as DistrictEntry;
                                  updatePinCodeState(
                                    pinCode: _registrationFormController
                                        .pinCodeTEC.text,
                                  );
                                });
                              },
                              items: _registrationFormController.districts
                                  .map(
                                    (item) => DropdownMenuItem<DistrictEntry>(
                                      value: item,
                                      child: Text(
                                        item.title.toTitleCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: InputFieldStyleDesktop
                                            .inputFieldStyle,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                      interItemSpace: Dimen.d_24,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: WidgetUtility.spreadWidgets(
                      [
                        Expanded(
                          child: DropDownField<String>.desktop(
                            context: context,
                            title: LocalizationHandler.of().gender,
                            isRequired: true,
                            key: const Key(KeyConstant.genderDropDown),
                            validator: (value) {
                              if (Validator.isNullOrEmpty(value)) {
                                return LocalizationHandler.of()
                                    .pleaseSelectGender;
                              }
                              return null;
                            },
                            hint: LocalizationHandler.of().pleaseSelectGender,
                            items: _registrationFormController.genders
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item['code'],
                                    child: Text(
                                      "${item['name']}",
                                      style: CustomTextStyle.bodyMedium(
                                        context,
                                      )?.apply(),
                                    ),
                                  ),
                                )
                                .toList(),
                            value:
                                _registrationFormController.selectedGenderValue,
                            onChanged: (value) {
                              setState(() {
                                _registrationFormController
                                    .selectedGenderValue = value as String;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: AppTextFormField.desktop(
                            context: context,
                            key: const Key(KeyConstant.pincodField),
                            title: LocalizationHandler.of().pinCode,
                            hintText:
                                LocalizationHandler.of().hintEnterYourPinCode,
                            isRequired: true,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            textEditingController:
                                _registrationFormController.pinCodeTEC,
                            maxLength: 6,
                            onChanged: (String value) {
                              setState(() {
                                updatePinCodeState(pinCode: value);
                              });
                            },
                            suffix: pinCodeState != PinCodeState.hide
                                ? AbsorbPointer(
                                    absorbing:
                                        pinCodeState == PinCodeState.matched,
                                    child: InkWell(
                                      onTap: () async {
                                        LGDDetails? details =
                                            await _registrationController
                                                .validatePinCode(
                                          _registrationFormController
                                              .pinCodeTEC.text,
                                        );
                                        if (details == null) {
                                          MessageBar.showToastError(
                                            LocalizationHandler.of()
                                                .pinCodeMatchNotFound,
                                          );
                                          _registrationFormController.pinCodeTEC
                                              .clear();
                                          setState(() {
                                            pinCodeState = PinCodeState.hide;
                                          });
                                          return;
                                        } else if (details.stateCode !=
                                                _registrationFormController
                                                    .selectedStateValue
                                                    ?.stateCode ||
                                            details.districtCode !=
                                                _registrationFormController
                                                    .selectedDistrictValue
                                                    ?.districtCode) {
                                          MessageBar.showToastError(
                                            LocalizationHandler.of()
                                                .pinCodeMatchNotFound,
                                          );
                                          _registrationFormController.pinCodeTEC
                                              .clear();
                                          setState(() {
                                            pinCodeState = PinCodeState.hide;
                                          });
                                          return;
                                        } else {
                                          setState(() {
                                            pinCodeState = PinCodeState.matched;
                                          });
                                        }
                                      },
                                      child: (pinCodeState ==
                                              PinCodeState.reset)
                                          ? Text(
                                              LocalizationHandler.of().check,
                                              style: InputFieldStyleDesktop
                                                  .labelTextStyle
                                                  ?.apply(
                                                color: InputFieldStyleDesktop
                                                    .focusedBorderColor,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.check,
                                              color: AppColors.colorGreenLight3,
                                            ),
                                    ),
                                  )
                                : null,
                            textInputType: TextInputType.number,
                            validator: (value) {
                              if (Validator.isNullOrEmpty(
                                value?.trim(),
                              )) {
                                return LocalizationHandler.of()
                                    .enterValidPinCode;
                              }
                              if (value!.trim().length != 6) {
                                return LocalizationHandler.of()
                                    .enterValidPinCode;
                              }
                              if (double.parse(value.trim()) <= 0) {
                                return LocalizationHandler.of()
                                    .enterValidPinCode;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                      interItemSpace: Dimen.d_24,
                    ),
                  ),
                  _termsAndAgreementWidget(),
                  _registrationFormSubmitButton().marginOnly(top: Dimen.d_10)
                ],
                interItemSpace: Dimen.d_16,
                flowHorizontal: false,
              ),
            ),
          ).paddingSymmetric(
            vertical: Dimen.d_20,
            horizontal: Dimen.d_20,
          ),
        ],
      ),
    ).marginSymmetric(
      vertical: Dimen.d_20,
      horizontal: Dimen.d_100,
    );
  }

  Widget _termsAndAgreementWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _registrationFormController.checkbox1 =
                  !_registrationFormController.checkbox1;
            });
            widget.isButtonEnable.value = _registrationFormController.checkbox1;
            _registrationController.functionHandler(
              isUpdateUi: true,
              updateUiBuilderIds: [
                UpdateAddressSelectUiBuilderIds.updateLoginButton
              ],
            );
          },
          child: Icon(
            _registrationFormController.checkbox1
                ? IconAssets.checkboxSelect
                : IconAssets.checkboxUnselect,
            size: Dimen.d_32,
            color: AppColors.colorAppBlue,
          ),
        ).paddingAll(Dimen.d_0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationHandler.of().agreementText,
                softWrap: true,
                style: CustomTextStyle.labelMedium(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontWeightDelta: 2,
                ),
              ),
              GestureDetector(
                key: const Key(KeyConstant.agreementTextDlg),
                onTap: () {
                  context.openDialog(
                    CustomSimpleDialog(
                      child: const UserInfoAgrementWidget()
                          .sizedBox(width: context.width * 0.4),
                    ),
                  );
                },
                child: Text(
                  LocalizationHandler.of().userInformationAgreement,
                  style: CustomTextStyle.labelMedium(context)?.apply(
                    decoration: TextDecoration.underline,
                    color: AppColors.colorAppOrange,
                  ),
                ).marginOnly(top: Dimen.d_2),
              ),
            ],
          ).marginOnly(left: Dimen.d_5),
        )
      ],
    );
  }

  Widget _registrationFormSubmitButton() {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.desktop(
              // width: context.width * 0.15,
              isButtonEnable: isButtonEnable,
              text: LocalizationHandler.of().continuee,
              onPressed: () {
                if (isButtonEnable) {
                  // form
                  final isValid = _formKey.currentState?.validate();
                  if (!isValid!) {
                    setState(() {
                      _registrationFormController.autoValidateMode =
                          AutovalidateMode.always;
                    });
                    return;
                  }
                  if (!_registrationFormController.checkbox1) {
                    MessageBar.showToastDialog(
                      LocalizationHandler.of().userInformationAgreementError,
                    );
                    return;
                  }
                  if (!Validator.isNullOrEmpty(
                    _registrationFormController.birthDate.date,
                  )) {
                    try {
                      DateFormat format = DateFormat('dd/MM/yyyy');
                      String date =
                          '${_registrationFormController.birthDate.date!}/${_registrationFormController.birthDate.month!}/${_registrationFormController.birthDate.year!}';
                      DateTime dayOfBirthDate = format.parseStrict(date);
                      abhaLog.i('Date parse is $dayOfBirthDate');
                      DateTime currentDate = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      );
                      if (currentDate.difference(dayOfBirthDate).inDays < 0) {
                        MessageBar.showToastDialog(
                          LocalizationHandler.of().invalidDateSelected,
                        );
                        return;
                      }
                    } catch (e) {
                      abhaLog.e('Date parse exception is ${e.toString()}');
                      MessageBar.showToastDialog(
                        LocalizationHandler.of().invalidDateSelected,
                      );
                      return;
                    }
                  }

                  String fullName =
                      _registrationFormController.fullNameTEC.text.trim();
                  fullNameModel = Validator.fetchFullName(fullName);
                  var formObject = _registrationFormController
                      .createFormReqData(fullNameModel);
                  widget.onFormSubmission(formObject);
                }
              },
            );
          },
        ).marginOnly(right: Dimen.d_16),
        TextButtonPurple.desktop(
          text: LocalizationHandler.of().cancel,
          onPressed: () {
            setState(() {
              _registrationController.mobileTexController.text = '';
              _registrationController.abhaNumberTextController.text = '';
              _registrationController.emailTextController.text = '';
              _registrationController.autoValidateModeWeb =
                  AutovalidateMode.disabled;
            });
            context.navigateBack();
          },
        ).marginOnly(right: Dimen.d_16),
      ],
    );
  }

  Widget textMiddleNameOptional(Key key, String txtOptional) {
    return RichText(
      key: key,
      text: TextSpan(
        style: CustomTextStyle.bodyMedium(context)?.apply(
          color: AppColors.colorGreyDark1,
          fontWeightDelta: 2,
          fontSizeDelta: -2,
        ),
        children: <TextSpan>[
          TextSpan(
            text: txtOptional,
          ),
        ],
      ),
    );
  }

  Widget inputFiledView({
    required String key,
    required String title,
    required Widget child,
    bool mandatory = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          key: Key(key),
          text: TextSpan(
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: AppColors.colorGreyDark1,
              fontWeightDelta: 2,
              fontSizeDelta: -2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: title,
              ),
              if (mandatory)
                TextSpan(
                  text: ' *',
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorRed,
                  ),
                ),
            ],
          ),
        ),
        Container(child: child)
      ],
    );
  }

  void updatePinCodeState({required String pinCode}) {
    if (_registrationFormController.selectedStateValue != null &&
        _registrationFormController.selectedDistrictValue != null) {
      if (Validator.isNullOrEmpty(pinCode.trim()) ||
          pinCode.trim().length != 6 ||
          double.parse(pinCode.trim()) <= 0) {
        pinCodeState = PinCodeState.hide;
      } else {
        pinCodeState = PinCodeState.reset;
      }
    } else {
      pinCodeState = PinCodeState.hide;
    }
  }
}
