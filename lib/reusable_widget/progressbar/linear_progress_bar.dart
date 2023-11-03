import 'package:abha/export_packages.dart';

class LinearProgressBar extends StatelessWidget {
  final double? percent;
  final double? width;
  final double height;

  const LinearProgressBar({
    required this.percent,
    required this.height,
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: percent,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.colorGreenDark),
          backgroundColor: AppColors.colorWhite,
        ),
      ),
    );
  }
}
