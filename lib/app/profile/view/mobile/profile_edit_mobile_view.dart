import 'package:abha/app/profile/controller/profile_edit_controller.dart';
import 'package:abha/app/profile/view/main/profile_edit_view.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/date_picker_view/date_picker.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/dropdown/decoration/drop_down_field_decoration.dart';
import 'package:abha/reusable_widget/dropdown/dropdown_field.dart';
import 'package:abha/reusable_widget/search/custom_search_list_view.dart';
import 'package:abha/service/lgd_service.dart';
import 'package:intl/intl.dart';

class ProfileEditMobileView extends StatefulWidget {
  final ProfileEditController profileEditController;
  final Function onUpdateClick;
  final bool Function() fieldValidation;
  final Function openCameraGalleryDialog;
  final Future Function(StateEntry stateEntry) onGetDistricts;

  const ProfileEditMobileView({
    required this.profileEditController,
    required this.onUpdateClick,
    required this.fieldValidation,
    required this.openCameraGalleryDialog,
    required this.onGetDistricts,
    super.key,
  });

  @override
  State<ProfileEditMobileView> createState() => _ProfileEditMobileViewState();
}

class _ProfileEditMobileViewState extends State<ProfileEditMobileView> {
  final _formKey = GlobalKey<FormState>();
  late ProfileEditController _profileEditController;
  late ProfileController _profileController;
  late bool _kycDetail;

  Uint8List? image;

  late TextEditingController searchStateController = TextEditingController();
  late TextEditingController searchDistrictController = TextEditingController();
  late FullNameModel fullNameModel;

  PinCodeState pinCodeState = PinCodeState.hide;

  @override
  void initState() {
    _profileController = Get.find<ProfileController>();
    _profileEditController = widget.profileEditController;
    _profileEditController.profileModel = _profileController.profileModel;
    _kycDetail = _profileEditController.kycDetail;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return updateProfileWidget();
  }

