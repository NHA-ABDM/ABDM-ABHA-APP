import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_card_widget.dart';
import 'package:abha/app/consents/widget/consent_subscriptions_card_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:flutter/foundation.dart';

class ConsentApprovedMobileView extends StatefulWidget {
  const ConsentApprovedMobileView({super.key});

  @override
  State<ConsentApprovedMobileView> createState() =>
      _ConsentApprovedMobileViewState();
}

class _ConsentApprovedMobileViewState extends State<ConsentApprovedMobileView>
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
    _tabController = TabController(
      initialIndex: _consentFilter.indexOf(_selectedFilter),
      length: 3,
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
    return mainWidget();
  }

  Widget mainWidget() {
    return ColoredBox(
      color: AppColors.colorWhite4,
      child: GetBuilder<ConsentController>(
        builder: (_) {
          return Column(
            children: [
              TabBar(
                key: const Key(KeyConstant.showTabBar),
                controller: _tabController,
                labelColor: AppColors.colorAppBlue,
                unselectedLabelColor: AppColors.colorGreyDark8,
                labelStyle: CustomTextStyle.tabHeader(context),
                indicatorWeight: Dimen.d_2,
                indicatorColor: AppColors.colorAppBlue,
                onTap: (index) {},
                tabs: [
                  Text(
                    LocalizationHandler.of().granted,
                    textAlign: TextAlign.center,
                  ).sizedBox(width: context.width * 0.18),
                  Text(
                    LocalizationHandler.of().expired,
                    textAlign: TextAlign.center,
                  ).sizedBox(width: context.width * 0.18),
                  Text(
                    LocalizationHandler.of().revoked,
                    textAlign: TextAlign.center,
                  ).sizedBox(width: context.width * 0.18),
                ],
              )
                  .sizedBox(height: Dimen.d_60)
                  .paddingSymmetric(horizontal: Dimen.d_10),
              if (kIsWeb)
                IndexedStack(
                  index: _tabController.index,
                  children: [
                    grantedTabView(context),
                    expiredTabView(context),
                    revokedTabView(context),
                  ],
                )
              else
                TabBarView(
                  key: const Key(KeyConstant.showTabBarView),
                  controller: _tabController,
                  children: [
                    grantedTabView(context),
                    expiredTabView(context),
                    revokedTabView(context),
                  ],
                ).expand(),
              Obx(() {
                bool isInProgress =
                    _consentController.isApprovedViewPaginationInProgress[
                            _selectedFilter.allInCaps] ??
                        false;
                return isInProgress
                    ? const CircularProgressIndicator()
                        .paddingSymmetric(
                          vertical: Dimen.d_10,
                          horizontal: Dimen.d_10,
                        )
                        .centerWidget
                    : const SizedBox.shrink();
              })
            ],
          );
        },
      ),
    );
  }

  /// grantedTabView generates and returns a list view containing
  /// Granted consents
  Widget grantedTabView(BuildContext context) {
    List<dynamic> consents = _consentController.getFilteredList(
      consents:
          _consentController.approvedConsentMap[ConsentStatus.granted] ?? [],
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
      consents:
          _consentController.approvedConsentMap[ConsentStatus.revoked] ?? [],
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
      consents:
          _consentController.approvedConsentMap[ConsentStatus.expired] ?? [],
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
  Widget _listView(List<dynamic> data) {
    return RefreshIndicator(
      onRefresh: () => _fetchInitialRequestsByFilter(_selectedFilter, true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: data.length,
        shrinkWrap: true,
        padding:
            EdgeInsets.symmetric(vertical: Dimen.d_15, horizontal: Dimen.d_10),
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
          } else if (data[index] is ConsentSubscriptionRequestModel) {
            ConsentSubscriptionRequestModel request = data[index];
            return ConsentSubscriptionCardWidget(
              key: const Key(KeyConstant.showRequestConsentCardView),
              request: request,
              requestType:
                  _consentController.getRequestType(request.status ?? ''),
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
