import 'package:abha/export_packages.dart';
import 'package:abha/utils/base/view/base_view_desktop.dart';
import 'package:abha/utils/base/view/base_view_mobile.dart';
import 'package:flutter/foundation.dart';

class BaseView extends StatelessWidget {
  final bool isAppBar;
  final bool isDarkTabBar;
  final bool isKeyReq;
  final String title;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final double elevation;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;
  final Type? type;
  final double paddingValueMobile;
  final double paddingValueDesktop;
  final Widget bodyMobile;
  final Widget? bodyTablet;
  final Widget? bodyDesktop;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Color mobileBackgroundColor;
  final Color webBackgroundColor;
  final double height;

  BaseView({
    required this.type,
    required this.bodyMobile,
    super.key,
    this.isAppBar = true,
    this.isDarkTabBar = false,
    this.isKeyReq = false,
    this.title = '',
    this.actions,
    this.isCenterTitle = true,
    this.elevation = 1.5,
    this.isTopSafeArea = false,
    this.isBottomSafeArea = false,
    this.paddingValueMobile = 15.0,
    this.paddingValueDesktop = 0.0,
    this.bodyTablet,
    this.bodyDesktop,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.mobileBackgroundColor = AppColors.colorWhite4,
    this.webBackgroundColor = AppColors.colorBlueLight8,
    this.height = 0.4,
  }) {
    Logger abhaLog = customLogger(type);
    abhaLog.d(type.toString());
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? BaseViewDesktop(
            isAppBar: isAppBar,
            isDarkTabBar: isDarkTabBar,
            title: title,
            actions: actions,
            isCenterTitle: isCenterTitle,
            isKeyReq: isKeyReq,
            elevation: elevation,
            isTopSafeArea: isTopSafeArea,
            isBottomSafeArea: isBottomSafeArea,
            type: type,
            paddingValueMobile: paddingValueMobile,
            paddingValueDesktop: paddingValueDesktop,
            bodyMobile: bodyMobile,
            bodyTablet: bodyTablet ?? bodyMobile,
            bodyDesktop: bodyDesktop ?? bodyMobile,
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButton: floatingActionButton,
            backgroundColor: webBackgroundColor,
            height: height,
          )
        : BaseViewMobile(
            isAppBar: isAppBar,
            isDarkTabBar: isDarkTabBar,
            isKeyReq: isKeyReq,
            title: title,
            actions: actions,
            isCenterTitle: isCenterTitle,
            elevation: elevation,
            isTopSafeArea: isTopSafeArea,
            isBottomSafeArea: isBottomSafeArea,
            type: type,
            paddingValueMobile: paddingValueMobile,
            body: bodyMobile,
            drawer: drawer,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButtonLocation: floatingActionButtonLocation,
            floatingActionButton: floatingActionButton,
            backgroundColor: mobileBackgroundColor,
          );
  }
}
