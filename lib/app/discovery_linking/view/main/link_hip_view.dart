import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/view/desktop/link_hip_desktop_view.dart';
import 'package:abha/app/discovery_linking/view/mobile/link_hip_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';

class LinkHipView extends StatefulWidget {
  final Map arguments;

  const LinkHipView({required this.arguments, super.key});

  @override
  LinkHipViewState createState() => LinkHipViewState();
}

class LinkHipViewState extends State<LinkHipView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  late List _hipDataToLink;
  List careContextData = [];
  bool checkBoxValue = true;

  @override
  void initState() {
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    _hipDataToLink =
        widget.arguments[IntentConstant.data][ApiKeys.responseKeys.patient];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onLinkHip() async {
    _discoveryLinkingController
        .getLinkHip((responseModel) => _getLinkHipOnResponse(responseModel));
    // _discoveryLinkingController.functionHandler(
    //   function: () => _discoveryLinkingController.getLinkHip(),
    //   isLoaderReq: true,
    // ).then((_) {
    //   if (_discoveryLinkingController.responseHandler.status ==
    //       Status.success) {
    //     Map dataToLink = _discoveryLinkingController.responseHandler.data;
    //     var arguments = {IntentConstant.data: dataToLink};
    //     context.navigatePush(
    //       RoutePath.routeLinkingOtpHip,
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

  Future<void> _getLinkHipOnResponse(
    ApiSocketLocalResponseModel responseModel,
  ) async {
    Map dataToLink = jsonDecode(responseModel.data ?? '');
    var arguments = {IntentConstant.data: dataToLink};
    context
        .navigatePush(
      RoutePath.routeLinkingOtpHip,
      arguments: arguments,
    )
        .then((value) {
      context.navigateBack(result: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().linkMyHealthRecord.toTitleCase(),
      type: LinkHipView,
      bodyMobile: LinkHipMobileView(
        hipDataToLink: _hipDataToLink,
        onLinkHip: _onLinkHip,
      ),
      bodyDesktop: LinkHipDesktopView(
        hipDataToLink: _hipDataToLink,
        onLinkHip: _onLinkHip,
      ),
    );
  }
}
