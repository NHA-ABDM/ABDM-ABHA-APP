import 'package:abha/app/profile/view/desktop/profile_desktop_view.dart';
import 'package:abha/app/profile/view/mobile/profile_mobile_view.dart';
import 'package:abha/export_packages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  late ProfileController _profileController;
  Uint8List? image;
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
    _profileController = Get.find<ProfileController>();
    // if (Validator.isNullOrEmpty(_profileController.profileModel)) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onFetchMyProfile());
    // }
  }

  Future<void> _onFetchMyProfile() async {
    await _profileController.functionHandler(
      function: () => _profileController.getProfileFetch(),
      isUpdateUi: true,
      isLoaderReq: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().my_profile,
      type: ProfileView,
      bodyMobile: const ProfileMobileView(),
      bodyDesktop: const ProfileDesktopView(),
      mobileBackgroundColor: AppColors.colorWhite4,
      webBackgroundColor: AppColors.colorWhite4,
    );
  }
}
