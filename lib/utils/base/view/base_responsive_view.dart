import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';

class BaseResponsiveView extends GetResponsiveView {
  final Widget? phoneWidget;
  final Widget? tabletWidget;
  final Widget? desktopWidget;

  BaseResponsiveView({super.key, this.phoneWidget, this.tabletWidget, this.desktopWidget});

  @override
  Widget? phone() {
    return phoneWidget;
  }

  @override
  Widget? tablet() {
    return tabletWidget;
  }

  @override
  Widget? desktop() {
    return desktopWidget;
  }
}
