import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_artefacts_details_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consent_artefacts_details_mobile_view.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';

class ConsentArtefactsDetailsView extends StatefulWidget {
  final Map arguments;

  const ConsentArtefactsDetailsView({required this.arguments, super.key});

  @override
  State<ConsentArtefactsDetailsView> createState() =>
      _ConsentArtefactsDetailsViewState();
}

class _ConsentArtefactsDetailsViewState
    extends State<ConsentArtefactsDetailsView> {
  late ConsentController _consentController;

  List<ConsentArtefactModel?> get artefact =>
      _consentController.consentArtefact;

  SubscriptionRequest? get request => _consentController.subscriptionRequest;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    _consentController.tempResponseData = null;
    _consentController.subscriptionRequest = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _consentController.functionHandler(
        function: () async {
          await fetchConsentRequestById();
          await fetchSubscriptionRequest();
          await fetchAndUpdateLinkedFacility();
        },
        isUpdateUi: true,
        isLoaderReq: true,
      );
    });
    super.initState();
  }

  Future<void> fetchAndUpdateLinkedFacility() async {
    _consentController.functionHandler(
      function: () async {
        await _consentController.fetchLinkedFacility();
        // setState(() {});
      },
      isUpdateUi: true,
    );
  }

  Future<void> fetchAndUpdateProviderDetails() async {
    if (!Validator.isNullOrEmpty(request?.details?.hips)) {
      Map<String, dynamic> providerDetails = await _consentController
          .fetchProviderDetails(request?.details?.hips?.id ?? '');
      request?.details?.hips?.name =
          providerDetails[ApiKeys.responseKeys.identifier]
              [ApiKeys.responseKeys.name];
    }
  }

  /// fetchConsentRequestById() call the fetch consent API
  /// with with individual Id to get its details
  Future<void> fetchConsentRequestById() async {
    await _consentController.fetchSubscriptionByRequestId(
      subscriptionRequestId: widget.arguments[IntentConstant.subscriptionID],
    );
  }

  Future<void> fetchSubscriptionRequest() async {
    await _consentController.fetchSubscriptionRequest(
      subscriptionId:
          _consentController.subscriptionRequest?.subscriptionId ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsentController>(
      builder: (_) {
        return BaseView(
          title: LocalizationHandler.of().consentDetails,
          type: ConsentArtefactsDetailsView,
          bodyDesktop:
              ConsentArtefactsDetailsDesktopView(arguments: widget.arguments),
          bodyMobile:
              ConsentArtefactsDetailsMobileView(arguments: widget.arguments),
        );
      },
    );
  }
}
