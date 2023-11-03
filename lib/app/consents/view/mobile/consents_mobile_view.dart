import 'package:abha/app/consents/view/mobile/consent_approved_mobile_view.dart';
import 'package:abha/app/consents/view/mobile/consent_request_mobile_view.dart';
import 'package:abha/app/consents/view/mobile/consent_switch_tab_widget.dart';
import 'package:abha/export_packages.dart';

class ConsentsMobileView extends StatefulWidget {
  const ConsentsMobileView({super.key});

  @override
  State<ConsentsMobileView> createState() => _ConsentsMobileViewState();
}

class _ConsentsMobileViewState extends State<ConsentsMobileView>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
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
    return _consentWidget();
  }

  Widget _consentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConsentSwitchTabWidget(
          onTabSwitch: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ).paddingSymmetric(vertical: Dimen.d_15, horizontal: Dimen.d_15),
        Flexible(
          fit: FlexFit.loose,
          child: _selectedIndex == 0
              ? const ConsentRequestMobileView()
              : const ConsentApprovedMobileView(),
        ),
      ],
    );
  }
}
