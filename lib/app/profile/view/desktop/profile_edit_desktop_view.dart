import 'package:abha/app/profile/controller/profile_edit_controller.dart';
import 'package:abha/app/profile/view/main/profile_edit_view.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/date_picker_view/date_picker.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/dropdown/dropdown_field.dart';
import 'package:abha/service/lgd_service.dart';
import 'package:intl/intl.dart';

class ProfileEditDesktopView extends StatefulWidget {
  final ProfileEditController profileEditController;
  final Function() onUpdateClick;
  final bool Function() fieldValidation;
  final Function() openCameraGalleryDialog;
  final Function(ImageSource source) pickImage;
  final Future Function(StateEntry stateEntry) onGetDistricts;

  const ProfileEditDesktopView({
    required this.profileEditController,
    required this.onUpdateClick,
    required this.fieldValidation,
    required this.openCameraGalleryDialog,
    required this.pickImage,
    required this.onGetDistricts,
    super.key,
  });

  @override
  State<ProfileEditDesktopView> createState() => _ProfileEditDesktopViewState();
}

class _ProfileEditDesktopViewState extends State<ProfileEditDesktopView> {
  final _formKey = GlobalKey<FormState>();
  late ProfileEditController _profileEditController;
  late ProfileController _profileController;
  late bool _kycDetail;
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
    return CustomDrawerDesktopView(
      widget: _updateProfileWidget(),
      showBackOption: false,
    );
  }

  Widget _updateProfileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().editProfile.toTitleCase(),
          style: CustomTextStyle.titleLarge(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 2,
          ),
        ).marginOnly(bottom: Dimen.d_20),
        GetBuilder<ProfileController>(
          builder: (controller) {
            _profileEditController.profileModel = controller.profileModel;
            _profileEditController.mobileNumberTEC.text =
                _profileEditController.profileModel?.mobile ?? '';
            _profileEditController.emailTEC.text =
                _profileEditController.profileModel?.email ?? '';
            return CommonBackgroundCard(
              child: Row(
                children: WidgetUtility.spreadWidgets(
                  [
                    Expanded(
                      flex: 8,
                      child: Form(
                        key: _formKey,
                        child: _profileUpdateFields(),
                      ),
                    ),
                    Flexible(flex: 2, child: _userProfileImage())
                  ],
                  interItemSpace: Dimen.d_30,
                  flowHorizontal: true,
                ),
              ),
            );
          },
        )
      ],
    ).marginAll(Dimen.d_20);
  }

  Widget _userProfileImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: WidgetUtility.spreadWidgets(
        [
          ///Profile photo
          _widgetProfilePicture(),
          Flexible(
            child: InfoNote(
              note: LocalizationHandler.of().uploadMaxSizeImage,
              isCenter: false,
            ),
          ),
        ],
        interItemSpace: Dimen.d_10,
        flowHorizontal: false,
      ),
    );
  }

  /// Here this widget Shows the Profile Picture and allow to edit the profile
  /// picture.
  Widget _widgetProfilePicture() {
    String? image = _profileEditController.image != null
        ? base64Encode(_profileEditController.image!)
        : _profileEditController.profileModel?.profilePhoto;
    return Stack(
      children: [
        Container(
          height: context.height * 0.30,
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorGrey4,
            size: Dimen.d_5,
          ),
          child: _profileEditController.image != null
              ? Image.memory(
                  const Base64Decoder().convert(image ?? ''),
                  height: context.height * 0.30,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
                  .paddingSymmetric(
                    vertical: Dimen.d_15,
                    horizontal: Dimen.d_15,
                  )
                  .centerWidget
              : Image.asset(
                  ImageLocalAssets.account,
                  height: context.height * 0.30,
                )
                  .paddingSymmetric(
                    vertical: Dimen.d_15,
                    horizontal: Dimen.d_15,
                  )
                  .centerWidget,
        ),
        Positioned(
          right: Dimen.d_10,
          bottom: Dimen.d_10,
          child: InkWell(
            onTap: () {
              widget.pickImage(ImageSource.gallery);
            },
            key: const Key(KeyConstant.circularProfile),
            child: CircleAvatar(
              backgroundColor: AppColors.colorAppBlue,
              radius: Dimen.d_20,
              child: CustomSvgImageView(
                ImageLocalAssets.edit,
                color: AppColors.colorWhite,
                height: Dimen.d_12,
                width: Dimen.d_12,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _profileUpdateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: WidgetUtility.spreadWidgets(
        [
          if(!Validator.isNullOrEmpty(_profileController.getNote()))
          /// Info Note
          InfoNote(note: _profileController.getNote()),

          /// for KYC verified profile
          if (_kycDetail)
            Column(
              children: [
                Row(
                  children: [
                    /// Abha number
                    Expanded(
                      flex: 1,
                      child: _abhaNumberField(),
                    ),

                    /// Abha Address Field
                    Expanded(
                      flex: 1,
                      child: _abhaAddressField().marginOnly(left: Dimen.d_16),
                    ),
                    Expanded(
                      flex: 1,
                      child: const SizedBox().marginOnly(left: Dimen.d_16),
                    )
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                Row(
                  children: [
                    Expanded(flex: 1, child: _widgetNameField()),
                    Expanded(
                      flex: 1,
                      child: _widgetGenderField().marginOnly(left: Dimen.d_16),
                    ),
                    Expanded(
                      flex: 1,
                      child: _dateOfBirthField().marginOnly(left: Dimen.d_16),
                    )
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child:
                          _mobileEditableField().marginOnly(right: Dimen.d_16),
                    ),
                    Flexible(child: _emailEditableField())
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                _addressStateWidget(),
              ],
            ),

          if (!_kycDetail)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    /// Abha number
                    Expanded(
                      flex: 1,
                      child: _abhaNumberField(),
                    ),

                    /// Abha Address Field
                    Expanded(
                      flex: 1,
                      child: _abhaAddressField().marginOnly(left: Dimen.d_16),
                    ),

                    // Expanded(child: Container())
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                Row(
                  children: [
                    Expanded(flex: 1, child: _widgetNameField()),
                    Expanded(
                      flex: 1,
                      child: _widgetGenderField().marginOnly(left: Dimen.d_16),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: _fieldsInCaseOfKycVerified(
                    //     LocalizationHandler.of().birthdate,
                    //     DateTime(
                    //       _profileEditController.birthDate.year ?? 0,
                    //       _profileEditController.birthDate.month ?? 0,
                    //       _profileEditController.birthDate.date ?? 0,
                    //     ).formatDDMMMMYYYY.toString(),
                    //   ).marginOnly(left: Dimen.d_16),
                    // )
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _widgetSelectDOB(),
                    ),
                    Expanded(child: Container())
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _emailEditableField(),
                    ),
                    Expanded(
                      child:
                          _mobileEditableField().marginOnly(left: Dimen.d_16),
                    )
                  ],
                ).marginOnly(bottom: Dimen.d_16),
                _addressStateWidget(),
              ],
            ),

          _updateProfileButton(),
        ],
        interItemSpace: Dimen.d_24,
        flowHorizontal: false,
      ),
    );
  }

  Widget _updateProfileButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButtonOrange.desktop(
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
        ).paddingOnly(right: Dimen.d_10),
        TextButtonPurple.desktop(
          text: LocalizationHandler.of().cancel,
          onPressed: () {
            context.navigateBack();
          },
        ).paddingOnly()
      ],
    ).paddingOnly(right: Dimen.d_10, top: Dimen.d_20);
  }

  Widget _addressStateWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _widgetAddressField().marginOnly(bottom: Dimen.d_16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: WidgetUtility.spreadWidgets(
            [
              /// State Field
              Expanded(flex: 2, child: _widgetSelectStateField()),

              /// District Field
              Expanded(flex: 2, child: _widgetSelectDistrictField()),

              /// Pin Code Field
              Expanded(flex: 1, child: _widgetPinCodeField()),
            ],
            interItemSpace: Dimen.d_16,
          ),
        ),
      ],
    );
  }

  /// Here this widget shows the Full Name Field
  Widget _widgetNameField() {
    return (_kycDetail)
        ? _fullNameField()
        : AppTextFormField.desktop(
            context: context,
            key: const Key(KeyConstant.firstNameHintField),
            title: LocalizationHandler.of().fullName,
            isRequired: true,
            hintText: LocalizationHandler.of().hintEnterYourFullName,
            maxLength: 50,
            autoValidateMode: AutovalidateMode.onUserInteraction,
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
    return (_kycDetail)
        ? _genderField()
        : DropDownField<String>.desktop(
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
                      style: InputFieldStyleDesktop.inputFieldStyle,
                    ),
                  ),
                )
                .toList(),
            value: _profileEditController.selectedGenderValue,
            onChanged: _kycDetail
                ? null
                : (value) {
                    setState(() {
                      _profileEditController.selectedGenderValue =
                          value as String;
                    });
                  },
          );
  }

  /// Here this widget shows the DOB field
  Widget _widgetSelectDOB() {
    return DatePicker(
      selectedDate: _profileEditController.birthDate,
      isFromDesktop: true,
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
    return AppTextFormField.desktop(
      context: context,
      key: const Key(KeyConstant.addressHintField),
      title: LocalizationHandler.of().titleEnterResidentialAddress,
      isRequired: true,
      hintText: LocalizationHandler.of().hintEnterResidentialAddress,
      textEditingController: _profileEditController.addressTEC,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 2,
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
          builder: (_) => Flexible(
            fit: FlexFit.loose,
            child: SearchableDropdown<StateEntry>(
              controller: _profileEditController.searchStateController,
              title: LocalizationHandler.of().state,
              isRequired: true,
              value: _profileEditController.selectedStateValue,
              hint: LocalizationHandler.of().pleaseSelectState,
              searchHint: LocalizationHandler.of().searchState,
              validator: (value) {
                if (Validator.isNullOrEmpty(value) ||
                    _profileEditController.states
                        .where(
                          (element) =>
                              element.stateName?.trim().toLowerCase() ==
                              value?.stateName?.trim().toLowerCase(),
                        )
                        .isEmpty) {
                  return LocalizationHandler.of().pleaseSelectState;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _profileEditController.selectedStateValue =
                      value as StateEntry;
                  _profileEditController.districts.clear();
                  _profileEditController.districts
                      .add(_profileEditController.initialDistrictValue);
                  _profileEditController.selectedDistrictValue =
                      _profileEditController.initialDistrictValue;
                  updatePinCodeState(
                    pinCode: _profileEditController.pinCodeTEC.text,
                  );
                  widget
                      .onGetDistricts(
                    _profileEditController.selectedStateValue!,
                  )
                      .then((value) {
                    _profileEditController.selectedDistrictValue = null;
                  });
                });
              },
              items: _profileEditController.states
                  .map(
                    (item) => DropdownMenuItem<StateEntry>(
                      value: item,
                      child: Text(
                        item.title.toTitleCase(),
                        overflow: TextOverflow.ellipsis,
                        style: InputFieldStyleDesktop.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
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
            return Flexible(
              fit: FlexFit.loose,
              child: SearchableDropdown<DistrictEntry>(
                title: LocalizationHandler.of().district,
                isRequired: true,
                controller: _profileEditController.searchDistrictController,
                value: _profileEditController.selectedDistrictValue,
                hint: LocalizationHandler.of().pleaseSelectDistrict,
                searchHint: LocalizationHandler.of().searchDistrict,
                validator: (value) {
                  if (Validator.isNullOrEmpty(value)
                  /// Below option is not require as initially value can be null and it will always return true
                      // || _profileEditController.districts
                      //     .where(
                      //       (element) =>
                      //           element.districtName?.trim().toLowerCase() ==
                      //           value?.districtName?.trim().toLowerCase(),
                      //     )
                      //     .isEmpty
                  ) {
                    return LocalizationHandler.of().pleaseSelectDistrict;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _profileEditController.selectedDistrictValue =
                        value as DistrictEntry;
                    updatePinCodeState(
                      pinCode: _profileEditController.pinCodeTEC.text,
                    );
                  });
                },
                items: _profileEditController.districts
                    .map(
                      (item) => DropdownMenuItem<DistrictEntry>(
                        value: item,
                        child: Text(
                          item.title.toTitleCase(),
                          overflow: TextOverflow.ellipsis,
                          style: InputFieldStyleDesktop.inputFieldStyle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Here this widget shows the Pin Code field and allow to update
  Widget _widgetPinCodeField() {
    return AppTextFormField.desktop(
      context: context,
      key: const Key(KeyConstant.pincodField),
      title: LocalizationHandler.of().pinCode,
      isRequired: true,
      textEditingController: _profileEditController.pinCodeTEC,
      hintText: LocalizationHandler.of().enterValidPinCode,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 6,
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
      context: context,
      enable: true, //_profileEditController.profileModel?.mobileVerified == false || _kycDetail,
      title: LocalizationHandler.of().mobile,
      iconWidget: const CustomSvgImageView(
        ImageLocalAssets.shareMobileNoIconSvg,
      ),
      placeholder: LocalizationHandler.of().errorEnterMobileNumber,
      value: _profileEditController.mobileNumberTEC.text,
      onClick: () {
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          child: const ProfileMobileUpdateView(isDesktopView: true),
          height: Dimen.d_180,
          title: LocalizationHandler.of().updateMobile,
        );
      },
      key: KeyConstant.mobileTxt,
    );
  }

  Widget _emailEditableField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().emailId,
      enable: true,//_profileEditController.profileModel!.emailVerified == false || _kycDetail,
      iconWidget: const CustomSvgImageView(
        ImageLocalAssets.shareEmailIconSvg,
      ),
      placeholder: LocalizationHandler.of().errorEnterEmailAddress,
      value: _profileEditController.emailTEC.text,
      onClick: () {
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          child: const ProfileEmailUpdateView(isDesktopView: true),
          height: Dimen.d_170,
          title: LocalizationHandler.of().updateEmail,
        );
      },
      key: KeyConstant.emailTxt,
    );
  }

  Widget _fullNameField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().fullName,
      enable: false,
      value: _profileController.profileModel?.fullName ?? '-',
      onClick: () {},
      key: KeyConstant.firstNameHintTxt,
    );
  }

  Widget _genderField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().gender,
      enable: false,
      value: Validator.getGender(_profileEditController.selectedGenderValue),
      onClick: () {},
      key: KeyConstant.genderTxt,
    );
  }

  Widget _dateOfBirthField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().dateOfBirth,
      enable: false,
      value: DateTime(
        _profileEditController.birthDate.year ?? 0,
        _profileEditController.birthDate.month ?? 0,
        _profileEditController.birthDate.date ?? 0,
      ).formatDDMMMMYYYY.toString(),
      onClick: () {},
      key: KeyConstant.dateOfBirthText,
    );
  }

  Widget _abhaNumberField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().abhaNumber,
      enable: false,
      value: _profileController.profileModel?.abhaNumber ?? '-',
      onClick: () {},
      key: KeyConstant.abhaNumberTextField,
    );
  }

  Widget _abhaAddressField() {
    return _mobileEmailField(
      context: context,
      title: LocalizationHandler.of().abhaAddress,
      enable: false,
      value: _profileController.profileModel?.abhaAddress ?? '-',
      onClick: () {},
      key: KeyConstant.abhaAddressTextField,
    );
  }

  /// Here is the common Widget for Mobile and Email Fields
  Widget _mobileEmailField({
    required String title,
    required VoidCallback onClick,
    required String key,
    required BuildContext context,
    String? value,
    String? placeholder,
    Widget? iconWidget,
    bool enable = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (enable) {
          onClick();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: InputFieldStyleDesktop.labelTextStyle,
          ).marginOnly(bottom: Dimen.d_4),
          Container(
            decoration: BoxDecoration(
              color: enable ? AppColors.colorWhite : AppColors.colorPurple4,
              border: Border.all(
                color: InputFieldStyleDesktop.enableBorderColor,
                width: InputFieldStyleDesktop.borderWidth,
              ),
              borderRadius: BorderRadius.circular(Dimen.d_4),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Dimen.d_10,
              horizontal: Dimen.d_12,
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
                      ).marginOnly(right: Dimen.d_10)
                    else
                      Container(),
                    Expanded(
                      child: (!Validator.isNullOrEmpty(value))
                          ? Text(
                              value ?? '',
                              key: Key(key),
                              style: InputFieldStyleDesktop.inputFieldStyle,
                            )
                          : Text(
                              placeholder ?? '',
                              key: Key(key),
                              style: InputFieldStyleDesktop.hintTextStyle,
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
  Widget _fieldsInCaseOfKycVerified(
    String title,
    String value, {
    double interItemSpace = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Text(
            title,
            style: InputFieldStyleDesktop.labelTextStyle,
          ),
          if (Validator.isNullOrEmpty(value))
            Text(
              '-',
              style: InputFieldStyleDesktop.inputFieldStyle,
              textAlign: TextAlign.center,
            )
          else
            Text(
              value,
              style: InputFieldStyleDesktop.inputFieldStyle,
            ),
        ],
        interItemSpace: interItemSpace,
        flowHorizontal: false,
      ),
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
