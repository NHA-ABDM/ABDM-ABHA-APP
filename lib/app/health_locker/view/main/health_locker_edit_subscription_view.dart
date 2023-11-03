import 'package:abha/app/health_locker/view/desktop/health_locker_edit_subscription_desktop_view.dart';
import 'package:abha/app/health_locker/view/mobile/health_locker_edit_subscription_mobile_view.dart';
import 'package:abha/export_packages.dart';

class HealthLockerEditSubscriptionView extends StatefulWidget {
  final Map arguments;

  const HealthLockerEditSubscriptionView({required this.arguments, super.key});

  @override
  HealthLockerEditSubscriptionViewState createState() =>
      HealthLockerEditSubscriptionViewState();
}

class HealthLockerEditSubscriptionViewState
    extends State<HealthLockerEditSubscriptionView> {
  late HealthLockerController _healthLockerController;
  late String subscriptionId;
  String? hipName;
  String? fromDate, toDate;
  String? hipID;
  bool isChkBoxClicked = false;

  @override
  void initState() {
    super.initState();
    _healthLockerController = Get.find<HealthLockerController>();
    subscriptionId = widget.arguments[IntentConstant.subscriptionID];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!Validator.isNullOrEmpty(subscriptionId)) {
        await fetchLinkedFacility();
        fetchSubscriptionDetails();
        setState(() {});
      }
    });
  }

  Future<void> fetchLinkedFacility() async {
    await _healthLockerController.functionHandler(
      function: () => _healthLockerController.fetchLinkedFacility(),
      isLoaderReq: true,
      isUpdateUi: true,
      updateUiBuilderIds: [UpdateLockerBuilderIds.subscriptionRequest],
    );
  }

  Future<void> fetchSubscriptionDetails() async {
    await _healthLockerController.functionHandler(
      function: () =>
          _healthLockerController.getSubscriptionRequestDetail(subscriptionId),
      isLoaderReq: true,
      isUpdateUi: true,
      updateUiBuilderIds: [UpdateLockerBuilderIds.subscriptionRequest],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: HealthLockerEditSubscriptionView,
      isTopSafeArea: true,
      title: LocalizationHandler.of().editsubscription,
      bodyMobile: HealthLockerEditSubscriptionMobileView(
        arguments: widget.arguments,
        onSubmitClick: onSubmitClick,
      ),
      bodyDesktop: HealthLockerEditSubscriptionDesktopView(
        arguments: widget.arguments,
        onSubmitClick: onSubmitClick,
      ),
    );
  }

  void onSubmitClick() {
    _healthLockerController.removeUnSelectedItemFromModel();

    if (_healthLockerController.listHipName.contains('All')) {
      _healthLockerController
          .subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
          ?.forEach((element) {
        element.hip = null;
      });
      apiCallToUpdateSubscriptDetail(true);
    } else {
      apiCallToUpdateSubscriptDetail(false);
    }
  }

  Future<void> apiCallToUpdateSubscriptDetail(
    bool isApplicableForAllHIPs,
  ) async {
    _healthLockerController.subscriptionModel.hiuId =
        _healthLockerController.subscription?.requester?.id;
    _healthLockerController.subscriptionModel.subscriptionEditAndApprovalRequest
        ?.excludedSources = [];
    _healthLockerController.subscriptionModel.subscriptionEditAndApprovalRequest
            ?.includedSources =
        _healthLockerController.subscription?.includedSources;
    _healthLockerController.subscriptionModel.subscriptionEditAndApprovalRequest
        ?.isApplicableForAllHiPs = isApplicableForAllHIPs;

    await _healthLockerController
        .functionHandler(
          function: () => _healthLockerController.getEditSubscription(
            subscriptionId,
            _healthLockerController.subscriptionModel.toMap(),
          ),
          isLoaderReq: true,
        )
        .then(
          (value) => {
            if (_healthLockerController.responseHandler.status ==
                Status.success)
              {context.navigateBack()}
          },
        );
  }
}
