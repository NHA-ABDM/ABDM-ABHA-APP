import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/view/desktop/discover_hip_desktop_view.dart';
import 'package:abha/app/discovery_linking/view/mobile/discover_hip_mobile_view.dart';
import 'package:abha/app/health_locker/model/provider_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';

class DiscoverHipView extends StatefulWidget {
  final ProviderModel arguments;

  const DiscoverHipView({required this.arguments, super.key});

  @override
  DiscoverHipViewState createState() => DiscoverHipViewState();
}

class DiscoverHipViewState extends State<DiscoverHipView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  late ProviderModel _govtProgramModel;
  late ProfileModel? _profileModel;

  @override
  void initState() {
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    _profileModel = Get.find<ProfileController>().profileModel;
    _govtProgramModel = widget.arguments;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onDiscoveryHip() async {
    // ApiSocketIOConnection().connectToServer();

    _discoveryLinkingController.getDiscoverHip(
      _govtProgramModel.identifier.name,
      _govtProgramModel.identifier.id,
      _profileModel,
      (responseModel) => _getDiscoverHipOnResponse(responseModel),
    );

    // old-------
    // _discoveryLinkingController.functionHandler(
    //   function: () => _discoveryLinkingController.getDiscoverHipSocket(
    //     _govtProgramModel.identifier?.name ?? '',
    //     _govtProgramModel.identifier?.id ?? '',
    //   ),
    //   isLoaderReq: true,
    // ).then((_) {
    //   if (_discoveryLinkingController.responseHandler.status == Status.success) {
    //     Map discoveryData = _discoveryLinkingController.responseHandler.data;
    //     var arguments = {IntentConstant.data: discoveryData};
    //     context.navigatePush(
    //       RoutePath.routeLinkingHip,
    //       arguments: arguments,
    //     ).then((value) {
    //       bool isHipLinked = value ?? false;
    //       if (isHipLinked) {
    //         context.navigateBack(result: value);
    //       }
    //     });
    //   }
    // });
  }

  void _getDiscoverHipOnResponse(ApiSocketLocalResponseModel responseModel) {
    _discoveryLinkingController.getDiscoverHipResponseHandler(responseModel);
    Map? discoveryData = _discoveryLinkingController.discoveryRespData;
    if (!Validator.isNullOrEmpty(discoveryData)) {
      var arguments = {IntentConstant.data: discoveryData};
      context
          .navigatePush(
        RoutePath.routeLinkingHip,
        arguments: arguments,
      )
          .then((value) {
        context.navigateBack(result: value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().linkMyHealthRecord.toTitleCase(),
      type: DiscoverHipView,
      bodyMobile: DiscoverHipMobileView(
        onDiscoveryHip: _onDiscoveryHip,
        name: _govtProgramModel.identifier.name,
      ),
      bodyDesktop: DiscoverHipDesktopView(
        onDiscoveryHip: _onDiscoveryHip,
        name: _govtProgramModel.identifier.name,
      ),
    );
  }
}
