import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/share_profile/widget/share_profile_phr_uhi_list_widget.dart';
import 'package:abha/export_packages.dart';

class ShareProfileUhiLinkDesktopView extends StatefulWidget {
  final String uhiHipId;

  const ShareProfileUhiLinkDesktopView({
    required this.uhiHipId,
    super.key,
  });

  @override
  ShareProfileUhiLinkDesktopViewState createState() =>
      ShareProfileUhiLinkDesktopViewState();
}

class ShareProfileUhiLinkDesktopViewState
    extends State<ShareProfileUhiLinkDesktopView> {
  late ShareProfileController _shareProfileController;
  late Map<String, dynamic> _uhiQueryParam;
  final String uhiLocalPath = 'assets/json/uhi_list.json';

  @override
  void initState() {
    _shareProfileController = Get.find<ShareProfileController>();
    _uhiQueryParam = {ApiKeys.requestKeys.hip: widget.uhiHipId};
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shareProfileController.getLocalJsonData(context, uhiLocalPath),
      builder: (context, snapshot) {
        return ShareProfilePhrUhiWidget(
          title: LocalizationHandler.of().createAbhaIdWeb,
          shareProfileDataList:
              _shareProfileController.shareProfileLinkDataList,
          uhiQueryParam: _uhiQueryParam,
        ).sizedBox(width: Dimen.d_400);
      },
    );
  }
}