  Widget updateProfileWidget() {
    return Stack(
      children: [
        DecoratedBox(
          decoration:
              abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
            topLeft: 0,
            topRight: 0,
            bottomLeft: 0,
            bottomRight: 0,
          ),
          child: Container(height: Dimen.d_250),
        ),
        GetBuilder<ProfileController>(
          builder: (controller) {
            _profileEditController.profileModel = controller.profileModel;
            _profileEditController.mobileNumberTEC.text =
                _profileEditController.profileModel?.mobile ?? '';
            _profileEditController.emailTEC.text =
                _profileEditController.profileModel?.email ?? '';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _profileEditController.autoValidateMode,
                      child: _editFields(),
                    ),
                  ),
                ),
                TextButtonOrange.mobile(
                  text: LocalizationHandler.of().update,
                  onPressed: () {
                    if (!_kycDetail) {
                      fullNameModel = Validator.fetchFullName(
                        _profileEditController.fullNameTEC.text,
                      );
                      _profileEditController.firstNameTEC.text =
                          fullNameModel.firstName.toString();
                      _profileEditController.middleNameTEC.text =
                          fullNameModel.middleName.toString();
                      _profileEditController.lastNameTEC.text =
                          fullNameModel.lastName.toString();
                    }

                    if (!Validator.isNullOrEmpty(
                          _profileEditController.birthDate.date,
                        ) &&
                        !Validator.isNullOrEmpty(
                          _profileEditController.birthDate.month,
                        )) {
                      try {
                        DateFormat format = DateFormat('dd/MM/yyyy');

                        String date =
                            '${_profileEditController.birthDate.date}/${_profileEditController.birthDate.month}/${_profileEditController.birthDate.year}';
                        DateTime dayOfBirthDate = format.parseStrict(
                          date,
                        ); //33.08.2001 - is invalid, 31.13.2001 - is invalid too
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

                    if (_formKey.currentState!.validate()) {
                      widget.onUpdateClick();
                    } else {
                      setState(() {
                        _profileEditController.autoValidateMode =
                            AutovalidateMode.always;
                      });
                    }
                  },
                ).paddingOnly(
                  top: Dimen.d_30,
                  bottom: Dimen.d_35,
                  left: Dimen.d_17,
                  right: Dimen.d_17,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _editFields() {
    // If KYC verified then this field are not editable
    if (_kycDetail) {
      _profileEditController.lastNameTEC.enabled = false;
      _profileEditController.firstNameTEC.enabled = false;
    }
    return Stack(
      children: [
        DecoratedBox(
          decoration:
              abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
            bottomLeft: 0,
            bottomRight: 0,
            color: AppColors.colorWhite,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: WidgetUtility.spreadWidgets(
              [
                //KYC Status
                _widgetKYCStatus(),

                // Abha Address and Abha Number field
                _widgetAbhaNumberAndAddress(),

                // Info Note
                if(!Validator.isNullOrEmpty(_profileController.getNote()))
                InfoNote(
                  note: _profileController.getNote(),
                )
                    .paddingAll(Dimen.d_10)
                    .marginSymmetric(horizontal: Dimen.d_10),

                Column(
                  children: WidgetUtility.spreadWidgets(
                    [
                      // Full Name Field
                      _widgetNameField(),
                      // Gender Field
                      _widgetGenderField(),

                      // Date of birth
                      _widgetSelectDOB(),

                      // Mobile Field
                      _mobileEditableField(),
                      /// Commenting below code as we are allowing user to change mobile number any time
                      // if (_kycDetail ||
                      //     _profileEditController.profileModel?.mobileVerified ==
                      //         false)
                      //   _mobileEditableField()
                      // else
                      //   _fieldsInCaseOfKycVerified(
                      //     LocalizationHandler.of().mobile,
                      //     _profileEditController.profileModel?.mobile ?? '',
                      //   ),


                      // Email Address Field
                      _emailEditableField(),
                      /// Commenting below code as we are allowing user to change mobile number any time
                      // if (_kycDetail ||
                      //     _profileEditController.profileModel?.emailVerified ==
                      //         false)
                      //   _emailEditableField()
                      // else
                      //   _fieldsInCaseOfKycVerified(
                      //     LocalizationHandler.of().emailId,
                      //     _profileEditController.profileModel?.email ?? '',
                      //   ),

                      // Address Field
                      _widgetAddressField(),

                      // State Field
                      _widgetSelectStateField(),

                      // District Field
                      _widgetSelectDistrictField(),

                      // Pin Code Field
                      _widgetPinCodeField()
                    ],
                    interItemSpace: Dimen.d_15,
                    flowHorizontal: false,
                  ),
                ).paddingSymmetric(horizontal: Dimen.d_20)
              ],
              interItemSpace: Dimen.d_15,
              flowHorizontal: false,
            ),
          ).marginOnly(
            top: Dimen.d_30,
          ),
        ).marginOnly(top: Dimen.d_120),

        ///Profile photo
        _widgetProfilePicture()
      ],
    );
  }

  /// Here this widget Shows the Profile Picture and allow to edit the profile
  /// picture.
  Widget _widgetProfilePicture() {
    return Stack(
      children: [
        CustomCircularBorderBackground(
          outerRadius: Dimen.d_75,
          innerRadius: Dimen.d_72,
          image: _profileEditController.image != null
              ? base64Encode(_profileEditController.image!)
              : _profileEditController.profileModel?.profilePhoto,
        ).centerWidget,
        GestureDetector(
          onTap: () {
            widget.openCameraGalleryDialog();
          },
          key: const Key(KeyConstant.circularProfile),
          child: CircleAvatar(
            backgroundColor: AppColors.colorAppBlue,
            radius: Dimen.d_25,
            child: CustomSvgImageView(
              ImageLocalAssets.cameraSvgIcon,
              width: Dimen.d_20,
              height: Dimen.d_20,
            ),
          ),
        ).alignAtTopCenter().marginOnly(left: Dimen.d_130, top: Dimen.d_75),
      ],
    ).marginOnly(top: Dimen.d_40);
  }

  /// Here this widget shows the KYC Status on the basis of KYC boolean value
  Widget _widgetKYCStatus() {
    return Align(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_kycDetail)
                const Icon(
                  IconAssets.checkCircleRounded,
                  color: AppColors.colorGreenDark,
                  size: 15,
                )
              else
                CustomSvgImageView(
                  ImageLocalAssets.selfDeclaredIcon,
                  width: Dimen.d_20,
                  height: Dimen.d_20,
                ).marginOnly(left: Dimen.d_10),
              Text(
                _kycDetail
                    ? LocalizationHandler.of().kycVerified
                    : LocalizationHandler.of().selfdeclared,
                style: CustomTextStyle.labelMedium(context)?.apply(
                  color: AppColors.colorGreyDark7,
                  fontWeightDelta: 1,
                ),
                textAlign: TextAlign.center,
              ).marginOnly(left: Dimen.d_10),
            ],
          ),
        ],
      ),
    ).marginOnly(top: Dimen.d_50);
  }

  /// Here this widget shows the ABHA address and Number Value
  Widget _widgetAbhaNumberAndAddress() {
    if ((_kycDetail)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: WidgetUtility.spreadWidgets(
              [
                Expanded(
                  child: _titleValueOfProfileBasicInfo(
                    context,
                    _profileEditController.profileModel?.abhaNumber ?? '',
                    LocalizationHandler.of().abhaNumber,
                  ).marginOnly(top: Dimen.d_10),
                ),
                Container(
                  color: AppColors.colorGreyLight7,
                  constraints: BoxConstraints(
                    minWidth: Dimen.d_1_5,
                    maxWidth: Dimen.d_1_5,
                    maxHeight: Dimen.d_60,
                    minHeight: Dimen.d_40,
                  ),
                ),
                Expanded(
                  child: _titleValueOfProfileBasicInfo(
                    context,
                    _profileEditController.profileModel?.abhaAddress ?? '',
                    LocalizationHandler.of().abhaAddress,
                  ).marginOnly(top: Dimen.d_10),
                ),
              ],
              interItemSpace: Dimen.d_10,
            ),
          ).paddingSymmetric(horizontal: Dimen.d_16),
          Container(
            height: Dimen.d_1,
            color: AppColors.colorGreyLight7,
            margin: EdgeInsets.only(top: Dimen.d_10),
          )
        ],
      );
    } else {
      return _titleValueOfProfileBasicInfo(
        context,
        _profileEditController.profileModel?.abhaAddress ?? '',
        LocalizationHandler.of().abhaAddress,
      ).centerWidget;
    }
  }

  /// Here this widget shows the Full Name Field
  Widget _widgetNameField() {
    return (_kycDetail)
        ? Column(
            children: [
              _fieldsInCaseOfKycVerified(
                LocalizationHandler.of().fullName,
                _profileEditController.fullNameTEC.text.toString(),
              ),
            ],
          )
        : AppTextFormField.mobile(
            context: context,
            key: const Key(KeyConstant.firstNameHintField),
            title: LocalizationHandler.of().fullName,
            isRequired: true,
            hintText: LocalizationHandler.of().hintEnterYourFullName,
            maxLength: 50,
            textCapitalization: TextCapitalization.words,
            textEditingController: _profileEditController.fullNameTEC,
            validator: (value) {
              if (Validator.isNullOrEmpty(value?.trim())) {
                return LocalizationHandler.of().enterValidFullName;
              }
              if (value!.trim().split(' ').length <= 1) {
                return LocalizationHandler.of().enterValidFullName;
              }
              return null;
            },
          );
  }

  /// Here this widget shows the Gender field
  Widget _widgetGenderField() {
    if ((_kycDetail)) {
      return _fieldsInCaseOfKycVerified(
        LocalizationHandler.of().gender,
        Validator.getGender(_profileEditController.selectedGenderValue),
      );
    } else {
      return DropDownField<String>.mobile(
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
        hint: LocalizationHandler.of().genderHint,
        items: _profileEditController.genders
            .map(
              (item) => DropdownMenuItem<String>(
                value: item['code'],
                child: Text(
                  "${item['name']}",
                  style: InputFieldStyleMobile.inputFieldStyle,
                ),
              ),
            )
            .toList(),
        value: _profileEditController.selectedGenderValue,
        onChanged: _kycDetail
            ? null
            : (value) {
                setState(() {
                  _profileEditController.selectedGenderValue = value as String;
                });
              },
      );
    }
  }

  /// Here this widget shows the DOB field
  Widget _widgetSelectDOB() {
    return (_kycDetail)
        ? _fieldsInCaseOfKycVerified(
            LocalizationHandler.of().birthdate,
            DateTime(
              _profileEditController.birthDate.year ?? 0,
              _profileEditController.birthDate.month ?? 0,
              _profileEditController.birthDate.date ?? 0,
            ).formatDDMMMMYYYY.toString(),
          )
        : DatePicker(
            selectedDate: _profileEditController.birthDate,
            onDateChange: (date) {
              setState(() {
                _profileEditController.birthDate = date!;
              });
            },
            enable: _kycDetail ? false : true,
          );
  }

  /// Here this widget shows the Address field and allow to update
  Widget _widgetAddressField() {
    return AppTextFormField.mobile(
      context: context,
      key: const Key(KeyConstant.addressHintField),
      title: LocalizationHandler.of().titleEnterResidentialAddress,
      isRequired: true,
      hintText: LocalizationHandler.of().hintEnterResidentialAddress,
      textEditingController: _profileEditController.addressTEC,
      maxLines: 4,
      validator: (value) {
        if (Validator.isNullOrEmpty(value?.trim())) {
          return LocalizationHandler.of().enterValidAddress;
        }
        if (!value!.trim().startsWith(RegExp('[a-zA-Z0-9]'))) {
          return LocalizationHandler.of().addressShouldStartsWithCharacter;
        }
        return null;
      },
    );
  }

  /// Here this widget shows the State field and allow to update
  Widget _widgetSelectStateField() {
    return Row(
      children: [
        GetBuilder<ProfileController>(
          builder: (_) {
            return Expanded(
              child: ClickableDropDown<StateEntry>(
                context: context,
                title: LocalizationHandler.of().state,
                isRequired: true,
                key: const Key(KeyConstant.selectStateDrpDwn),
                validator: (value) {
                  if (Validator.isNullOrEmpty(value)) {
                    return LocalizationHandler.of().pleaseSelectState;
                  }
                  return null;
                },
                hint: LocalizationHandler.of().selectstat,
                value: _profileEditController.selectedStateValue,
                decoration: DropDownDecoration().underLineBorderDecoration(
                  context: context,
                  hintText: LocalizationHandler.of().pleaseSelectState,
                ),
                onClick: () {
                  CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
                    isScrollControlled: true,
                    mContext: context,
                    height: context.height * 0.5,
                    child: CustomSearchListView(
                      selectedItem: _profileEditController.selectedStateValue,
                      title: LocalizationHandler.of().pleaseSelectState,
                      hintSearch: LocalizationHandler.of().searchState,
                      itemList: _profileEditController.states,
                      onClick: (item) {
                        setState(() {
                          _profileEditController.selectedStateValue =
                              item as StateEntry;
                          _profileEditController.selectedDistrictValue = null;
                          _profileEditController.districts.clear();
                          updatePinCodeState(
                            pinCode: _profileEditController.pinCodeTEC.text,
                          );
                          widget.onGetDistricts(
                            _profileEditController.selectedStateValue!,
                          );
                        });
                      },
                    ).marginSymmetric(
                      horizontal: Dimen.d_16,
                      vertical: Dimen.d_16,
                    ),
                  );
                },
                onChanged: _kycDetail
                    ? null
                    : (value) {
                        setState(() {
                          _profileEditController.selectedGenderValue =
                              value as String;
                        });
                      },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Here this widget shows the District and allow to update
  Widget _widgetSelectDistrictField() {
    return Row(
      children: [
        GetBuilder<ProfileController>(
          builder: (_) {
            return Expanded(
              child: ClickableDropDown<DistrictEntry>(
                context: context,
                title: LocalizationHandler.of().district,
                isRequired: true,
                key: const Key(KeyConstant.selectDistrictDropDown),
                validator: (value) {
                  if (Validator.isNullOrEmpty(value)) {
                    return LocalizationHandler.of().pleaseSelectDistrict;
                  }
                  return null;
                },
                hint: LocalizationHandler.of().selectdistric,
                value: _profileEditController.selectedDistrictValue,
                decoration: DropDownDecoration().underLineBorderDecoration(
                  context: context,
                  hintText: LocalizationHandler.of().pleaseSelectDistrict,
                ),
                onClick: () {
                  CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
                    isScrollControlled: true,
                    mContext: context,
                    height: context.height * 0.5,
                    child: CustomSearchListView(
                      hintSearch: LocalizationHandler.of().searchDistrict,
                      selectedItem:
                          _profileEditController.selectedDistrictValue,
                      title: LocalizationHandler.of().pleaseSelectDistrict,
                      itemList: _profileEditController.districts,
                      onClick: (item) {
                        setState(() {
                          _profileEditController.selectedDistrictValue =
                              item as DistrictEntry;
                          updatePinCodeState(
                            pinCode: _profileEditController.pinCodeTEC.text,
                          );
                        });
                      },
                    ).marginSymmetric(
                      horizontal: Dimen.d_16,
                      vertical: Dimen.d_16,
                    ),
                  );
                },
                onChanged: _kycDetail
                    ? null
                    : (value) {
                        setState(() {
                          _profileEditController.selectedGenderValue =
                              value as String;
                        });
                      },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Here this widget shows the Pin Code field and allow to update
  Widget _widgetPinCodeField() {
    return AppTextFormField.mobile(
      context: context,
      key: const Key(KeyConstant.pincodField),
      title: LocalizationHandler.of().pinCode,
      textEditingController: _profileEditController.pinCodeTEC,
      hintText: LocalizationHandler.of().enterValidPinCode,
      maxLength: 6,
      isRequired: true,
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
                  if (pinCodeState == PinCodeState.reset) {
                    LGDDetails? details =
                        await _profileController.validatePinCode(
                      _profileEditController.pinCodeTEC.text,
                    );
                    if (details == null) {
                      MessageBar.showToastError(
                        LocalizationHandler.of().pinCodeMatchNotFound,
                      );
                      _profileEditController.pinCodeTEC.clear();
                      setState(() {
                        pinCodeState = PinCodeState.hide;
                      });
                      return;
                    } else if (details.stateCode !=
                            _profileEditController
                                .selectedStateValue?.stateCode ||
                        details.districtCode !=
                            _profileEditController
                                .selectedDistrictValue?.districtCode) {
                      MessageBar.showToastError(
                        LocalizationHandler.of().pinCodeMatchNotFound,
                      );
                      _profileEditController.pinCodeTEC.clear();
                      setState(() {
                        pinCodeState = PinCodeState.hide;
                      });
                      return;
                    } else {
                      setState(() {
                        pinCodeState = PinCodeState.matched;
                      });
                      return;
                    }
                  }
                },
                child: (pinCodeState == PinCodeState.reset)
                    ? Text(
                        LocalizationHandler.of().check,
                        style: InputFieldStyleDesktop.labelTextStyle?.apply(
                          color: InputFieldStyleDesktop.focusedBorderColor,
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
        if (Validator.isNullOrEmpty(value?.trim())) {
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
    );
  }

  Widget _mobileEditableField() {
    return _mobileEmailField(
      title: LocalizationHandler.of().mobile,
      iconWidget:
          const CustomSvgImageView(ImageLocalAssets.shareMobileNoIconSvg),
      value: _profileEditController.mobileNumberTEC.text,
      placeholder: LocalizationHandler.of().errorEnterMobileNumber,
      onClick: () {
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          child: const ProfileMobileUpdateView(),
        );
      },
      key: KeyConstant.mobileTxt,
    );
  }

  Widget _emailEditableField() {
    return _mobileEmailField(
      title: LocalizationHandler.of().emailId,
      iconWidget: CustomSvgImageView(
        ImageLocalAssets.shareEmailIconSvg,
        width: Dimen.d_25,
      ).paddingOnly(right: Dimen.d_5),
      value: _profileEditController.emailTEC.text,
      placeholder: LocalizationHandler.of().errorEnterEmailAddress,
      onClick: () {
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          child: const ProfileEmailUpdateView(),
        );
      },
      key: KeyConstant.emailTxt,
    );
  }

  /// Here is the common Widget for Mobile and Email Fields
  Widget _mobileEmailField({
    required String title,
    required VoidCallback onClick,
    required String key,
    String? value,
    String? placeholder,
    Widget? iconWidget,
  }) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: InputFieldStyleMobile.labelTextStyle,
          ).marginOnly(bottom: Dimen.d_4),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: InputFieldStyleMobile.enableBorderColor,
                  width: InputFieldStyleMobile.borderWidth,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Dimen.d_10,
              horizontal: Dimen.d_0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (iconWidget != null)
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: Dimen.d_20,
                          minWidth: Dimen.d_20,
                        ),
                        child: iconWidget,
                      ).marginOnly(right: Dimen.d_4),
                    Expanded(
                      child: (!Validator.isNullOrEmpty(value))
                          ? Text(
                              value ?? '',
                              key: Key(key),
                              style: InputFieldStyleMobile.inputFieldStyle,
                            )
                          : Text(
                              placeholder ?? '',
                              key: Key(key),
                              style: InputFieldStyleMobile.hintTextStyle,
                            ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget to show in case of KYC verified user.
  /// @params  [title]  String
  /// @params  [value]  String
  Widget _fieldsInCaseOfKycVerified(String title, String value) {
    return Container(
      width: context.width,
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        color: AppColors.colorGreyLight8,
        borderColor: AppColors.colorGreyLight8,
        size: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: InputFieldStyleMobile.labelTextStyle,
          ),
          Text(
            value,
            style: InputFieldStyleMobile.inputFieldStyle,
          ).marginOnly(top: Dimen.d_4),
        ],
      ).paddingAll(Dimen.d_10),
    );
  }

  /// Here is the common widget to arrange the Title and Value [Text]
  Widget _titleValueOfProfileBasicInfo(
    BuildContext context,
    String value,
    String title,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: InputFieldStyleMobile.labelTextStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: InputFieldStyleMobile.inputFieldStyle?.apply(
            color: AppColors.colorGreyDark2,
          ),
          textAlign: TextAlign.center,
        ).marginOnly(top: Dimen.d_3),
      ],
    );
  }

  void updatePinCodeState({required String pinCode}) {
    if (_profileEditController.selectedStateValue != null &&
        _profileEditController.selectedDistrictValue != null) {
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
