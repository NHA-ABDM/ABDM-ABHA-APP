import 'package:abha/app/support/view/desktop/support_desktop_view.dart';
import 'package:abha/app/support/view/mobile/support_desktop_mobile_view.dart';
import 'package:abha/export_packages.dart';

class SupportView extends StatefulWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: SupportView,
      bodyMobile: const SupportDesktopMobileView(),
      // bodyDesktop: SupportDesktopView(),
      bodyDesktop: const SupportDesktopView(),
    );
  }
}
