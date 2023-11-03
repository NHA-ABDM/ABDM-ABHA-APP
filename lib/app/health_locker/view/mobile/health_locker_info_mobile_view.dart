import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/app/health_locker/widget/health_locker_authorization_card_widget.dart';
import 'package:abha/app/health_locker/widget/health_locker_subscription_card_widget.dart';
import 'package:abha/export_packages.dart';

class HealthLockerInfoMobileView extends StatefulWidget {
  final Map arguments;

  const HealthLockerInfoMobileView({required this.arguments, super.key});

  @override
  State<HealthLockerInfoMobileView> createState() =>
      _HealthLockerInfoMobileViewState();
}

class _HealthLockerInfoMobileViewState
    extends State<HealthLockerInfoMobileView> {
  late HealthLockerController healthLockerController;
  late ScrollController scrollController;
  // late String _screenTitle = '';
  // late String _fromScreenString;

  @override
  void initState() {
    // _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    healthLockerController = Get.find<HealthLockerController>();
    scrollController = ScrollController();
    super.initState();
  }

  // void initScreenTitleText() {
  //   if (_fromScreenString == StringConstants.forSubscription) {
  //     _screenTitle =
  //         LocalizationHandler.of().active_subscription_requests.toTitleCase();
  //   } else if (_fromScreenString == StringConstants.forAuthorization) {
  //     _screenTitle =
  //         LocalizationHandler.of().active_authorisation_requests.toTitleCase();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenTitleText();
    return _getLockerInfoListView();
  }

  Widget _getLockerInfoListView() {
    var consents = widget.arguments[IntentConstant.data];

    return (!Validator.isNullOrEmpty(consents))
        ? ListView.separated(
            controller: scrollController,
            itemCount: consents.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: Dimen.d_25);
            },
            itemBuilder: (context, index) {
              if (consents[index] is Subscription) {
                Subscription subscriptionRequest = consents[index];
                return HealthLockerSubscriptionCardWidget(
                  subscriptionRequest: subscriptionRequest,
                  requestType: healthLockerController
                      .getRequestType(subscriptionRequest.status ?? ''),
                );
              } else if (consents[index] is Authorization) {
                Authorization authorizationRequest = consents[index];
                return HealthLockerAuthorizationCardWidget(
                  authorizationRequest: authorizationRequest,
                  requestType: healthLockerController
                      .getRequestType(authorizationRequest.status ?? ''),
                );
              }
              return const SizedBox.shrink();
            },
          )
        : Text(
            '',
            style: CustomTextStyle.bodyLarge(context)
                ?.apply(color: AppColors.colorBlack1),
          ).centerWidget;
  }
}
