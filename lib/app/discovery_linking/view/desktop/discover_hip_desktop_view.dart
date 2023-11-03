import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/widget/steps_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class DiscoverHipDesktopView extends StatefulWidget {
  final VoidCallback onDiscoveryHip;
  final String name;

  const DiscoverHipDesktopView({
    required this.onDiscoveryHip,
    required this.name,
    super.key,
  });

  @override
  DiscoverHipViewState createState() => DiscoverHipViewState();
}

class DiscoverHipViewState extends State<DiscoverHipDesktopView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  ProfileModel? _profileModel;

  @override
  void initState() {
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    _profileModel = Get.find<ProfileController>().profileModel;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().linkNewFacility.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StepsDesktopView(
                  steps: '1',
                  title: LocalizationHandler.of().search_Record,
                  bgColor: AppColors.colorAppBlue,
                  fgColor: AppColors.colorWhite,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  steps: '2',
                  title: LocalizationHandler.of().discoverRecord,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  steps: '3',
                  title: LocalizationHandler.of().otpVerification,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          CommonBackgroundCard(child: _hipDetailsWidget())
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget _hipDetailsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSvgImageView(
              ImageLocalAssets.hospital,
              width: Dimen.d_23,
              height: Dimen.d_16,
            ).marginOnly(right: Dimen.d_10),
            Text(
              widget.name,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ),
          ],
        ),
        Text(
          LocalizationHandler.of().shareDataToHealthcareFacility,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorBlack6),
        ).marginOnly(top: Dimen.d_20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().name,
                _profileModel?.fullName,
              ),
            ),
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().gender,
                _profileModel?.gender,
              ),
            ),
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().year_of_birth,
                _profileModel?.dateOfBirth?.year.toString(),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        ).marginOnly(top: Dimen.d_30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().mobileNumber,
                _profileModel?.mobile,
              ),
            ),
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().abhaNumber,
                _profileModel?.abhaNumber,
              ),
            ),
            Expanded(
              flex: 1,
              child: _showDataWidget(
                LocalizationHandler.of().abhaAddress,
                _profileModel?.abhaAddress,
              ),
            ),
            const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        ).marginOnly(top: Dimen.d_25),
        AppTextField(
          title: LocalizationHandler.of().patientIdOptional,
          decoration: AppTextFormDecoration().getDefaultDecoration(
            context: context,
            hintText: LocalizationHandler.of().patientIdOptional,
            prefixIcon:
                const Icon(IconAssets.search, color: AppColors.colorAppOrange),
            borderRadius: Dimen.d_8,
            borderColor: AppColors.colorGreyLight6,
            contentPaddingVertical: Dimen.d_1,
          ),
          textEditingController: _discoveryLinkingController.patientIdTEC,
          onChanged: (searchValue) {
            if (Validator.isNullOrEmpty(searchValue)) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
        ).sizedBox(width: context.width / 3).marginOnly(top: Dimen.d_25),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().fetchRecord,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.onDiscoveryHip();
          },
        ).marginOnly(top: Dimen.d_25),
      ],
    );
  }

  Widget _showDataWidget(String dataTitle, String? dataSubTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dataTitle,
          style: CustomTextStyle.labelLarge(context)?.apply(
            color: AppColors.colorGreyDark5,
            fontSizeDelta: -1,
            fontWeightDelta: -1,
            // fontSizeDelta: 1,
          ),
        ),
        Text(
          dataSubTitle ?? '',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack,
            fontWeightDelta: -1,
          ),
        ).marginOnly(top: Dimen.d_5)
      ],
    );
  }
}
