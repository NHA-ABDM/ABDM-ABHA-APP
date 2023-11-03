import 'package:abha/export_packages.dart';

class InfoNote extends StatelessWidget {
  final String note;
  final bool isCenter;
  const InfoNote({
    required this.note,
    super.key,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        color: AppColors.colorGreyLight8,
        borderColor: AppColors.colorPurple1,
        size: Dimen.d_0,
      ),
      child: Row(
        crossAxisAlignment:
            isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Icon(
            IconAssets.infoOutline,
            size: Dimen.d_20,
            color: AppColors.colorAppBlue,
          ),
          Flexible(
            child: Text(
              note,
              softWrap: true,
              //maxLines: 4,
              style: CustomTextStyle.titleSmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: -1,
                fontSizeDelta: -1,
                heightDelta: 0.3,
              ),
            ).marginOnly(left: Dimen.d_10, right: Dimen.d_10),
          )
        ],
      ).paddingSymmetric(vertical: Dimen.d_10, horizontal: Dimen.d_10),
    );
  }
}
