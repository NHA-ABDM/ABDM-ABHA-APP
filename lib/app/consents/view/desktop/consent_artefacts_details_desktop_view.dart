import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_locker_request_expansion_widget.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class ConsentArtefactsDetailsDesktopView extends StatefulWidget {
  final Map arguments;

  const ConsentArtefactsDetailsDesktopView({
    required this.arguments,
    super.key,
  });

  @override
  State<ConsentArtefactsDetailsDesktopView> createState() =>
      _ConsentArtefactsDetailsDesktopViewState();
}

class _ConsentArtefactsDetailsDesktopViewState
    extends State<ConsentArtefactsDetailsDesktopView> {
  late ConsentController _consentController;

  List<ConsentArtefactModel?> get artefact =>
      _consentController.consentArtefact;

  SubscriptionRequest? get request => _consentController.subscriptionRequest;

  Subscription? get subscription => _consentController.subscription;

  LinkFacilityLinkedData? selectedFacility;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: GetBuilder<ConsentController>(
        builder: (_) {
          if (request != null) {
            return SingleChildScrollView(
              child: Column(
                children: WidgetUtility.spreadWidgets(
                  [
                    requesterDataInfoView(),
                    basicCheckBoxWidget(),
                    hipProvidersWidget(),
                  ],
                  interItemSpace: Dimen.d_20,
                  flowHorizontal: false,
                ),
              ).paddingOnly(
                left: Dimen.d_32,
                right: Dimen.d_16,
                top: Dimen.d_16,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
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
              style: CustomTextStyle.bodyLarge(context)
                  ?.apply(color: AppColors.colorBlackLight),
            ),
            Text(
              subscription?.purpose?.text ?? '',
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorGreyDark7),
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
      onChanged: (bool? value) {},
      title: Expanded(
        child: RichText(
          text: TextSpan(
            text: '${LocalizationHandler.of().whenNewDataAvailable} ',
            style: CustomTextStyle.bodySmall(context)
                ?.copyWith(fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: subscription?.requester?.name ?? '',
                style: CustomTextStyle.bodySmall(context)
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().automaticallyFetchAndStore}',
                style: CustomTextStyle.bodySmall(context)
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget hipProvidersWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFacility =
                          LinkFacilityLinkedData(referenceNumber: '0');
                    });
                  },
                  child: DecoratedBox(
                    decoration:
                        abhaSingleton.getBorderDecoration.getRectangularBorder(
                      borderColor: (selectedFacility?.referenceNumber == '0')
                          ? AppColors.colorWhite
                          : AppColors.colorAppBlue,
                      color: (selectedFacility?.referenceNumber == '0')
                          ? AppColors.colorBlueLight4.withOpacity(0.5)
                          : AppColors.colorWhite,
                    ),
                    child: Row(
                      children: [
                        Text(
                          LocalizationHandler.of().all,
                          style: CustomTextStyle.bodyLarge(context)?.copyWith(
                            fontSize: Dimen.d_16,
                            color: AppColors.colorBlack,
                          ),
                        )
                      ],
                    ),
                  ).paddingAll(Dimen.d_10),
                ).marginOnly(bottom: Dimen.d_16),
                Column(
                  children: _consentController.linksFacilityData.map((link) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFacility = link;
                        });
                      },
                      child: DecoratedBox(
                        decoration: abhaSingleton.getBorderDecoration
                            .getRectangularBorder(
                          borderColor:
                              (selectedFacility?.hip?.id == link?.hip?.id)
                                  ? AppColors.colorWhite
                                  : AppColors.colorAppBlue,
                          color: (selectedFacility?.hip?.id == link?.hip?.id)
                              ? AppColors.colorBlueLight4.withOpacity(0.5)
                              : AppColors.colorWhite,
                        ),
                        child: Row(
                          children: [
                            Text(
                              link?.hip?.name ?? '',
                              style:
                                  CustomTextStyle.bodyLarge(context)?.copyWith(
                                fontSize: Dimen.d_16,
                                color: AppColors.colorBlack,
                              ),
                            )
                          ],
                        ),
                      ).paddingAll(Dimen.d_10),
                    ).marginOnly(bottom: Dimen.d_16);
                  }).toList(),
                )
              ],
            ).paddingSymmetric(vertical: Dimen.d_16),
          ),
          VerticalDivider(
            thickness: Dimen.d_1,
            color: AppColors.colorGrey1,
          ).sizedBox(height: context.height),
          Flexible(
            flex: 6,
            child: (selectedFacility != null)
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Card(
                      key: ValueKey<LinkFacilityLinkedData?>(selectedFacility),
                      shape: abhaSingleton.getBorderDecoration
                          .getRectangularShapeBorder(),
                      elevation: Dimen.d_5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            recordTypesWidget(),
                            typeOfVisitWidget(),
                            timePeriodWidget()
                          ],
                        ),
                      ).paddingSymmetric(
                        vertical: Dimen.d_20,
                        horizontal: Dimen.d_20,
                      ),
                    ).marginSymmetric(
                      vertical: Dimen.d_20,
                      horizontal: Dimen.d_20,
                    ),
                  )
                : const Text('Please select facility to View details'),
          )
        ],
        interItemSpace: Dimen.d_16,
      ),
    );
  }

  Widget recordTypesWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().forRecordsOfTypes,
      showArrow: true,
      expanded: true,
      child: Wrap(
        spacing: Dimen.d_12,
        runSpacing: Dimen.d_12,
        children: hiTypesCode.map((e) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCheckBox(
                iconEnabledWidget: CustomSvgImageView(
                  'assets/images/$e.svg',
                  width: Dimen.d_35,
                ),
                iconDisbledWidget: CustomSvgImageView(
                  'assets/images/${e}_disabled.svg',
                  width: Dimen.d_35,
                ),
                labelWidget: Text(
                  e.convertPascalCaseString,
                  style: CustomTextStyle.bodyLarge(context)?.copyWith(
                    fontSize: Dimen.d_16,
                    color: AppColors.colorBlack,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: true,
                enable: false,
                onChanged: (value) {},
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget typeOfVisitWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().typeOfVisitCareContent,
      showArrow: true,
      expanded: true,
      child: Row(
        children: visitTypes.map((e) {
          return AppCheckBox(
            enable: false,
            value: true,
            title: Row(
              children: [
                CustomSvgImageView(
                  'assets/images/visitType$e.svg',
                  width: Dimen.d_35,
                ).marginOnly(right: Dimen.d_0),
                Text(
                  e.convertPascalCaseString,
                  style: CustomTextStyle.bodyLarge(
                    context,
                  )?.copyWith(
                    fontSize: Dimen.d_16,
                    color: AppColors.colorBlack,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ).marginSymmetric(vertical: Dimen.d_10, horizontal: Dimen.d_10),
          );
        }).toList(),
      ),
    );
  }

  Widget timePeriodWidget() {
    return ConsentLockerRequestExpansionWidget(
      title: LocalizationHandler.of().forTimePeriod,
      showArrow: true,
      expanded: true,
      child: Column(
        children: [
          Row(
            children: [
              CustomSvgImageView(
                ImageLocalAssets.calendarFrom,
                width: Dimen.d_35,
              ).marginOnly(right: Dimen.d_10),
              Text('${LocalizationHandler.of().from} : '),
              Text(request?.details?.period?.from?.formatDDMMMMYYYY ?? ''),
            ],
          ),
          Row(
            children: [
              CustomSvgImageView(
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
