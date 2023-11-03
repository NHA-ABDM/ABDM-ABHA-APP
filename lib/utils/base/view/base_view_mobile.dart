import 'package:abha/app/dashboard/view/main/dashboard_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';

class BaseViewMobile extends StatelessWidget {
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
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Color backgroundColor;

  const BaseViewMobile({
    required this.isAppBar,
    required this.isDarkTabBar,
    required this.isKeyReq,
    required this.title,
    required this.actions,
    required this.isCenterTitle,
    required this.elevation,
    required this.isTopSafeArea,
    required this.isBottomSafeArea,
    required this.type,
    required this.paddingValueMobile,
    required this.body,
    required this.drawer,
    required this.bottomNavigationBar,
    required this.floatingActionButtonLocation,
    required this.floatingActionButton,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: isKeyReq ? scaffoldKey : key,
      appBar: isAppBar ? _appBarWidget(context) : null,
      drawer: drawer,
      body: _bodyWidget(body),
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  AppBar _appBarWidget(BuildContext context) {
    Color bgColor = isDarkTabBar
        ? Theme.of(context).primaryColorDark
        : Theme.of(context).primaryColorLight;
    Color fgColor = isDarkTabBar
        ? Theme.of(context).primaryColorLight
        : Theme.of(context).primaryColorDark;
    return AppBar(
      title: Text(
        title,
        style: CustomTextStyle.titleLarge(context)
            ?.apply(color: fgColor, fontWeightDelta: 2, heightFactor: 0.0),
      ),
      leading: (!Validator.isTestRunning())
          ? context.navigateCanPop() && type != DashboardView
              ? const BackButton()
                  .sizedBox(height: Dimen.d_20, width: Dimen.d_20)
                  .marginOnly(left: Dimen.d_10)
              : null
          : null,
      centerTitle: isCenterTitle,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      actions: actions,
      actionsIconTheme: IconThemeData(
        color: fgColor,
      ),
      iconTheme: IconThemeData(
        size: Dimen.d_28,
        color: fgColor,
      ),
    );
  }

  Widget _bodyWidget(Widget body) {
    return SafeArea(
      top: isTopSafeArea,
      bottom: isBottomSafeArea,
      maintainBottomViewPadding: true,
      child: body.paddingAll(paddingValueMobile),
    );
  }
}
