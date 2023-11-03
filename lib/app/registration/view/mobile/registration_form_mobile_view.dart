import 'package:abha/app/profile/view/main/profile_edit_view.dart';
import 'package:abha/app/registration/controller/reg_form_controller.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/agreement/user_info_agreement_view.dart';
import 'package:abha/reusable_widget/date_picker_view/date_picker.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/dropdown/decoration/drop_down_field_decoration.dart';
import 'package:abha/reusable_widget/dropdown/dropdown_field.dart';
import 'package:abha/reusable_widget/search/custom_search_list_view.dart';
import 'package:abha/service/lgd_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class RegistrationFormMobileView extends StatefulWidget {
  final Map arguments;
  final Function(Map formObject) onFormSubmission;
  final RegistrationFormController registrationFormController;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationFormMobileView({
    required this.arguments,
    required this.onFormSubmission,
    required this.registrationFormController,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationFormMobileViewState createState() =>
      RegistrationFormMobileViewState();
}

class RegistrationFormMobileViewState
    extends State<RegistrationFormMobileView> {
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
    widget.isButtonEnable.value = false;
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
          context: context,
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
    return kIsWeb
        ? MobileWebCardWidget(child: _registrationFormWidget())
        : SingleChildScrollView(child: _registrationFormWidget());
  }

  Widget _registrationFormWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: _registrationFormController.autoValidateMode,
        child: Column(
          children: WidgetUtility.spreadWidgets(
            [
              if (kIsWeb)
                Text(
                  initScreenTitleText(),
                  style: CustomTextStyle.titleMedium(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ).paddingSymmetric(
                  vertical: Dimen.d_20,
                  horizontal: Dimen.d_20,
                ),
              AppTextFormField.mobile(
                context: context,
                title: LocalizationHandler.of().fullName,
                isRequired: true,
                textCapitalization: TextCapitalization.words,
                hintText: LocalizationHandler.of().hintEnterYourFullName,
                key: const Key(
                  KeyConstant.firstNameHintField,
                ),
                textEditingController: _registrationFormController.fullNameTEC,
                validator: (value) {
                  if (Validator.isNullOrEmpty(
                    value?.trim(),
                  )) {
                    return LocalizationHandler.of().enterValidFullName;
                  }
                  if (value!.trim().split(' ').length <= 1) {
                    return LocalizationHandler.of().enterValidFullName;
                  }
                  return null;
                },
              ).marginOnly(top: Dimen.d_26),
              if (_fromScreenString == 'registrationEmail')
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().enterMobileNumber,
                  hintText: LocalizationHandler.of().hintEnterMobileNumber,
                  key: const Key(
                    KeyConstant.mobileNumberField,
                  ),
                  textEditingController:
                      _registrationFormController.mobileNumberTEC,
                  maxLength: 10,
                  validator: (value) {
                    if (!Validator.isNullOrEmpty(value)) {
                      if (!Validator.isMobileValid(
                        value!,
                      )) {
                        return LocalizationHandler.of().invalidMobile;
                      }
                    }
                    return null;
                  },
                ),
              if (_fromScreenString == 'registrationMobile')
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().enterEmailId,
                  hintText: LocalizationHandler.of().hintEnterYourEmailAddress,
                  key: const Key(KeyConstant.emailIdField),
                  textEditingController: _registrationFormController.emailTEC,
                  validator: (value) {
                    if (!Validator.isNullOrEmpty(value)) {
                      if (!Validator.isEmailValid(
                        value!,
                      )) {
                        return LocalizationHandler.of().invalidEmailError;
                      }
                    }
                    return null;
                  },
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DatePicker.mobile(
                      selectedDate: _registrationFormController.birthDate,
                      context: context,
                      onDateChange: (date) {
                        setState(() {
                          _registrationFormController.birthDate = date!;
                        });
                      },
                    ),
                  )
                ],
              ),
              DropDownField<String>.mobile(
                context: context,
                title: LocalizationHandler.of().gender,
                isRequired: true,
                key: const Key(KeyConstant.genderDropDown),
                validator: (value) {
                  if (Validator.isNullOrEmpty(value)) {
                    return LocalizationHandler.of().pleaseSelectGender;
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
                          style: CustomTextStyle.bodyMedium(context)?.apply(),
                        ),
                      ),
                    )
                    .toList(),
                value: _registrationFormController.selectedGenderValue,
                onChanged: (value) {
                  setState(() {
                    _registrationFormController.selectedGenderValue =
                        value as String;
                  });
                },
              ),
              AppTextFormField.mobile(
                context: context,
                title: LocalizationHandler.of().titleAddress,
                isRequired: true,
                key: const Key(
                  KeyConstant.addressHintField,
                ),
                hintText: LocalizationHandler.of().enterYourAddress,
                textEditingController: _registrationFormController.addressTEC,
                validator: (value) {
                  if (Validator.isNullOrEmpty(
                    value?.trim(),
                  )) {
                    return LocalizationHandler.of().enterValidAddress;
                  }
                  if (!value!.trim().startsWith(
                        RegExp('[a-zA-Z0-9]'),
                      )) {
                    return LocalizationHandler.of()
                        .addressShouldStartsWithCharacter;
                  }
                  return null;
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GetBuilder<RegistrationController>(
                          builder: (_) => ClickableDropDown<StateEntry>(
                            context: context,
                            title: LocalizationHandler.of().state,
                            isRequired: true,
                            key: const Key(KeyConstant.selectStateDrpDwn),
                            validator: (value) {
                              if (Validator.isNullOrEmpty(value)) {
                                return LocalizationHandler.of()
                                    .pleaseSelectState;
                              }
                              return null;
                            },
                            hint: LocalizationHandler.of().pleaseSelectState,
                            value:
                                _registrationFormController.selectedStateValue,
                            decoration:
                                DropDownDecoration().underLineBorderDecoration(
                              context: context,
                              hintText:
                                  LocalizationHandler.of().pleaseSelectState,
                            ),
                            onClick: () {
                              CustomBottomSheetOrDialogHandler
                                  .bottomSheetOrDialog(
                                isScrollControlled: true,
                                mContext: context,
                                height: context.height * 0.5,
                                child: CustomSearchListView(
                                  hintSearch:
                                      LocalizationHandler.of().searchState,
                                  selectedItem: _registrationFormController
                                      .selectedStateValue,
                                  title: LocalizationHandler.of()
                                      .pleaseSelectState,
                                  itemList: _registrationFormController.states,
                                  onClick: (item) {
                                    setState(() {
                                      _registrationFormController
                                              .selectedStateValue =
                                          item as StateEntry;
                                      _registrationFormController
                                          .selectedDistrictValue = null;
                                      updatePinCodeState(
                                        pinCode: _registrationFormController
                                            .pinCodeTEC.text,
                                      );
                                      _onGetDistricts();
                                    });
                                  },
                                ).marginSymmetric(
                                  horizontal: Dimen.d_16,
                                  vertical: Dimen.d_16,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GetBuilder<RegistrationController>(
                          builder: (_) => ClickableDropDown<DistrictEntry>(
                            context: context,
                            title: LocalizationHandler.of().district,
                            isRequired: true,
                            key: const Key(KeyConstant.selectDistrictDropDown),
                            validator: (value) {
                              if (Validator.isNullOrEmpty(value)) {
                                return LocalizationHandler.of()
                                    .pleaseSelectDistrict;
                              }
                              return null;
                            },
                            hint: LocalizationHandler.of().selectdistric,
                            value: _registrationFormController
                                .selectedDistrictValue,
                            decoration:
                                DropDownDecoration().underLineBorderDecoration(
                              context: context,
                              hintText:
                                  LocalizationHandler.of().pleaseSelectDistrict,
                            ),
                            onClick: () {
                              CustomBottomSheetOrDialogHandler
                                  .bottomSheetOrDialog(
                                isScrollControlled: true,
                                mContext: context,
                                height: context.height * 0.5,
                                child: CustomSearchListView(
                                  hintSearch:
                                      LocalizationHandler.of().searchDistrict,
                                  selectedItem: _registrationFormController
                                      .selectedDistrictValue,
                                  title: LocalizationHandler.of()
                                      .pleaseSelectDistrict,
                                  itemList:
                                      _registrationFormController.districts,
                                  onClick: (item) {
                                    setState(() {
                                      _registrationFormController
                                              .selectedDistrictValue =
                                          item as DistrictEntry;
                                      _registrationFormController
                                          .districtTEC.text = item.title;
                                      updatePinCodeState(
                                        pinCode: _registrationFormController
                                            .pinCodeTEC.text,
                                      );
                                    });
                                  },
                                ).marginSymmetric(
                                  horizontal: Dimen.d_16,
                                  vertical: Dimen.d_16,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              AppTextFormField.mobile(
                context: context,
                key: const Key(KeyConstant.pincodField),
                title: LocalizationHandler.of().enterYourPinCode,
                isRequired: true,
                textEditingController: _registrationFormController.pinCodeTEC,
                maxLength: 6,
                hintText: LocalizationHandler.of().hintEnterYourPinCode,
                onChanged: (String value) {
                  setState(() {
                    updatePinCodeState(pinCode: value);
                  });
                },
                suffix: pinCodeState != PinCodeState.hide
                    ? AbsorbPointer(
                        absorbing: pinCodeState == PinCodeState.matched,
                        child: InkWell(
                          onTap: () async {
                            LGDDetails? details =
                                await _registrationController.validatePinCode(
                              _registrationFormController.pinCodeTEC.text,
                            );
                            if (details == null) {
                              MessageBar.showToastError(
                                LocalizationHandler.of().pinCodeMatchNotFound,
                              );
                              _registrationFormController.pinCodeTEC.clear();
                              setState(() {
                                pinCodeState = PinCodeState.hide;
                              });
                              return;
                            } else if (details.stateCode !=
                                    _registrationFormController
                                        .selectedStateValue?.stateCode ||
                                details.districtCode !=
                                    _registrationFormController
                                        .selectedDistrictValue?.districtCode) {
                              MessageBar.showToastError(
                                LocalizationHandler.of().pinCodeMatchNotFound,
                              );
                              _registrationFormController.pinCodeTEC.clear();
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
                          child: (pinCodeState == PinCodeState.reset)
                              ? Text(
                                  LocalizationHandler.of().check,
                                  style: InputFieldStyleDesktop.labelTextStyle
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
                    return LocalizationHandler.of().enterValidPinCode;
                  }
                  if (value!.trim().length != 6) {
                    return LocalizationHandler.of().enterValidPinCode;
                  }
                  if (double.parse(value.trim()) <= 0) {
                    return LocalizationHandler.of().enterValidPinCode;
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: () {
                      setState(() {
                        _registrationFormController.checkbox1 =
                            !_registrationFormController.checkbox1;
                      });
                      widget.isButtonEnable.value =
                          _registrationFormController.checkbox1;
                      _registrationController.functionHandler(
                        isUpdateUi: true,
                        updateUiBuilderIds: [
                          UpdateAddressSelectUiBuilderIds.updateLoginButton
                        ],
                      );
                    },
                    icon: Icon(
                      _registrationFormController.checkbox1
                          ? IconAssets.checkboxSelect
                          : IconAssets.checkboxUnselect,
                      size: Dimen.d_32,
                      color: AppColors.colorAppBlue,
                    ),
                  ).paddingSymmetric(horizontal: Dimen.d_0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationHandler.of().agreementText,
                          softWrap: true,
                          style: CustomTextStyle.labelLarge(context)?.apply(
                            color: AppColors.colorBlack6,
                            heightDelta: 0.5,
                          ),
                        ),
                        GestureDetector(
                          key: const Key(KeyConstant.agreementTextDlg),
                          onTap: () {
                            context.openDialog(
                              const CustomSimpleDialog(
                                child: UserInfoAgrementWidget(),
                              ),
                            );
                          },
                          child: Text(
                            LocalizationHandler.of().userInformationAgreement,
                            style: CustomTextStyle.labelLarge(context)?.apply(
                              decoration: TextDecoration.underline,
                              color: AppColors.colorAppOrange,
                              heightDelta: 0.5,
                            ),
                          ).marginOnly(top: Dimen.d_2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: widget.isButtonEnable,
                builder: (context, isButtonEnable, _) {
                  return TextButtonOrange.mobile(
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
                            LocalizationHandler.of()
                                .userInformationAgreementError,
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
                            if (currentDate.difference(dayOfBirthDate).inDays <
                                0) {
                              MessageBar.showToastDialog(
                                LocalizationHandler.of().invalidDateSelected,
                              );
                              return;
                            }
                          } catch (e) {
                            abhaLog
                                .e('Date parse exception is ${e.toString()}');
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
                  ).marginOnly(top: Dimen.d_25, bottom: Dimen.d_35);
                },
              )
            ],
            interItemSpace: Dimen.d_26,
            flowHorizontal: false,
          ),
        ),
      )
          .paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0)
          .marginOnly(left: Dimen.d_16, right: Dimen.d_16),
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
