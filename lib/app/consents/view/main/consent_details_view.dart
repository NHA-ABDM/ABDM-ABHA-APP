import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_details_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consent_details_mobile_view.dart';
import 'package:abha/export_packages.dart';

class ConsentDetailsView extends StatefulWidget {
  final Map arguments;

  const ConsentDetailsView({required this.arguments, super.key});

  @override
  State<ConsentDetailsView> createState() => _ConsentDetailsViewState();
}

class _ConsentDetailsViewState extends State<ConsentDetailsView> {
  late ConsentController _consentController;
  ConsentRequestModel _request = ConsentRequestModel(status: '');
  late String consentReqId;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _consentController.linkFacilityHipContext = {};
    super.dispose();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
    consentReqId = widget.arguments[IntentConstant.data];
    _consentController.tempResponseData = null;
    _consentController.consentRequest = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _consentController.functionHandler(
        function: () async {
          await _fetchConsentById(); // it must call at last // but I called it first, because we need to first consent details and after thet HIU nad HIP names can be fetched and updated in model
          await _fetchAndUpdateHiuDetails();
          await _fetchAndUpdateHipDetails();
          // await _fetchAndUpdateLinkedFacility();
          await _fetchAndUpdateConsentArtifacts();
        },
        isUpdateUi: true,
        isLoaderReq: true,
      );
    });
  }

  Future<void> _fetchAndUpdateHiuDetails() async {
    if (!Validator.isNullOrEmpty(_consentController.consentRequest?.hiu)) {
      Map<String, dynamic> providerDetails =
          await _consentController.fetchProviderDetails(
        _consentController.consentRequest?.hiu?.id ?? '',
      );
      _consentController.consentRequest?.hiu?.name =
          providerDetails[ApiKeys.responseKeys.identifier]
              [ApiKeys.responseKeys.name];
    }
  }

  Future<void> _fetchAndUpdateHipDetails() async {
    if (!Validator.isNullOrEmpty(_consentController.consentRequest?.hip)) {
      Map<String, dynamic> providerDetails =
          await _consentController.fetchProviderDetails(
        _consentController.consentRequest?.hip?.id ?? '',
      );
      _consentController.consentRequest?.hip?.name =
          providerDetails[ApiKeys.responseKeys.identifier]
              [ApiKeys.responseKeys.name];

      _consentController.selectedHipContext[_consentController.consentRequest?.hip?.name ?? ''] = Set.from(_consentController.consentRequest?.careContexts ?? []);

    }
  }

  Future<void> _fetchConsentById() async {
    await _consentController.fetchConsentRequestById(consentReqId);
    _request = _consentController.consentRequest ?? ConsentRequestModel();
  }

  Future<void> _fetchAndUpdateProviderDetails() async {
    if (_request.status != ConsentStatus.expired &&
        !Validator.isNullOrEmpty(_consentController.consentRequest?.hiu)) {
      Map<String, dynamic> providerDetails =
          await _consentController.fetchProviderDetails(_request.hiu?.id ?? '');
      _request.hiu?.name = providerDetails[ApiKeys.responseKeys.identifier]
          [ApiKeys.responseKeys.name];
    }
  }

  // Future<void> _fetchAndUpdateLinkedFacility() async {
  //   _consentController.functionHandler(
  //     function: () => _consentController.fetchLinkedFacility(),
  //     isUpdateUi: true,
  //   );
  // }

  Future<void> _fetchAndUpdateConsentArtifacts() async {
    if (_request.status == ConsentStatus.granted) {
      await _consentController.fetchConsentArtifacts(_request.id ?? '');
    }
  }

  void _onGrantConsentClick() {
    _consentController.functionHandler(
      function: () async {
        await _consentController
            .approveConsent(consentReqId)
            .then((value) => context.navigateBack());
      },
      isLoaderReq: true,
      isUpdateUiOnLoading: true,
      isUpdateUi: true,
      isShowError: true,
    );
  }

  void _onDenyClick(String requestId) {
    /// show popup before deny to consent
    CustomDialog.showPopupDialog(
      title: LocalizationHandler.of().consents,
      LocalizationHandler.of().doyouwanttodenyrequest,
      onNegativeButtonPressed: () {
        context.navigateBack();
      },
      onPositiveButtonPressed: () {
        context.navigateBack();
        _consentController.functionHandler(
          function: () async {
            _consentController.denyConsentRequest(id: requestId).whenComplete(() {
              context.navigateBack();
            });
          },
          isUpdateUi: true,
          isLoaderReq: true,
        );
      },
      positiveButtonTitle: LocalizationHandler.of().deny,
      negativeButtonTitle: LocalizationHandler.of().no,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsentController>(
      builder: (_) {
        return BaseView(
          type: ConsentDetailsView,
          mobileBackgroundColor: AppColors.colorWhite1,
          title:
              '${_request.status?.toTitleCase()} ${LocalizationHandler.of().consentsRequestTitle.toTitleCase()}',
          bodyMobile: ConsentDetailsMobileView(
            arguments: widget.arguments,
            onGrantConsentClick: _onGrantConsentClick,
            onDenyClick: _onDenyClick,
            request: _request,
            consentReqId: consentReqId,
          ),
          bodyDesktop: ConsentDetailsDesktopView(
            arguments: widget.arguments,
            onGrantConsentClick: _onGrantConsentClick,
            onDenyClick: _onDenyClick,
            request: _request,
          ),
        );
      },
    );
  }
}
