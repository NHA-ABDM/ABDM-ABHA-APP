import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/share_profile/share_profile_link_model.dart';
import 'package:abha/export_packages.dart';

class ShareProfilePhrUhiWidget extends StatelessWidget {
  final String title;
  final List<ShareProfileDataList> shareProfileDataList;
  final VoidCallback? callback;
  final Map<String, dynamic>? shareQueryParam;
  final Map<String, dynamic>? uhiQueryParam;
  final ShareProfileController _shareProfileController =
      Get.find<ShareProfileController>();

  ShareProfilePhrUhiWidget({
    required this.title,
    required this.shareProfileDataList,
    super.key,
    this.callback,
    this.shareQueryParam,
    this.uhiQueryParam,
  });

  void _onClickHandler(int position) {
    ShareProfileDataList dataList = shareProfileDataList[position];
    bool isIntentURLAvailable = dataList.isIntentURLAvailable ?? false;
    String userAgent = _shareProfileController.webBrowserInfo?.userAgent ?? '';
    String link = '';
    if (isIntentURLAvailable) {
      link = dataList.intentUrl ?? '';
    } else if (userAgent.toLowerCase().contains('chrome')) {
      link = dataList.androidUrl ?? '';
    } else if (userAgent.toLowerCase().contains('safari')) {
      link = dataList.iosUrl ?? '';
    } else {}
    _shareProfileController.launchUrlHandler(
      link,
      uhiQueryParam: uhiQueryParam,
      shareQueryParam: shareQueryParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InfoNote(note: title),
          ListView.separated(
            shrinkWrap: true,
            itemCount: shareProfileDataList.length,
            separatorBuilder: (context, position) {
              return const Divider(
                color: AppColors.colorGrey1,
              );
            },
            itemBuilder: (context, position) {
              ShareProfileDataList dataList = shareProfileDataList[position];
              String title = dataList.name ?? '';
              String image = dataList.icon ?? '';
              return ListTile(
                onTap: () {
                  _onClickHandler(position);
                },
                leading: CustomImageView(
                  image: image,
                  width: Dimen.d_40,
                  height: Dimen.d_40,
                ),
                title: Text(
                  title,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack6,
                    fontSizeDelta: -2,
                    fontWeightDelta: 2,
                  ),
                ),
              );
            },
          ).marginOnly(top: Dimen.d_15),
        ],
      ),
    );
  }
}
