import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/share_profile/widget/share_profile_phr_uhi_list_widget.dart';
import 'package:abha/export_packages.dart';

class ShareProfilePhrLinkDesktopView extends StatefulWidget {
  final String shareHipId, counterId;

  const ShareProfilePhrLinkDesktopView({
    required this.shareHipId,
    required this.counterId,
    super.key,
  });

  @override
  ShareProfilePhrLinkDesktopViewState createState() =>
      ShareProfilePhrLinkDesktopViewState();
}

class ShareProfilePhrLinkDesktopViewState
    extends State<ShareProfilePhrLinkDesktopView> {
  late ShareProfileController _shareProfileController;
  late Map<String, dynamic> _shareQueryParam;
  final String phrLocalPath = 'assets/json/phr_list.json';

  @override
  void initState() {
    _shareProfileController = Get.find<ShareProfileController>();
    _shareQueryParam = {
      ApiKeys.responseKeys.hip_id: widget.shareHipId,
      ApiKeys.responseKeys.counterId: widget.counterId,
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shareProfileController.getLocalJsonData(context, phrLocalPath),
      builder: (context, snapshot) {
        return Card(
          child: ShareProfilePhrUhiWidget(
            title: LocalizationHandler.of().shareProfileWeb,
            shareProfileDataList:
                _shareProfileController.shareProfileLinkDataList,
            shareQueryParam: _shareQueryParam,
          ),
        ).sizedBox(width: Dimen.d_400);
      },
    );
  }
}
