import 'dart:io';

import 'package:abha/app/profile/controller/profile_edit_controller.dart';
import 'package:abha/app/profile/view/desktop/profile_edit_desktop_view.dart';
import 'package:abha/app/profile/view/mobile/profile_edit_mobile_view.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

enum PinCodeState { matched, reset, hide }

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  late ProfileController _profileController;
  late ProfileEditController _profileEditController;

  // Uint8List? image;
  late TextEditingController searchStateController = TextEditingController();
  late TextEditingController searchDistrictController = TextEditingController();
  late FullNameModel fullNameModel;

  bool isInitialCall = true;

  @override
  void initState() {
    _profileController = Get.find<ProfileController>();
    _profileEditController = ProfileEditController();
    _profileEditController.profileModel = _profileController.profileModel;
    _profileEditController.kycDetail = _profileController.getKycDetail();
    initData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchGeography();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This method is used to initialize the data for the profile page. It adds an initial state and district value, initializes the text edit controller, sets the birth date, sets the selected gender value, and sets the image.
  void initData() {
    initTextEditController();
    _profileEditController.birthDate = DateOfBirth(
      year: _profileEditController.profileModel?.dateOfBirth!.year,
      month: _profileEditController.profileModel?.dateOfBirth!.month,
      date: _profileEditController.profileModel?.dateOfBirth!.date,
    );

    _profileEditController.selectedGenderValue = _profileEditController.profileModel?.gender;
    _profileEditController.image = Validator.isNullOrEmpty(
      _profileEditController.profileModel?.profilePhoto,
    )
        ? null
        : const Base64Decoder().convert(
            _profileEditController.profileModel?.profilePhoto ?? '',
          );
  }

  /// This method is used to fetch the geography of a user. It fetches the states and districts of the user and sets them in the respective variables.
  /// The state and district values are stored in [StateEntry] and [DistrictEntry] respectively.
  /// The method also calls [_onGetStates] and [_onGetDistricts] to get the states and districts respectively.
  /// Finally, it sets the state of the widget using [setState].
  Future<void> fetchGeography() async {
    _profileEditController.selectedStateValue = StateEntry(
      stateName: _profileEditController.profileModel?.stateName,
      stateCode: int.tryParse(_profileEditController.profileModel?.stateCode ?? '0') ?? 0,
    );
    _profileEditController.selectedDistrictValue = DistrictEntry(
      districtName: _profileEditController.profileModel?.districtName,
      districtCode: int.tryParse(
            _profileEditController.profileModel?.districtCode ?? '0',
          ) ??
          0,
    );

    _profileEditController.states.add(_profileEditController.selectedStateValue!);
    _profileEditController.districts.add(_profileEditController.selectedDistrictValue!);

    await _onGetStates();
    await _onGetDistricts(_profileEditController.selectedStateValue!);
    setState(() {});
  }

  void initTextEditController() {
    _profileEditController.fullNameTEC = AppTextController();
    _profileEditController.fullNameTEC.inputFormatters = Validator.personNameFormatter();
    _profileEditController.firstNameTEC = AppTextController(
      text: _profileEditController.profileModel?.name?.firstName ?? '',
    );
    _profileEditController.firstNameTEC.inputFormatters = Validator.personNameFormatter();

    _profileEditController.lastNameTEC = AppTextController(
      text: _profileEditController.profileModel?.name?.lastName ?? '',
    );
    _profileEditController.lastNameTEC.inputFormatters = Validator.personNameFormatter();

    _profileEditController.middleNameTEC = AppTextController(
      text: _profileEditController.profileModel?.name?.middleName ?? '',
    );
    _profileEditController.middleNameTEC.inputFormatters = Validator.personNameFormatter();

    _profileEditController.addressTEC = AppTextController(
      text: _profileEditController.profileModel?.address ?? '',
    );
    _profileEditController.addressTEC.inputFormatters = Validator.addressFormatter();

    _profileEditController.stateTEC = AppTextController(
      text: _profileEditController.profileModel?.stateName ?? '',
    );
    _profileEditController.searchStateController = AppTextController(
      text: _profileEditController.profileModel?.stateName?.trim().toTitleCase() ?? '',
    );
    _profileEditController.districtTEC = AppTextController(
      text: _profileEditController.profileModel?.districtName ?? '',
    );
    _profileEditController.searchDistrictController = AppTextController(
      text: _profileEditController.profileModel?.districtName?.trim().toTitleCase() ?? '',
    );
    _profileEditController.pinCodeTEC = AppTextController(
      text: _profileEditController.profileModel?.pinCode ?? '',
    );
    _profileEditController.pinCodeTEC.inputFormatters = Validator.numberFormatter();
    _profileEditController.mobileNumberTEC = AppTextController(
      text: _profileEditController.profileModel?.mobile ?? '',
    );
    _profileEditController.mobileNumberTEC.inputFormatters = Validator.numberFormatter();
    _profileEditController.emailTEC = AppTextController(
      text: _profileEditController.profileModel?.email ?? '',
    );

    if (!Validator.isNullOrEmpty(_profileEditController.middleNameTEC.text)) {
      _profileEditController.fullNameTEC.text = '${_profileEditController.firstNameTEC.text} ${_profileEditController.middleNameTEC.text} '
          '${_profileEditController.lastNameTEC.text}';
    } else {
      _profileEditController.fullNameTEC.text = '${_profileEditController.firstNameTEC.text} '
          '${_profileEditController.lastNameTEC.text}';
    }
  }

  /// This method is used to get the list of states from the server and store them in a local array.
  ///
  /// The [_profileController] is used to call the [getStates] function and set the [isLoaderReq] parameter to true.
  /// If the response status is successful, then a local array is created and each element of the data is added as an entry.
  /// Finally, the state of the widget is updated with this local array.
  Future<void> _onGetStates() async {
    await _profileController.functionHandler(
      function: () => _profileController.getStates(context: context),
      isLoaderReq: true,
    );
    if (_profileController.responseHandler.status == Status.success) {
      List data = _profileController.responseHandler.data;
      if (!Validator.isNullOrEmpty(data)) {
        List<StateEntry> localArr = [];
        for (var i = 0; i < data.length; i++) {
          localArr.add(StateEntry.fromMap(data[i]));
        }
        localArr.sort((a, b) => a.title.compareTo(b.title));
        setState(() {
          _profileEditController.states = localArr;
        });
      }
    }
  }

  /// This method is used to get the list of districts from the server for a particular state.
  ///
  /// It takes [StateEntry] object as an argument and sets the list of districts in the state using [setState].
  ///
  /// The response is handled by [_profileController.responseHandler] and if successful, it creates a list of [DistrictEntry] objects and sets it in the state using [setState].
  Future<void> _onGetDistricts(StateEntry state) async {
    await _profileController.functionHandler(
      function: () => _profileController.getDistricts(state.stateCode.toString(), context: context),
      isLoaderReq: true,
    );
    if (_profileController.responseHandler.status == Status.success) {
      List data = _profileController.responseHandler.data;
      if (!Validator.isNullOrEmpty(data)) {
        List<DistrictEntry> localArr = [];
        for (var i = 0; i < data.length; i++) {
          localArr.add(DistrictEntry.fromMap(data[i]));
        }
        localArr.sort((a, b) => a.title.compareTo(b.title));
        if (isInitialCall && !localArr.contains(_profileEditController.selectedDistrictValue)) {
          _profileEditController.selectedDistrictValue = null;
        } else if (isInitialCall) {
          DistrictEntry districtEntry = localArr.firstWhere((element) => element.districtCode == int.tryParse(_profileController.profileModel?.districtCode ?? ''));
          _profileEditController.districtTEC.text = districtEntry.title;
          _profileEditController.selectedDistrictValue = districtEntry;
        }
        setState(() {
          _profileEditController.districts = localArr;
          isInitialCall = false;
        });
      }
    }
  }

  Future<void> onUpdateClick() async {
    ProfileModel model = generateUpdateModel();
    await _profileController
        .functionHandler(
      function: () => _profileController.updateUserProfile(model),
      isLoaderReq: true,
      isUpdateUi: true,
      successMessage: LocalizationHandler.of().profileUpdateSuccess,
    )
        .then((value) {
      if (_profileController.responseHandler.status == Status.success) {
        // if (!kIsWeb) {
          context.navigateBack();
        // }
      }
    });
  }

  ProfileModel generateUpdateModel() {
    return ProfileModel(
      abhaAddress: _profileEditController.profileModel?.abhaAddress,
      abhaNumber: _profileEditController.profileModel?.abhaNumber,
      name: Name(
        firstName: _profileEditController.firstNameTEC.text,
        middleName: _profileEditController.middleNameTEC.text,
        lastName: _profileEditController.lastNameTEC.text,
      ),
      dateOfBirth: DateOfBirth(
        date: _profileEditController.birthDate.date,
        month: _profileEditController.birthDate.month,
        year: _profileEditController.birthDate.year,
      ),
      gender: _profileEditController.selectedGenderValue,
      stateName: _profileEditController.selectedStateValue?.stateName,
      stateCode: _profileEditController.selectedStateValue?.stateCode.toString(),
      districtName: _profileEditController.selectedDistrictValue?.districtName,
      districtCode: _profileEditController.selectedDistrictValue?.districtCode.toString(),
      pinCode: _profileEditController.pinCodeTEC.text,
      address: _profileEditController.addressTEC.text.trim(),
      profilePhoto: _profileEditController.image != null ? base64Encode(_profileEditController.image!) : _profileEditController.profileModel?.profilePhoto,
    );
  }

  bool fieldValidation() {
    return Validator.isNullOrEmpty(_profileEditController.fullNameTEC.text) ||
        Validator.isNullOrEmpty(_profileEditController.birthDate) ||
        Validator.isNullOrEmpty(_profileEditController.selectedGenderValue) ||
        Validator.isNullOrEmpty(_profileEditController.selectedStateValue) ||
        Validator.isNullOrEmpty(_profileEditController.selectedDistrictValue) ||
        Validator.isNullOrEmpty(_profileEditController.pinCodeTEC.text) ||
        Validator.isNullOrEmpty(_profileEditController.addressTEC.text);
  }

  /// @Here function opens dialog to select either [Gallery] or [Camera] option
  /// to set profile picture
  void openCameraGalleryDialog() {
    CustomDialog.showPopupDialog(
      LocalizationHandler.of().uploadProfileImage,
      title: LocalizationHandler.of().profileImage,
      showCloseButton: true,
      onNegativeButtonPressed: () async {
        pickImage(ImageSource.gallery);
      },
      onPositiveButtonPressed: kIsWeb
          ? null
          : () async {
              pickImage(ImageSource.camera);
            },
      positiveButtonTitle: LocalizationHandler.of().camera,
      negativeButtonTitle: LocalizationHandler.of().gallery,
    );
  }

  /// @Here function used to pick the Image from Gallery
  /// or catch the picture from camera
  /// param  [source]  ImageSource
  Future<void> pickImage(ImageSource source) async {
    if (!kIsWeb) {
    context.navigateBack();
    }
    bool imageAccepted;
    bool imageSize;
    final XFile? pickedFile = await _profileEditController.picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    abhaLog.i(pickedFile?.mimeType ?? '');
    abhaLog.i(pickedFile?.path ?? '');
    imageSize = _profileController.isImageSizeValid(await pickedFile?.length() ?? 0);

    ///For Web
    if (kIsWeb) {
      if (!Validator.isNullOrEmpty(pickedFile?.mimeType)) {
        imageAccepted = _profileController.isImagePathValid(pickedFile?.mimeType ?? '');
        if (!imageAccepted) {
          MessageBar.showToastDialog(
            LocalizationHandler.of().imageFileNotSupported,
          );
        } else if (!imageSize) {
          MessageBar.showToastDialog(
            LocalizationHandler.of().imageFileSizeError,
          );
        } else {
          var pickedFileForWeb = await pickedFile?.readAsBytes();
          _profileEditController.image = pickedFileForWeb;
        }
      }
    } else {
      /// For Mobile
      if (!Validator.isNullOrEmpty(pickedFile?.path)) {
        imageAccepted = _profileController.isImagePathValid(pickedFile?.path ?? '');
        if (!imageAccepted) {
          MessageBar.showToastDialog(
            LocalizationHandler.of().imageFileNotSupported,
          );
        } else if (!imageSize) {
          MessageBar.showToastDialog(
            LocalizationHandler.of().imageFileSizeError,
          );
        } else {
          File file = File(pickedFile?.path ?? '');
          _profileEditController.image = file.readAsBytesSync();
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BaseView(
        title: LocalizationHandler.of().editProfile,
        type: ProfileEditView,
        bodyMobile: ProfileEditMobileView(
          profileEditController: _profileEditController,
          onUpdateClick: onUpdateClick,
          fieldValidation: fieldValidation,
          openCameraGalleryDialog: openCameraGalleryDialog,
          onGetDistricts: _onGetDistricts,
        ),
        bodyDesktop: ProfileEditDesktopView(
          profileEditController: _profileEditController,
          onUpdateClick: onUpdateClick,
          fieldValidation: fieldValidation,
          openCameraGalleryDialog: openCameraGalleryDialog,
          pickImage: pickImage,
          onGetDistricts: _onGetDistricts,
        ),
        paddingValueMobile: 0,
        mobileBackgroundColor: AppColors.colorWhite,
        isDarkTabBar: true,
        height: 0.30,
      ),
    );
  }
}
