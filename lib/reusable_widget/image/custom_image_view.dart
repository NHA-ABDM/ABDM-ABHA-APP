import 'package:abha/export_packages.dart';

class CustomImageView extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;

  const CustomImageView({
    required this.image,
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: height ?? context.height,
      width: width ?? context.width,
      fit: BoxFit.contain,
    );
  }
}
