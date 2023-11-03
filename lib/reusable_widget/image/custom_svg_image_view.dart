import 'package:abha/export_packages.dart';

class CustomSvgImageView extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;

  const CustomSvgImageView(
    this.image, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      colorFilter: (color != null)
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
      height: height ,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}
