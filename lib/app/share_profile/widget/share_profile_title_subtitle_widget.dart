import 'package:abha/export_packages.dart';

class ShareProfileTitleSubtitleWidget extends StatelessWidget {
  final String title;
  final String value;
  final String keyValue;
  final bool isCenter;
  const ShareProfileTitleSubtitleWidget({
    required this.title,
    required this.value,
    required this.keyValue,
    super.key,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Text(
            title,
            style: CustomTextStyle.labelMedium(context)?.apply(
              color: AppColors.colorBlack6,
              fontWeightDelta: -1,
            ),
          ),
          Text(
            value,
            key: Key(keyValue),
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontSizeDelta: -1,
              fontWeightDelta: 2,
            ),
          ),
        ],
        interItemSpace: Dimen.d_5,
        flowHorizontal: false,
      ),
    );
  }
}
