import 'package:abha/export_packages.dart';

class CustomCircularBorderBackground extends StatelessWidget {
  final String? image;
  final double? outerRadius;
  final double? innerRadius;
  final VoidCallback? onClick;

  const CustomCircularBorderBackground({
    required this.image,
    super.key,
    this.outerRadius,
    this.innerRadius,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    double height = (outerRadius != null) ? (outerRadius! * 2) : Dimen.d_130;
    double width = (outerRadius != null) ? (outerRadius! * 2) : Dimen.d_130;
    return GestureDetector(
      onTap: onClick,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Validator.isNullOrEmpty(image)
              ? Image.asset(
                  ImageLocalAssets.account,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : Image.memory(
                  const Base64Decoder().convert(image ?? ''),
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
        ),
      ),
    );
  }
}
