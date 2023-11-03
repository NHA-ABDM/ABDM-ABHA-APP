import 'package:abha/export_packages.dart';
import 'package:abha/utils/theme/desktop/card_theme_desktop.dart';

class CommonBackgroundCard extends StatelessWidget {
  final Widget child;

  const CommonBackgroundCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CardThemeDesktop.backgroundColor,
        border: CardThemeDesktop.border,
        boxShadow: CardThemeDesktop.shadow,
        borderRadius: BorderRadius.circular(CardThemeDesktop.borderRadius),
      ),
      child:
          child.paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
    );
  }
}
