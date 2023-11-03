import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/widget/steps_mobile_view.dart';
import 'package:abha/export_packages.dart';

class DiscoverHipMobileView extends StatefulWidget {
  final VoidCallback onDiscoveryHip;
  final String name;

  const DiscoverHipMobileView({
    required this.onDiscoveryHip,
    required this.name,
    super.key,
  });

  @override
  DiscoverHipMobileViewState createState() => DiscoverHipMobileViewState();
}

class DiscoverHipMobileViewState extends State<DiscoverHipMobileView> {
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
    return _hipDetailsWidget();
  }

  Widget _hipDetailsWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepsMobileView(
                steps: '1',
                title: LocalizationHandler.of().search_Record,
                bgColor: AppColors.colorAppBlue,
                fgColor: AppColors.colorWhite,
              ),
              StepsMobileView(
                steps: '2',
                title: LocalizationHandler.of().discoverRecord,
              ),
              StepsMobileView(
                steps: '3',
                title: LocalizationHandler.of().otp,
              ),
            ],
          ),
          Card(
            shape:
                abhaSingleton.getBorderDecoration.getRectangularShapeBorder(),
            elevation: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
              ],
            ).paddingAll(Dimen.d_15),
          ).marginOnly(top: Dimen.d_20),
          Text(
            LocalizationHandler.of().shareDataToHealthcareFacility,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(fontWeightDelta: 2, color: AppColors.colorBlack6),
          ).marginOnly(top: Dimen.d_40),
          dataTitleTextWidget(LocalizationHandler.of().mobileNumber)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(_profileModel?.mobile)
              .marginOnly(top: Dimen.d_5),
          dataTitleTextWidget(LocalizationHandler.of().abhaNumber)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(_profileModel?.abhaNumber)
              .marginOnly(top: Dimen.d_5),
          dataTitleTextWidget(LocalizationHandler.of().abhaAddress)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(_profileModel?.abhaAddress)
              .marginOnly(top: Dimen.d_5),
          Text(
            LocalizationHandler.of().patientIdOptional,
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: AppColors.colorGreyDark7,
            ),
          ).marginOnly(top: Dimen.d_40),
          AppTextField(
            textEditingController: _discoveryLinkingController.patientIdTEC,
            onChanged: (searchValue) {
              if (Validator.isNullOrEmpty(searchValue)) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
          ),
          Text(
            LocalizationHandler.of().sharePatientsDetails,
            style: CustomTextStyle.titleSmall(context)?.apply(
              fontWeightDelta: -1,
              color: AppColors.colorGreyDark7,
            ),
          ).marginOnly(top: Dimen.d_40),
          dataTitleTextWidget(LocalizationHandler.of().name)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(_profileModel?.fullName)
              .marginOnly(top: Dimen.d_5),
          dataTitleTextWidget(LocalizationHandler.of().gender)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(
            Validator.getGender(_profileModel?.gender),
          ).marginOnly(top: Dimen.d_5),
          dataTitleTextWidget(LocalizationHandler.of().year_of_birth)
              .marginOnly(top: Dimen.d_30),
          dataSubTitleTextWidget(
            _profileModel?.dateOfBirth?.year.toString(),
          ).marginOnly(top: Dimen.d_5),
          TextButtonOrange.mobile(
            text: LocalizationHandler.of().fetchRecord,
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              widget.onDiscoveryHip();
            },
          ).marginOnly(top: Dimen.d_15, bottom: Dimen.d_15),
        ],
      ),
    );
  }

  Widget dataTitleTextWidget(String dataTitle) {
    return Text(
      dataTitle,
      style: CustomTextStyle.labelMedium(context)?.apply(
        color: AppColors.colorGreyDark1,
        fontWeightDelta: -1,
      ),
    );
  }

  Widget dataSubTitleTextWidget(String? dataSubTitle) {
    return Text(
      dataSubTitle ?? '',
      style: CustomTextStyle.titleSmall(context)
          ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
    );
  }
}
