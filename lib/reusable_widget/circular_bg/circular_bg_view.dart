import 'package:abha/export_packages.dart';

class CustomCircularBackground extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final double? radius;
  final Color? bgColor;

  const CustomCircularBackground({
    required this.image,
    super.key,
    this.width,
    this.height,
    this.radius,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return
        // CircleAvatar(
        //   radius: radius ?? Dimen.d_45,
        //   backgroundColor: bgColor ?? AppColors.colorBlueLight2,
        //   child:
        CustomSvgImageView(
      image,
      width: width ?? Dimen.d_43,
      height: height ?? Dimen.d_43,
      // ),
    );
  }
}
