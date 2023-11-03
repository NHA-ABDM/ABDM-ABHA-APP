import 'package:abha/export_packages.dart';

class ProfileEditController {
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  ProfileModel? profileModel;
  late bool kycDetail;
  List<StateEntry> states = [];
  List<DistrictEntry> districts = [];
  String? selectedGenderValue;
  StateEntry? selectedStateValue;
  DistrictEntry? selectedDistrictValue;

  late AppTextController fullNameTEC,
      firstNameTEC,
      middleNameTEC,
      lastNameTEC,
      addressTEC,
      stateTEC,
      districtTEC,
      pinCodeTEC,
      mobileNumberTEC,
      emailTEC;

  Uint8List? image;
  final ImagePicker picker = ImagePicker();
  //DateTime birthDate = DateTime.now();
  late DateOfBirth birthDate;

  final StateEntry initialStateValue = StateEntry(
    stateCode: 0,
    stateName: 'Select State',
  );
  final DistrictEntry initialDistrictValue = DistrictEntry(
    districtCode: 0,
    districtName: 'Select District',
  );
  final List<Map> genders = [
    {'name': 'Male', 'code': 'M'},
    {'name': 'Female', 'code': 'F'},
    {'name': 'Others', 'code': 'O'},
    //{'name': "I Don't Want To Disclose", 'code': 'U'},
  ];
  late AppTextController searchStateController = AppTextController();
  late AppTextController searchDistrictController = AppTextController();
}
