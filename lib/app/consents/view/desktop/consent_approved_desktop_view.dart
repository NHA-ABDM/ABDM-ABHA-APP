import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_switch_tab_desktop_widget.dart';
import 'package:abha/app/consents/widget/consent_card_desktop_widget.dart';
import 'package:abha/app/consents/widget/consent_subscriptions_card_desktop_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:flutter/foundation.dart';

class ConsentApprovedDesktopView extends StatefulWidget {
  const ConsentApprovedDesktopView({super.key});

  @override
  State<ConsentApprovedDesktopView> createState() =>
      _ConsentApprovedDesktopViewState();
}

class _ConsentApprovedDesktopViewState extends State<ConsentApprovedDesktopView>
    with TickerProviderStateMixin {
  final List<String> _consentFilter = ['Granted', 'Expired', 'Revoked'];
  late ConsentController _consentController;
  late ScrollController _scrollController;

  String get _selectedFilter => _consentController.approvedFilter;
  late TabController _tabController;

  @override
  void initState() {
    _init();
    _addScrollListener();
    _addTabListener();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
    _consentController.approvedConsentMap.clear();
    _tabController = TabController(
      initialIndex: _consentFilter.indexOf(_selectedFilter),
      length: 3,
      vsync: this,
    );
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchInitialRequestsByFilter(_selectedFilter, true);
    });
  }

  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchRequestsByFilter(_selectedFilter);
      }
    });
  }

  void _addTabListener() {
    _tabController.addListener(() async {
      if (!_tabController.indexIsChanging) {
        int currentIndex = _tabController.index;
        setState(() {
          _consentController.approvedFilter = _consentFilter[currentIndex];
          _consentController.canFetchApprovedConsents = true;
        });
        List<dynamic> list = _consentController.approvedConsentMap[
                _consentController.approvedFilter.allInCaps] ??
            [];
        if (list.isEmpty) {
          await _fetchInitialRequestsByFilter(_selectedFilter, true);
        }
      }
    });
  }

  /// _fetchInitialRequestsByFilter() call the fetch consent API
  /// with All/ Granted filter for the first time
  Future<void> _fetchInitialRequestsByFilter(
    String filter,
    bool resetData,
  ) async {
    _consentController.approvedConsentMap[filter.allInCaps]?.clear();
    await _consentController.functionHandler(
      function: () => _consentController.fetchApprovedConsentData(
        filter: filter.allInCaps,
        shouldResetData: resetData,
      ),
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
      isLoaderReq: true,
    );
  }

  /// @Here _fetchRequestsByFilter() call the fetch consent API
  /// with selected tab as a filter string
  Future<void> _fetchRequestsByFilter(String filter) async {
    await _consentController.functionHandler(
      function: () => _consentController.fetchApprovedConsentData(
        filter: filter.allInCaps,
        shouldResetData: false,
      ),
      isUpdateUi: true,
    );
  }

  void _refreshOnBack() {
    Future.delayed(const Duration(milliseconds: 60), () {
      _fetchInitialRequestsByFilter(_selectedFilter, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsentController>(
      builder: (_) {
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
                  labelColor: AppColors.colorAppBlue1,
                  unselectedLabelColor: AppColors.colorGreyDark8,
                  labelStyle: CustomTextStyle.titleSmall(context)
                      ?.apply(fontSizeDelta: 1),
                  indicatorWeight: Dimen.d_2,
                  indicatorColor: AppColors.colorAppBlue,
                  isScrollable: true,
                  onTap: (index) {},
                  tabs: [
                    Text(LocalizationHandler.of().granted),
                    Text(LocalizationHandler.of().expired),
                    Text(LocalizationHandler.of().revoked),
                  ],
                ).sizedBox(height: Dimen.d_50),
              ],
            ),
            Divider(
              color: AppColors.colorGreyWildSand,
              thickness: Dimen.d_1,
            ),
            IndexedStack(
              index: _tabController.index,
              children: [
                grantedTabView(context)
                    .sizedBox(height: _tabController.index == 0 ? null : 1),
                expiredTabView(context)
                    .sizedBox(height: _tabController.index == 1 ? null : 1),
                revokedTabView(context)
                    .sizedBox(height: _tabController.index == 2 ? null : 1),
              ],
            )
          ],
        );
      },
    );
  }

  /// grantedTabView generates and returns a list view containing
  /// Granted consents
  Widget grantedTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.approvedConsentMap[ConsentStatus.granted]
              ?.toSet()
              .toList() ??
          [],
    );
    return (consents.isNotEmpty)
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getApprovedEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// revokedTabView generates and returns a list view containing
  /// Revoked consents
  Widget revokedTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.approvedConsentMap[ConsentStatus.revoked]
              ?.toSet()
              .toList() ??
          [],
    );
    return (consents.isNotEmpty)
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getApprovedEmptyListMessage(_selectedFilter.allInCaps),
            colorTitle: AppColors.colorBlueDark1,
            status: _consentController.responseHandler.status ?? Status.none,
          );
  }

  /// expiredTabView generates and returns a list view containing
  /// Expired consents
  Widget expiredTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.approvedConsentMap[ConsentStatus.expired]
              ?.toSet()
              .toList() ??
          [],
    );
    return (consents.isNotEmpty)
        ? _listView(consents)
        : CustomErrorView(
            image: ImageLocalAssets.emptyConsentSvg,
            infoMessageTitle: _consentController
                .getApprovedEmptyListMessage(_selectedFilter.allInCaps),
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
                  key: Key(
                    '${KeyConstant.showRequestConsentCardView}${request.id}',
                  ),
                  isDeskTopView: true,
                  request: request,
                  requestType: isPendingView
                      ? LocalizationHandler.of().pending
                      : _consentController.getRequestType(request.status ?? ''),
                  controller: _consentController,
                  onClick: (id) async {
                    if (request.status == ConsentStatus.granted) {
                      if (kIsWeb) {
                        await context.navigatePushNamed(
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
      textAlign: align,
      maxLines: 2,
      style: CustomTextStyle.bodySmall(
        context,
      )?.apply(color: AppColors.colorWhite),
    );
  }
}
