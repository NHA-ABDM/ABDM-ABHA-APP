import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_card_widget.dart';
import 'package:abha/app/consents/widget/consent_subscriptions_card_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:flutter/foundation.dart';

class ConsentRequestMobileView extends StatefulWidget {
  const ConsentRequestMobileView({super.key});

  @override
  State<ConsentRequestMobileView> createState() =>
      _ConsentRequestMobileViewState();
}

class _ConsentRequestMobileViewState extends State<ConsentRequestMobileView>
    with TickerProviderStateMixin {
  final List<String> _consentFilter = ['All', 'Requested', 'Denied', 'Expired'];
  late ConsentController _consentController;
  late ScrollController _scrollController;

  String get _selectedFilter => _consentController.requestedFilter;
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
    _tabController = TabController(
      initialIndex: _consentFilter.indexOf(_selectedFilter),
      length: 4,
      vsync: this,
    );
    _scrollController = ScrollController();
    _consentController.requestedConsentMap.clear();
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
    return GetBuilder<ConsentController>(
      builder: (_) {
        return Obx(() {
          bool isInProgress =
              _consentController.isRequestedViewPaginationInProgress[
                      _selectedFilter.allInCaps] ??
                  false;
          return ColoredBox(
            color: AppColors.colorWhite4,
            child: Column(
              children: [
                TabBar(
                  key: const Key(KeyConstant.showTabBar),
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.colorAppBlue1,
                  unselectedLabelColor: AppColors.colorGreyDark8,
                  labelStyle: CustomTextStyle.tabHeader(context),
                  indicatorWeight: Dimen.d_2,
                  indicatorColor: AppColors.colorAppBlue,
                  onTap: (index) {},
                  tabs: [
                    Text(
                      LocalizationHandler.of().all,
                      textAlign: TextAlign.center,
                    ).sizedBox(width: context.width * 0.10),
                    Text(
                      LocalizationHandler.of().requested,
                      textAlign: TextAlign.center,
                    ).sizedBox(width: context.width * 0.18),
                    Text(
                      LocalizationHandler.of().denied,
                      textAlign: TextAlign.center,
                    ).sizedBox(width: context.width * 0.18),
                    Text(
                      LocalizationHandler.of().expired,
                      textAlign: TextAlign.center,
                    ).sizedBox(width: context.width * 0.18)
                  ],
                ).sizedBox(height: Dimen.d_60),
                if (kIsWeb)
                  IndexedStack(
                    index: _tabController.index,
                    children: [
                      allTabView(context),
                      requestedTabView(context),
                      deniedTabView(context),
                      expiredTabView(context),
                    ],
                  )
                else
                  TabBarView(
                    key: const Key(KeyConstant.showTabBarView),
                    controller: _tabController,
                    children: [
                      allTabView(context),
                      requestedTabView(context),
                      deniedTabView(context),
                      expiredTabView(context),
                    ],
                  ).expand(),
                if (isInProgress)
                  const CircularProgressIndicator().paddingSymmetric(
                    vertical: Dimen.d_10,
                    horizontal: Dimen.d_10,
                  )
              ],
            ),
          );
        });
      },
    );
  }

  /// @Here Widget container for [All] tab.
  /// Params used [context] of type BuildContext.
  Widget allTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents: _consentController.requestedConsentMap[ConsentStatus.all] ?? [],
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
      consents:
          _consentController.requestedConsentMap[ConsentStatus.requested] ?? [],
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
      consents:
          _consentController.requestedConsentMap[ConsentStatus.denied] ?? [],
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
      consents:
          _consentController.requestedConsentMap[ConsentStatus.expired] ?? [],
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
    return RefreshIndicator(
      onRefresh: () => _fetchInitialRequestsByFilter(_selectedFilter, true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        padding:
            EdgeInsets.symmetric(horizontal: Dimen.d_18, vertical: Dimen.d_16),
        itemCount: data.length,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: Dimen.d_15);
        },
        itemBuilder: (context, index) {
          if (data[index] is ConsentRequestModel) {
            ConsentRequestModel request = data[index];
            return ConsentCardWidget(
              key: const Key(KeyConstant.showRequestConsentCardView),
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
                    );
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
          } else {
            ConsentSubscriptionRequestModel request = data[index];
            return ConsentSubscriptionCardWidget(
              key: const Key(KeyConstant.showRequestConsentCardView),
              request: request,
              requestType: (isPendingView)
                  ? LocalizationHandler.of().pending
                  : _consentController.getRequestType(request.status ?? ''),
              onClick: (id) async {
                context.navigatePush(
                  RoutePath.routeHealthLocker,
                  arguments: {
                    IntentConstant.data: id,
                    IntentConstant.navigateTo:
                        GlobalEnumNavigationType.healthLockerEditSubscription
                  },
                ).whenComplete(() => _refreshOnBack());
              },
            );
          }
        },
      ),
    );
  }
}
