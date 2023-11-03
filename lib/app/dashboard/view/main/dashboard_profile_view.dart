import 'package:abha/app/dashboard/view/desktop/dashboard_profile_desktop_view.dart';
import 'package:abha/export_packages.dart';

class DashboardProfileView extends StatefulWidget {
  final bool isWeb;
  const DashboardProfileView({super.key, this.isWeb = false});

  @override
  DashboardProfileViewState createState() => DashboardProfileViewState();
}

class DashboardProfileViewState extends State<DashboardProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isWeb
        ? const DashboardProfileDesktopView()
        : const DashboardProfileMobileView();
  }
}
