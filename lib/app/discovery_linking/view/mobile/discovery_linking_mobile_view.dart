import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/search/custom_search_view.dart';
import 'package:flutter/foundation.dart';

class DiscoveryLinkingMobileView extends StatefulWidget {
  final void Function(String) searchHipData;

  const DiscoveryLinkingMobileView({required this.searchHipData, super.key});

  @override
  DiscoveryLinkingMobileViewState createState() =>
      DiscoveryLinkingMobileViewState();
}

class DiscoveryLinkingMobileViewState
    extends State<DiscoveryLinkingMobileView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  final searchTEC = AppTextController();

  @override
  void initState() {
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _searchHipWidget();
  }

  Widget _searchHipWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getElevation(
              color: AppColors.colorWhite,
              borderColor: AppColors.colorWhite,
              isLow: true,
            ),
            child: CustomSearchView(
              appTextController: searchTEC,
              hint: LocalizationHandler.of().searchHospital,
              onChanged: (searchValue) {
                _discoveryLinkingController.deBouncer.call(() async {
                  widget.searchHipData(searchValue);
                });
              },
            ),
          ).marginSymmetric(vertical: Dimen.d_10, horizontal: Dimen.d_20),
          GetBuilder<DiscoveryLinkingController>(
            builder: (_) {
              List<ProviderModel> hipDataModelList =
                  _discoveryLinkingController.responseHandler.data ?? [];
              hipDataModelList = hipDataModelList.where((element) => element.isHip == true).toList();
              return Column(
                children: [
                  Text(
                    _discoveryLinkingController.isGovtProgramVisible
                        ? LocalizationHandler.of().healthProgramRecords
                        : LocalizationHandler.of().searchMatchingHospital,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack6,
                      fontWeightDelta: 2,
                    ),
                  ).paddingAll(Dimen.d_10).centerWidget,
                  if (Validator.isNullOrEmpty(hipDataModelList))
                    CustomErrorView(
                      status: _discoveryLinkingController.responseHandler.status ?? Status.none,
                      errorMessageTitle:
                          LocalizationHandler.of().noDataAvailable,
                    ).marginOnly(top: context.height * 0.3)
                  else
                    GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      mainAxisSpacing: Dimen.d_10,
                      crossAxisSpacing: Dimen.d_10,
                      crossAxisCount: 2,
                      childAspectRatio: kIsWeb ? 1.8 : 1.3,
                      children: List.generate(
                        hipDataModelList.length,
                        (index) {
                          ProviderModel govtProgramModel =
                              hipDataModelList[index];
                          String title = govtProgramModel.identifier.name;
                          String id = govtProgramModel.identifier.id;
                          String imageTitle = _discoveryLinkingController
                                  .isGovtProgramVisible
                              ? _discoveryLinkingController.checkImageType(id)
                              : ImageLocalAssets.hospitalPng;
                          return Card(
                            shape: abhaSingleton.getBorderDecoration
                                .getRectangularShapeBorder(),
                            elevation: 5,
                            child: Material(
                              borderRadius: BorderRadius.circular(Dimen.d_10),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                onTap: () {},
                                child: ListTile(
                                  onTap: () {
                                    context
                                        .navigatePush(
                                      RoutePath.routeDiscoverHip,
                                      arguments: govtProgramModel,
                                    ).then((value) {
                                      context.navigateBack(result: value);
                                    });
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                        image: imageTitle,
                                        height: Dimen.d_60,
                                      ),
                                      Text(
                                        title,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style:
                                            CustomTextStyle.titleSmall(context)
                                                ?.apply(),
                                      ).marginOnly(top: Dimen.d_5),
                                    ],
                                  ),
                                ),
                              ).centerWidget,
                            ),
                          ).paddingAll(Dimen.d_10);
                        },
                      ),
                    ).marginOnly(top: Dimen.d_25),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
