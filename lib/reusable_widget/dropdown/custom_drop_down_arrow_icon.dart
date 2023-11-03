import 'package:abha/export_packages.dart';

class CustomDropDownArrowIcon extends StatelessWidget {
  const CustomDropDownArrowIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSvgImageView(
      ImageLocalAssets.dropDownArrowSvgIcon,
      width: Dimen.d_20,
      height: Dimen.d_20,
    );
  }
}
