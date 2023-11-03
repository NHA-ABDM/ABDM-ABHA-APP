import 'package:abha/app/linked_facility/view/desktop/linked_facility_desktop_view.dart';
import 'package:abha/app/linked_facility/view/mobile/linked_facility_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LinkedFacilityView extends StatefulWidget {
  const LinkedFacilityView({super.key});

  @override
  LinkedFacilityViewState createState() => LinkedFacilityViewState();
}

class LinkedFacilityViewState extends State<LinkedFacilityView> {
  late LinkedFacilityController _linkFacilityController;

  @override
  void initState() {
    _linkFacilityController = Get.find<LinkedFacilityController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var data = _linkFacilityController.responseHandler.data;
      LinkedFacilityModel linkFacilityModel =
          data is LinkedFacilityModel ? data : LinkedFacilityModel();
      if (Validator.isNullOrEmpty(linkFacilityModel.patient?.links) || kIsWeb) {
        _fetchLinkFacilityData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here is the function to fetch the data from api from Controller. You can
  /// get the list of linked Facility from the function getLinkFacilityFetch() called
  /// from Linked facility controller Class.
  /// param  [isUpdateUiOnLoading] bool
  Future<void> _fetchLinkFacilityData() async {
    _linkFacilityController.functionHandler(
      function: () => _linkFacilityController.getLinkFacilityFetch(),
      isLoaderReq: true,
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
    );
  }

  // work for desktop mobile
  void _onDiscoveryLinking() {
    context.navigatePush(RoutePath.routeDiscoveryLinking);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isAppBar: false,
      type: HealthRecordView,
      bodyMobile: LinkedFacilityMobileView(
        onDiscoveryLinking: _onDiscoveryLinking,
        fetchLinkFacilityData: _fetchLinkFacilityData,
      ),
      bodyDesktop: LinkedFacilityDesktopView(
        onDiscoveryLinking: _onDiscoveryLinking,
        fetchLinkFacilityData: _fetchLinkFacilityData,
      ),
    );
  }
}
