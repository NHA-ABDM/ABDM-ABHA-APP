import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_locker_request_expansion_widget.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';

class ConsentArtefactsDetailsMobileView extends StatefulWidget {
  final Map arguments;

  const ConsentArtefactsDetailsMobileView({required this.arguments, super.key});

  @override
  State<ConsentArtefactsDetailsMobileView> createState() =>
      _ConsentArtefactsDetailsMobileViewState();
}

class _ConsentArtefactsDetailsMobileViewState
    extends State<ConsentArtefactsDetailsMobileView> {
  late ConsentController _consentController;

  List<ConsentArtefactModel?> get artefact =>
      _consentController.consentArtefact;

  SubscriptionRequest? get request => _consentController.subscriptionRequest;

  Subscription? get subscription => _consentController.subscription;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsentController>(
      builder: (_) {
        if (request != null) {
          return SingleChildScrollView(
            child: Column(
              children: WidgetUtility.spreadWidgets(
                [
                  requesterDataInfoView()
                      .marginSymmetric(horizontal: Dimen.d_15),
                  hipProvidersWidget(),
                ],
                interItemSpace: Dimen.d_20,
                flowHorizontal: false,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget requesterDataInfoView() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscription?.requester?.name ?? '',
              style: CustomTextStyle.bodyLarge(context)?.apply(
                color: AppColors.colorBlackLight,
              ),
            ),
            Text(
              subscription?.purpose?.text ?? '',
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark7,
              ),
            ).marginOnly(top: Dimen.d_10),
          ],
        ),
      ],
    );
  }

  Widget basicCheckBoxWidget() {
    return AppCheckBox(
      enable: false,
      value: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      onChanged: (bool? value) {},
      title: Expanded(
        child: RichText(
          text: TextSpan(
            text: '${LocalizationHandler.of().whenNewDataAvailable} ',
            style: CustomTextStyle.bodySmall(context)?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            children: <TextSpan>[
              TextSpan(
                text: subscription?.requester?.name ?? '',
                style: CustomTextStyle.bodySmall(context)?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().automaticallyFetchAndStore}',
                style: CustomTextStyle.bodySmall(context)?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget allProviderWidget() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
        color: AppColors.colorPurple2,
        topLeft: Dimen.d_5,
        topRight: Dimen.d_5,
        bottomLeft: Dimen.d_5,
        bottomRight: Dimen.d_5,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: AppCheckBox(
          enable: false,
          value: true,
          onChanged: (bool? value) {},
          title: Text(
            LocalizationHandler.of().all,
            style: CustomTextStyle.bodyLarge(context)?.copyWith(
              color: AppColors.colorAppBlue,
            ),
          ),
        ),
        trailing: CustomToolTipMessage(
          message: LocalizationHandler.of().automaticallySyncData,
        ).paddingOnly(right: Dimen.d_8),
        children: [
          Column(
            children: [
              recordTypesWidget(),
              typeOfVisitWidget(),
              timePeriodWidget(),
            ],
          )
        ],
      ),
    ).paddingSymmetric(
      horizontal: Dimen.d_20,
    );
  }

  Widget hipProvidersWidget() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        isLow: true,
        color: AppColors.colorWhite,
        borderColor: AppColors.colorWhite,
      ),
      child: Column(
        children: [
          basicCheckBoxWidget(),
          ExpansionTile(
            backgroundColor: AppColors.colorWhite,
            title: Text(
              LocalizationHandler.of().fromProviders,
              style: CustomTextStyle.bodyLarge(context)?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.colorAppBlue,
              ),
            ),
            children: [
              allProviderWidget(),
              DecoratedBox(
                decoration: abhaSingleton.getBorderDecoration
                    .getRectangularCornerBorder(
                  color: AppColors.colorPurple2,
                  topLeft: Dimen.d_5,
                  topRight: Dimen.d_5,
                  bottomLeft: Dimen.d_5,
                  bottomRight: Dimen.d_5,
                ),
                child: Column(
                  children: WidgetUtility.spreadWidgets(
                    _consentController.linksFacilityData.map((link) {
                      return ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        trailing: const SizedBox.shrink(),
                        title: AppCheckBox(
                          enable: false,
                          title: Expanded(
                            child: Text(
                              link?.hip?.name ?? '',
                              maxLines: 3,
                              style:
                                  CustomTextStyle.bodyLarge(context)?.copyWith(
                                color: AppColors.colorAppBlue,
                              ),
                            ),
                          ),
                          value: true,
                        ),
                        children: [
                          Column(
                            children: [
                              recordTypesWidget(),
                              typeOfVisitWidget(),
                              timePeriodWidget(),
                            ],
                          )
                        ],
                      );
                    }).toList(),
                    interItemSpace: Dimen.d_0,
                    flowHorizontal: false,
                  ),
                ),
              ).paddingSymmetric(horizontal: Dimen.d_20)
            ],
          )
        ],
      ),
    )
        .paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_10)
        .paddingAll(Dimen.d_15);
  }

  Widget recordTypesWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().forRecordsOfTypes,
      child: Column(
        children: hiTypesCode.map((e) {
          return Row(
            children: [
              CustomCheckBox(
                iconEnabledWidget: SvgPicture.asset(
                  'assets/images/$e.svg',
                  width: Dimen.d_35,
                ),
                iconDisbledWidget: SvgPicture.asset(
                  'assets/images/${e}_disabled.svg',
                  width: Dimen.d_35,
                ),
                labelWidget: Text(
                  e.convertPascalCaseString,
                  style: CustomTextStyle.bodyLarge(
                    context,
                  )?.copyWith(
                    fontSize: Dimen.d_16,
                    color: AppColors.colorBlack,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: true,
                enable: false,
                onChanged: (value) {},
              ).sizedBox(width: context.width * 0.7),
            ],
          ).marginSymmetric(vertical: Dimen.d_5);
          // );
        }).toList(),
      ),
    );
  }

  Widget typeOfVisitWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().typeOfVisitCareContent,
      child: Column(
        children: visitTypes.map((e) {
          return AppCheckBox(
            enable: false,
            value: true,
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/visitType$e.svg',
                  width: Dimen.d_35,
                ).marginOnly(right: Dimen.d_10),
                Text(
                  e.convertPascalCaseString,
                  style: CustomTextStyle.bodyLarge(context)?.copyWith(
                    fontSize: Dimen.d_16,
                    color: AppColors.colorBlack,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ).marginSymmetric(vertical: Dimen.d_10),
          );
        }).toList(),
      ),
    );
  }

  Widget timePeriodWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().forTimePeriod,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                ImageLocalAssets.calendarFrom,
                width: Dimen.d_35,
              ).marginOnly(right: Dimen.d_10),
              Text('${LocalizationHandler.of().from} : '),
              Text(request?.details?.period?.from?.formatDDMMMMYYYY ?? ''),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                ImageLocalAssets.calendarTo,
                width: Dimen.d_35,
              ).marginOnly(right: Dimen.d_10),
              Text('${LocalizationHandler.of().to} : '),
              Text(request?.details?.period?.to?.formatDDMMMMYYYY ?? ''),
            ],
          ).marginSymmetric(vertical: Dimen.d_20)
        ],
      ),
    );
  }
}
