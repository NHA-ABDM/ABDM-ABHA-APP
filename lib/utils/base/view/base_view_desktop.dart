import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/app_bar/desktop/custom_header_desktop_phone_size_view.dart';
import 'package:abha/reusable_widget/app_bar/desktop/custom_header_desktop_view.dart';
import 'package:abha/reusable_widget/footer/custom_footer_desktop_view.dart';
import 'package:abha/reusable_widget/footer/custom_footer_mobile_view.dart';

class BaseViewDesktop extends StatelessWidget {
  final bool isAppBar;
  final bool isDarkTabBar;
  final String title;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool isKeyReq;
  final double elevation;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;
  final Type? type;
  final double paddingValueMobile;
  final double paddingValueDesktop;
  final Widget bodyMobile;
  final Widget bodyTablet;
  final Widget bodyDesktop;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Color backgroundColor;
  final double height;
  final ScrollController scrollController = ScrollController();

  BaseViewDesktop({
    required this.isAppBar,
    required this.isDarkTabBar,
    required this.title,
    required this.actions,
    required this.isCenterTitle,
    required this.isKeyReq,
    required this.elevation,
    required this.isTopSafeArea,
    required this.isBottomSafeArea,
    required this.type,
    required this.paddingValueMobile,
    required this.paddingValueDesktop,
    required this.bodyMobile,
    required this.bodyTablet,
    required this.bodyDesktop,
    required this.drawer,
    required this.bottomNavigationBar,
    required this.floatingActionButtonLocation,
    required this.floatingActionButton,
    required this.backgroundColor,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
      const ApplicationSwitcherDescription(
        label: 'ABHA Address | ABDM',
        primaryColor: 0xFF152C69,
      ),
    );
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Scrollbar(
        controller: scrollController,
        trackVisibility: true,
        // thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          primary: false,
          child: BaseResponsiveView(
            phoneWidget: _desktopPhoneSizeWidget(context),
            tabletWidget: _desktopPhoneSizeWidget(context),
            desktopWidget: _desktopWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _desktopWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeaderDesktopView(type: type),
        Container(
          constraints: BoxConstraints(minHeight: context.height * height),
          child: bodyDesktop.paddingAll(paddingValueDesktop),
        ),
        CustomFooterDesktopView()
      ],
    );
  }

  Widget _desktopPhoneSizeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomHeaderDesktopPhoneSizeView(),
        Container(
          constraints: BoxConstraints(minHeight: context.height * height),
          child: bodyMobile.paddingAll(paddingValueMobile),
        ),
        CustomFooterMobileView()
      ],
    );
  }
}
