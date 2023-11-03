import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/app/health_locker/widget/health_locker_subscription_card_desktop_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';

class HealthLockerInfoDesktopView extends StatefulWidget {
  final Map arguments;

  const HealthLockerInfoDesktopView({required this.arguments, super.key});

  @override
  State<HealthLockerInfoDesktopView> createState() =>
      _HealthLockerInfoDesktopViewState();
}

class _HealthLockerInfoDesktopViewState
    extends State<HealthLockerInfoDesktopView> {
  late HealthLockerController healthLockerController;
  late ScrollController scrollController;

  // late String _screenTitle = '';
  late String _fromScreenString;

  @override
  void initState() {
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    healthLockerController = Get.find<HealthLockerController>();
    scrollController = ScrollController();
    super.initState();
  }

  String initScreenTitleText() {
    if (_fromScreenString == StringConstants.forSubscription) {
      return LocalizationHandler.of()
          .active_subscription_requests
          .toTitleCase();
    } else if (_fromScreenString == StringConstants.forAuthorization) {
      return LocalizationHandler.of()
          .active_authorisation_requests
          .toTitleCase();
    }
    return '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenTitleText();

    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            initScreenTitleText(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          _getLockerInfoListView()
        ],
      ).marginAll(Dimen.d_20),
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

  Widget _getLockerInfoListView() {
    List<Subscription> consents = widget.arguments[IntentConstant.data];

    return (!Validator.isNullOrEmpty(consents))
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableHeaderView(
                children: [
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
                          child: getTitleText(LocalizationHandler.of().date),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: getTitleText(
                      LocalizationHandler.of().status,
                      align: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: consents.length,
                  itemBuilder: (context, index) {
                    Subscription subscriptionRequest = consents[index];
                    return HealthLockerSubscriptionCardDesktopWidget(
                      subscriptionRequest: subscriptionRequest,
                      requestType: healthLockerController
                          .getRequestType(subscriptionRequest.status ?? ''),
                      backgroundColor: (index % 2 == 0)
                          ? AppColors.colorWhite
                          : AppColors.colorGreyVeryLight,
                      onClick: () {
                        var arguments = {
                          IntentConstant.subscriptionID:
                              subscriptionRequest.subscriptionId
                        };
                        context.navigatePush(
                          RoutePath.routeHealthLockerEditSubscription,
                          arguments: arguments,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
