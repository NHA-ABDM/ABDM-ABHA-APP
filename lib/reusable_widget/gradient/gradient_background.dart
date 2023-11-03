import 'package:abha/export_packages.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorBlueLight6,
            AppColors.colorWhite,
          ],
        ),
      ),
      child: child.centerWidget,
    );
  }
}
