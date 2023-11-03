import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/search/custom_search_view.dart';

class DiscoveryLinkingDesktopView extends StatefulWidget {
  final void Function(String) searchHipData;

  const DiscoveryLinkingDesktopView({required this.searchHipData, super.key});

  @override
  DiscoveryLinkingViewState createState() => DiscoveryLinkingViewState();
}

class DiscoveryLinkingViewState extends State<DiscoveryLinkingDesktopView> {
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
          _mainWidget()
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget _mainWidget() {
    return Column(
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
        ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
        GetBuilder<DiscoveryLinkingController>(
          builder: (_) {
            List<ProviderModel> hipDataModelList =
                _discoveryLinkingController.responseHandler.data ?? [];
            hipDataModelList = hipDataModelList.where((element) => element.isHip == true).toList();
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _discoveryLinkingController.isGovtProgramVisible
                          ? LocalizationHandler.of().healthProgramRecords
                          : LocalizationHandler.of().searchMatchingHospital,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorBlack6,
                        fontWeightDelta: 2,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: searchTEC,
                      builder: (context, _) {
                        return (searchTEC.text.isNotEmpty)
                            ? InkWell(
                                onTap: () {
                                  searchTEC.clear();
                                  widget.searchHipData('');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      IconAssets.close,
                                      color: AppColors.colorAppOrange,
                                      size: Dimen.d_18,
                                    ),
                                    Text(
                                      LocalizationHandler.of().clear,
                                      style: CustomTextStyle.bodySmall(context)
                                          ?.apply(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.colorAppOrange,
                                        fontWeightDelta: 2,
                                        fontSizeDelta: -2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    )
                  ],
                ).marginOnly(
                  left: Dimen.d_20,
                  right: Dimen.d_20,
                  top: Dimen.d_16,
                ),
                Divider(
                  color: AppColors.colorGreyWildSand,
                  thickness: Dimen.d_1,
                ).marginSymmetric(horizontal: Dimen.d_20),
                if (Validator.isNullOrEmpty(hipDataModelList))
                  CustomErrorView(
                    status: _discoveryLinkingController.responseHandler.status ?? Status.none,
                    errorMessageTitle: LocalizationHandler.of().noDataAvailable,
                  ).marginOnly(top: Dimen.d_10)
                else
                  GridView.extent(
                    primary: false,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 0.60,
                    mainAxisSpacing: Dimen.d_10,
                    crossAxisSpacing: Dimen.d_10,
                    maxCrossAxisExtent:
                        _discoveryLinkingController.isGovtProgramVisible
                            ? Dimen.d_350
                            : Dimen.d_360,
                    children: List.generate(
                      hipDataModelList.length,
                      (index) {
                        ProviderModel govtProgramModel =
                            hipDataModelList[index];
                        String title = govtProgramModel.identifier.name;
                        String id = govtProgramModel.identifier.id;
                        String imageTitle =
                            _discoveryLinkingController.isGovtProgramVisible
                                ? _discoveryLinkingController.checkImageType(id)
                                : ImageLocalAssets.hospitalPng;
                        return Material(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.circular(Dimen.d_10),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              context
                                  .navigatePush(
                                RoutePath.routeDiscoverHip,
                                arguments: govtProgramModel,
                              )
                                  .then((value) {
                                context.navigateBack(result: value);
                              });
                            },
                            child: DecoratedBox(
                              decoration: abhaSingleton.getBorderDecoration
                                  .getRectangularBorder(
                                borderColor: AppColors.colorPurple4,
                                color: AppColors.colorTransparent,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (_discoveryLinkingController
                                      .isGovtProgramVisible)
                                    CustomImageView(
                                      image: imageTitle,
                                      height: Dimen.d_40,
                                    )
                                  else
                                    Container(
                                      padding: EdgeInsets.all(Dimen.d_20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.colorPurple4,
                                        ),
                                      ),
                                      child: Image.asset(
                                        imageTitle,
                                        height: Dimen.d_45,
                                        color: AppColors.colorAppOrange
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: CustomTextStyle.titleSmall(context)
                                        ?.apply(fontWeightDelta: 0),
                                  ).marginOnly(top: Dimen.d_10),
                                ],
                              ).marginAll(Dimen.d_10),
                            ),
                          ),
                        );
                      },
                    ),
                  ).marginOnly(
                    left: Dimen.d_20,
                    right: Dimen.d_20,
                    top: Dimen.d_16,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
