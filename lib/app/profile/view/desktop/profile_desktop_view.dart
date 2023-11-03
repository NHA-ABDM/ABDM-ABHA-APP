import 'package:abha/app/abha_card/view/desktop/abha_card_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class ProfileDesktopView extends StatefulWidget {
  const ProfileDesktopView({super.key});

  @override
  ProfileDesktopViewState createState() => ProfileDesktopViewState();
}

class ProfileDesktopViewState extends State<ProfileDesktopView> {
  late ProfileController _profileController;
  ProfileModel? _profileModel;
  Uint8List? image;

  @override
  void initState() {
    _profileController = Get.find<ProfileController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getProfileData() {
    _profileModel = _profileController.profileModel;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _profileParentWidget(),
      showBackOption: false,
    );
  }

  Widget _profileParentWidget() {
    return GetBuilder<ProfileController>(
      builder: (_) {
        _getProfileData();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationHandler.of().my_profile.toTitleCase(),
                  style: CustomTextStyle.titleLarge(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
                _editProfileTextWidget(),
              ],
            ).marginOnly(bottom: Dimen.d_20),
            // CommonBackgroundCard(
            //   child: AbhaCardDesktopView(profileModel: _profileModel),
            // ),
            AbhaCardDesktopView(profileModel: _profileModel)
          ],
        ).marginSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_20);
      },
    );
  }

  Widget _editProfileTextWidget() {
    return TextButtonOrangeBorder.desktop(
      leading: ImageLocalAssets.edit,
      text: LocalizationHandler.of().editProfile,
      onPressed: () async {
        context.navigatePush(RoutePath.routeProfileUpdateAddress).then((_) {
          /// update the UI on returning back from next screen with some change
          _profileController.functionHandler(isUpdateUi: true);
        });
      },
    );
  }
}
