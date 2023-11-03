import 'package:abha/app/consents/view/desktop/consent_approved_desktop_view.dart';
import 'package:abha/app/consents/view/desktop/consent_request_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class ConsentsDesktopView extends StatefulWidget {
  const ConsentsDesktopView({super.key});

  @override
  State<ConsentsDesktopView> createState() => _ConsentsDesktopViewState();
}

class _ConsentsDesktopViewState extends State<ConsentsDesktopView> with TickerProviderStateMixin {
  late ConsentController _consentController;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    _consentController.requestedFilter = 'All';
    _consentController.approvedFilter = 'Granted';

    super.initState();
  }

  @override
  void dispose() {
    abhaSingleton.getLocalNotificationService.notificationType(false);
    DeleteControllers().deleteConsent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().consents.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
          ).marginOnly(bottom: Dimen.d_20),
          _consentWidget(),
        ],
      ).marginAll(Dimen.d_20),
      showBackOption: false,
    );
  }

  Widget _consentWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: _consentController.selectedTabIndex,
      builder: (context, index, _) {
        return index == 0 ? const ConsentRequestDesktopView() : const ConsentApprovedDesktopView();
      },
    ).paddingSymmetric(horizontal: Dimen.d_10);
  }
}
