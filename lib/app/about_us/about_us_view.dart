import 'package:abha/export_packages.dart';
import 'package:abha/utils/common/device_info.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  AboutUsViewState createState() => AboutUsViewState();
}

class AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: AboutUsView,
      title: LocalizationHandler.of().aboutUs.toTitleCase(),
      bodyMobile: FutureBuilder(
        future: CustomDeviceInfo.getAppVersion(),
        builder: (context, snapshot) {
          return mainWidget(snapshot.data.toString());
        },
      ),
    );
  }

  /// @Here is the textAboutUs() Widget returns the Row() widget having [child]
  /// Text which consist of Version of the app. Text() have [style] and [color] property.
  Widget mainWidget(String version) {
    return Row(
      children: [
        Text(
          '${LocalizationHandler.of().version}: $version',
          style: CustomTextStyle.bodyLarge(context)?.apply(
            color: AppColors.colorAppBlue,
          ),
        ).marginOnly(left: Dimen.d_10, right: Dimen.d_10, top: Dimen.d_10),
      ],
    );
  }
}
