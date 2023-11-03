import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class HealthLockerListWidget extends StatelessWidget {
  final HealthLockerController healthLockerController;
  final bool isFromDashboard;
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  HealthLockerListWidget({
    required this.healthLockerController,
    super.key,
    this.isFromDashboard = false,
  });

  // Future<void> _onAddLocker(BuildContext context) async {
  //   healthLockerController
  //       .functionHandler(
  //     function: () => healthLockerController.getAddLocker(),
  //     isLoaderReq: true,
  //   )
  //       .whenComplete(() {
  //     LaunchURLServiceImpl().openInAppWebView(
  //       context,
  //       title: LocalizationHandler.of().addNewLocker.toTitleCase(),
  //       url: healthLockerController.responseHandler.data,
  //       scopeType: StringConstants.html,
  //     );
  //     context.navigateBack();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return _getAllLockersListWidget(context);
  }

  /// Onclick of Button opens the list in Bottom Modal sheet
  Widget _getAllLockersListWidget(BuildContext context) {
    return kIsWeb
        ? _lockerDesktopWidget()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFromDashboard)
                Text(
                  LocalizationHandler.of().selectHealthLocker,
                  style: CustomTextStyle.bodySmall(context)
                      ?.apply(fontWeightDelta: 1, color: AppColors.colorBlack3),
                ).marginAll(Dimen.d_30)
              else
                Text(
                  LocalizationHandler.of().titleSelectHealthLocker,
                  style: CustomTextStyle.bodySmall(context)
                      ?.apply(fontWeightDelta: 1, color: AppColors.colorBlack3),
                ).marginOnly(
                  top: Dimen.d_30,
                  left: Dimen.d_30,
                  right: Dimen.d_30,
                ),
              if (isFromDashboard)
                const SizedBox()
              else
                Text(
                  LocalizationHandler.of()
                      .subscriptionRequestRegistrationLocker,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack3,
                    fontWeightDelta: -1,
                    fontSizeDelta: -2,
                  ),
                ).marginOnly(
                  top: Dimen.d_8,
                  left: Dimen.d_30,
                  right: Dimen.d_30,
                  bottom: Dimen.d_15,
                ),
              _lockersMobileWidget(context)
            ],
          );
  }

  // Widget _checkWidgetToOpen(BuildContext context) {
  //   return context.width > 1000
  //       ? _lockerDesktopWidget()
  //       : _lockersMobileWidget();
  // }

  Widget _lockerDesktopWidget() {
    var data = healthLockerController.allLockers;
    List<ProviderModel> tempAllLockers =
        data is List<ProviderModel> ? data : <ProviderModel>[];
    var connectedLockers = healthLockerController.connectedLockers
            ?.map((e) => e.lockerId)
            .toList() ??
        [];
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimen.d_13),
      itemCount: tempAllLockers.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: Dimen.d_8,
        );
      },
      itemBuilder: (context, position) {
        ProviderModel tempServiceLocker = tempAllLockers[position];
        bool isLinked =
            connectedLockers.contains(tempServiceLocker.identifier.id);
        return Material(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(Dimen.d_10),
          clipBehavior: Clip.hardEdge,
          child: DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
              color: AppColors.colorTransparent,
              borderColor:
                  isLinked ? AppColors.colorGrey3 : AppColors.colorPurple4,
            ),
            child: InkWell(
              onTap: () {
                // _onAddLocker(context);
                String? url =
                isFromDashboard
                    ? tempServiceLocker.endpoints?.healthLockerEndpoints
                       ?.firstWhere((element) => element.use == 'data-upload')
                       .address
                    : tempServiceLocker.endpoints?.healthLockerEndpoints
                       ?.firstWhere((element) => element.use == 'registration')
                      .address;
                _launchURLService.openInAppWebView(
                  context,
                  title: tempServiceLocker.identifier.name,
                  url: url,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          tempServiceLocker.identifier.name,
                          textAlign: TextAlign.start,
                          style: CustomTextStyle.bodySmall(context)?.apply(
                            color: AppColors.colorAppBlue,
                            fontSizeDelta: -1,
                          ),
                        ),
                      ),
                      if (isLinked)
                        Expanded(
                          flex: 3,
                          child: Text(
                            isLinked ? LocalizationHandler.of().linked : '',
                            textAlign: TextAlign.end,
                            style: CustomTextStyle.labelMedium(context)
                                ?.apply(color: AppColors.colorAppOrange),
                          ),
                        ),
                    ],
                  ),
                  if (!Validator.isNullOrEmpty(tempServiceLocker.identifier.id))
                    Text(
                      tempServiceLocker.identifier.id,
                      textAlign: TextAlign.start,
                      style: CustomTextStyle.labelMedium(context)?.apply(
                        color: AppColors.colorAppBlue,
                        fontWeightDelta: -1,
                      ),
                    ).marginOnly(top: Dimen.d_5),
                ],
              ).paddingAll(10),
            ).sizedBox(width: context.width * 0.12),
          ),
        );
      },
    );
  }

  Widget _lockersMobileWidget(BuildContext context) {
    var data = healthLockerController.allLockers;
    List<ProviderModel> tempAllLockers =
        data is List<ProviderModel> ? data : <ProviderModel>[];

    var connectedLockers = healthLockerController.connectedLockers
            ?.map((e) => e.lockerId)
            .toList() ??
        [];
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(
        left: Dimen.d_10,
        right: Dimen.d_10,
        top: Dimen.d_10,
        bottom: context.bottomPadding,
      ),
      itemCount: tempAllLockers.length,
      itemBuilder: (context, position) {
        ProviderModel tempServiceLocker = tempAllLockers[position];
        bool isLinked =
            connectedLockers.contains(tempServiceLocker.identifier.id);
        return Card(
          color: AppColors.colorWhite,
          elevation: 2,
          child: InkWell(
            onTap: () {
              // _onAddLocker(context);
              String? url =
              isFromDashboard
                  ? tempServiceLocker.endpoints?.healthLockerEndpoints
                     ?.firstWhere((element) => element.use == 'data-upload')
                     .address
                  : tempServiceLocker.endpoints?.healthLockerEndpoints
                     ?.firstWhere((element) => element.use == 'registration')
                     .address;
              _launchURLService.openInAppWebView(
                context,
                title: tempServiceLocker.identifier.name,
                url: url,
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              tempServiceLocker.identifier.name,
                              textAlign: TextAlign.start,
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                color: AppColors.colorAppBlue,
                                fontSizeDelta: -1,
                              ),
                            ),
                          ),
                          if (isLinked)
                            Expanded(
                              flex: 3,
                              child: Text(
                                isLinked ? LocalizationHandler.of().linked : '',
                                textAlign: TextAlign.end,
                                style: CustomTextStyle.labelMedium(context)
                                    ?.apply(color: AppColors.colorAppOrange),
                              ),
                            ),
                        ],
                      ),
                      if (!Validator.isNullOrEmpty(
                        tempServiceLocker.identifier.id,
                      ))
                        Text(
                          tempServiceLocker.identifier.id,
                          textAlign: TextAlign.start,
                          style: CustomTextStyle.labelMedium(context)?.apply(
                            color: AppColors.colorAppBlue,
                            fontWeightDelta: -1,
                          ),
                        ).marginOnly(top: Dimen.d_5),
                    ],
                  ).paddingAll(Dimen.d_10),
                ),
                Icon(
                  IconAssets.navigateNext,
                  color: AppColors.colorAppBlue,
                  size: Dimen.d_20,
                ).paddingOnly(right: Dimen.d_10)
              ],
            ),
          ),
        );
      },
    ).expand();
  }
}
