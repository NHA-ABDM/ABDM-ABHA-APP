import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_switch_tab_desktop_widget.dart';
import 'package:abha/app/consents/widget/consent_card_desktop_widget.dart';
import 'package:abha/app/consents/widget/consent_subscriptions_card_desktop_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:flutter/foundation.dart';

class ConsentRequestDesktopView extends StatefulWidget {
  const ConsentRequestDesktopView({super.key});

  @override
  State<ConsentRequestDesktopView> createState() =>
      _ConsentRequestDesktopViewState();
}

class _ConsentRequestDesktopViewState extends State<ConsentRequestDesktopView>
    with TickerProviderStateMixin {
  final List<String> _consentFilter = ['All', 'Requested', 'Denied', 'Expired'];
  late ConsentController _consentController;

  String get _selectedFilter => _consentController.requestedFilter;
  late TabController _tabController;

  @override
  void initState() {
    _init();
    _addTabListener();
    super.initState();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
    _consentController.requestedConsentMap.clear();
    _tabController = TabController(
      initialIndex: _consentFilter.indexOf(_selectedFilter),
      length: 4,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchInitialRequestsByFilter(_selectedFilter, true);
    });
  }

  void _addTabListener() {
    _tabController.addListener(() async {
      if (!_tabController.indexIsChanging) {
        int currentIndex = _tabController.index;
        _consentController.requestedFilter = _consentFilter[currentIndex];
        _consentController.canFetchRequestedConsents = true;
        _consentController.update();
        List<dynamic> list = _consentController.requestedConsentMap[
                _consentController.requestedFilter.allInCaps] ??
            [];
        if (list.isEmpty) {
          await _fetchInitialRequestsByFilter(_selectedFilter, true);
        }
      }
    });
  }

  /// @Here function used to fetch the data related to consent on the basis of
  /// different filters applied on click of tab. Params used [filter] of type String.
  Future<void> _fetchRequestsByFilter(String filter) async {
    await _consentController.functionHandler(
      function: () => _consentController.fetchRequestedConsentData(
        filter: filter.allInCaps,
        shouldResetData: false,
      ),
      isUpdateUi: true,
    );
  }

  /// @Here function used to fetch the data related to consent on the basis of
  /// 'All' filters for initially.
  /// Params used [filter] of type String.
  Future<void> _fetchInitialRequestsByFilter(
    String filter,
    bool resetData,
  ) async {
    _consentController.requestedConsentMap[filter.allInCaps]?.clear();
    _consentController.canFetchRequestedConsents = true;
    await _consentController.functionHandler(
      function: () => _consentController.fetchRequestedConsentData(
        filter: filter.allInCaps,
        shouldResetData: resetData,
      ),
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
      isLoaderReq: true,
    );
  }

  void _refreshOnBack() {
    Future.delayed(const Duration(milliseconds: 60), () {
      _fetchInitialRequestsByFilter(_selectedFilter, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConsentSwitchTabDesktopWidget(
              index: _consentController.selectedTabIndex.value,
              onTabSwitch: (index) {
                _consentController.selectedTabIndex.value = index;
              },
            ),
            TabBar(
              key: const Key(KeyConstant.showTabBar),
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.colorAppBlue1,
              unselectedLabelColor: AppColors.colorGreyDark8,
              labelStyle:
                  CustomTextStyle.titleSmall(context)?.apply(fontSizeDelta: 1),
              indicatorWeight: Dimen.d_2,
              indicatorColor: AppColors.colorAppBlue,
              onTap: (index) {},
              tabs: [
                Text(
                  LocalizationHandler.of().all,
                  textAlign: TextAlign.center,
                ),
                Text(
                  LocalizationHandler.of().requested,
                  textAlign: TextAlign.center,
                ),
                Text(
                  LocalizationHandler.of().denied,
                  textAlign: TextAlign.center,
                ),
                Text(
                  LocalizationHandler.of().expired,
                  textAlign: TextAlign.center,
                )
              ],
            ).sizedBox(height: Dimen.d_50).centerWidget,
          ],
        ),
        Divider(
          color: AppColors.colorGreyWildSand,
          thickness: Dimen.d_1,
        ),
        GetBuilder<ConsentController>(
          builder: (_) {
            return IndexedStack(
              index: _tabController.index,
              children: [
                allTabView(context)
                    .sizedBox(height: _tabController.index == 0 ? null : 1),
                requestedTabView(context)
                    .sizedBox(height: _tabController.index == 1 ? null : 1),
                deniedTabView(context)
                    .sizedBox(height: _tabController.index == 2 ? null : 1),
                expiredTabView(context)
                    .sizedBox(height: _tabController.index == 3 ? null : 1)
              ],
            ).marginOnly(top: Dimen.d_0);
          },
        ),
      ],
    );
  }

  /// @Here Widget container for [All] tab.
  /// Params used [context] of type BuildContext.
  Widget allTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.requestedConsentMap[ConsentStatus.all]
              ?.toSet()
              .toList() ??
          [],
    );

    return (!Validator.isNullOrEmpty(consents))
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// @Here Widget container for [Requested] tab.
  /// Params used [context] of type BuildContext.
  Widget requestedTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.requestedConsentMap[ConsentStatus.requested]
              ?.toSet()
              .toList() ??
          [],
    );
    return (!Validator.isNullOrEmpty(consents))
        ? _listView(consents, isPendingView: true)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// @Here Widget container for [Denied] tab.
  /// Params used [context] of type BuildContext.
  Widget deniedTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.requestedConsentMap[ConsentStatus.denied]
              ?.toSet()
              .toList() ??
          [],
    );
    return (!Validator.isNullOrEmpty(consents))
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// @Here Widget container for [Expired] tab.
  /// Params used [context] of type BuildContext.
  Widget expiredTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.requestedConsentMap[ConsentStatus.expired]
              ?.toSet()
              .toList() ??
          [],
    );
    return (!Validator.isNullOrEmpty(consents))
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// @Here widget listView displays the list of consent.
  /// This same widget is used for different status on the basis of tab clicks.
  /// Params used [data] of type List<dynamic>.
  Widget _listView(List<dynamic> data, {bool isPendingView = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableHeaderView(
          children: [
            Expanded(
              child: getTitleText(
                LocalizationHandler.of().typeOfRequest,
                align: TextAlign.left,
              ),
            ),
            SizedBox(width: Dimen.d_20),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: getTitleText(
                      LocalizationHandler.of().requester,
                      align: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: getTitleText(
                      LocalizationHandler.of().purposeOfRequest,
                      align: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: getTitleText(LocalizationHandler.of().fromDate),
                  ),
                  Expanded(
                    flex: 1,
                    child: getTitleText(LocalizationHandler.of().toDate),
                  ),
                ],
              ),
            ),
            Expanded(
              child: getTitleText(
                LocalizationHandler.of().status,
                align: TextAlign.start,
              ),
            ),
            Expanded(
              child: getTitleText(
                LocalizationHandler.of().last_updated,
                align: TextAlign.start,
              ),
            )
          ],
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              Color backgroundColor = (index % 2 == 0)
                  ? AppColors.colorWhite
                  : AppColors.colorGreyVeryLight;
              if (data[index] is ConsentRequestModel) {
                ConsentRequestModel request = data[index];
                return ConsentCardDesktopWidget(
                  backgroundColor: backgroundColor,
                  key: const Key(KeyConstant.showRequestConsentCardView),
                  isDeskTopView: true,
                  request: request,
                  requestType:
                      _consentController.getRequestType(request.status ?? ''),
                  controller: _consentController,
                  onClick: (id) async {
                    if (request.status == ConsentStatus.granted) {
                      if (kIsWeb) {
                        context.navigatePushNamed(
                          RouteName.consentMine,
                          params: {RouteParam.consentIdParamKey: id ?? ''},
                        ).whenComplete(() => _refreshOnBack());
                      } else {
                        context.navigatePush(
                          RoutePath.routeConsentsMine,
                          arguments: {IntentConstant.data: id},
                        ).whenComplete(() => _refreshOnBack());
                      }
                    } else {
                      context.navigatePush(
                        RoutePath.routeConsentDetails,
                        arguments: {IntentConstant.data: id},
                      ).whenComplete(() => _refreshOnBack());
                    }
                  },
                );
              } else if (data[index] is ConsentSubscriptionRequestModel) {
                ConsentSubscriptionRequestModel request = data[index];
                return ConsentSubscriptionCardDesktopWidget(
                  backgroundColor: backgroundColor,
                  key: const Key(KeyConstant.showRequestConsentCardView),
                  isDesktopView: true,
                  request: request,
                  requestType: (isPendingView)
                      ? LocalizationHandler.of().pending
                      : _consentController.getRequestType(request.status ?? ''),
                  onClick: (id) async {
                    context.navigatePush(
                      RoutePath.routeHealthLocker,
                      arguments: {
                        IntentConstant.data: id,
                        IntentConstant.navigateTo: GlobalEnumNavigationType
                            .healthLockerEditSubscription,
                      },
                    ).whenComplete(() => _refreshOnBack());
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        Obx(() {
          bool isInProgress =
              _consentController.isRequestedViewPaginationInProgress[
                      _selectedFilter.allInCaps] ??
                  false;
          return isInProgress
              ? const CircularProgressIndicator()
                  .paddingSymmetric(
                    vertical: Dimen.d_10,
                    horizontal: Dimen.d_10,
                  )
                  .centerWidget
              : ElevatedButtonBlueBorder.desktop(
                  onPressed: () {
                    _fetchRequestsByFilter(_selectedFilter);
                  },
                  text: LocalizationHandler.of().loadMore,
                ).marginOnly(top: Dimen.d_10);
        })
      ],
    );
  }

  Widget getTitleText(String text, {TextAlign? align}) {
    return Text(
      text,
      maxLines: 2,
      textAlign: align,
      style: CustomTextStyle.bodySmall(
        context,
      )?.apply(color: AppColors.colorWhite),
    );
  }
}
