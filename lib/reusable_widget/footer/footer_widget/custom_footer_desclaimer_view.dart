import 'package:abha/export_packages.dart';
import 'package:abha/utils/common/device_info.dart';

class CustomFooterDisclaimerView extends StatelessWidget {
  const CustomFooterDisclaimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorBlueDark1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              LocalizationHandler.of().disclaimer,
              style: CustomTextStyle.titleMedium(context)?.apply(
                color: AppColors.colorWhite,
              ),
            ),
          ),
          FutureBuilder(
            future: CustomDeviceInfo.getAppVersion(),
            builder: (context, snapshot) {
              return Text(
                '${LocalizationHandler.of().version}: ${snapshot.data.toString()}',
                style: CustomTextStyle.labelMedium(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              );
            },
          ).marginOnly(left: Dimen.d_10, right: Dimen.d_10),
        ],
      ),
    );
  }
}
