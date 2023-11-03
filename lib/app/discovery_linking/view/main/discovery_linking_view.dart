import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/discovery_linking_repo.dart';
import 'package:abha/app/discovery_linking/view/desktop/discovery_linking_desktop_view.dart';
import 'package:abha/app/discovery_linking/view/mobile/discovery_linking_mobile_view.dart';
import 'package:abha/export_packages.dart';

class DiscoveryLinkingView extends StatefulWidget {
  const DiscoveryLinkingView({super.key});

  @override
  DiscoveryLinkingViewState createState() => DiscoveryLinkingViewState();
}

class DiscoveryLinkingViewState extends State<DiscoveryLinkingView> {
  late DiscoveryLinkingController _discoveryLinkingController;

  @override
  void initState() {
    _discoveryLinkingController =
        Get.put(DiscoveryLinkingController(DiscoveryLinkingRepoImpl()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGovtProgramData();
    });
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteDiscoveryLinking();
    super.dispose();
  }

  Future<void> _fetchGovtProgramData() async {
    _discoveryLinkingController.functionHandler(
      function: () => _discoveryLinkingController.getGovtProgram(),
      isLoaderReq: true,
      isUpdateUi: true,
    );
  }

  Future<void> _searchHipData(String searchValue) async {
    if (Validator.isNullOrEmpty(searchValue)) {
      _fetchGovtProgramData();
    } else if (searchValue.trim().length > 3) {
      await _discoveryLinkingController.functionHandler(
        function: () => _discoveryLinkingController.getSearchHip(searchValue),
        isLoaderReq: true,
        isUpdateUi: true,
        isUpdateUiOnLoading: true,
      );
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().linkMyHealthRecord.toTitleCase(),
      type: DiscoveryLinkingView,
      bodyMobile: DiscoveryLinkingMobileView(
        searchHipData: _searchHipData,
      ),
      bodyDesktop: DiscoveryLinkingDesktopView(
        searchHipData: _searchHipData,
      ),
    );
  }
}
