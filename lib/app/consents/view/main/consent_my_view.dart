import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_my_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consent_my_mobile_view.dart';
import 'package:abha/export_packages.dart';

class ConsentMyView extends StatefulWidget {
  final Map arguments;

  const ConsentMyView({required this.arguments, super.key});

  @override
  State<ConsentMyView> createState() => _ConsentMyViewState();
}

class _ConsentMyViewState extends State<ConsentMyView> {
  late ConsentController _consentController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
    _consentController.consentArtefact = [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    await _consentController.functionHandler(
      function: () async {
        // await fetchAndUpdateLinkedFacility();
        await fetchConsentById(); // it must call at last // but I called it first, because we need to first consent details and after thet HIU nad HIP names can be fetched and updated in model
        await fetchAndUpdateHiuDetails();
        await fetchAndUpdateHipDetails();
        await fetchAndUpdateConsentArtifacts();
      },
      isUpdateUi: true,
      isLoaderReq: true,
    );
  }

  Future<void> fetchAndUpdateHiuDetails() async {
    if (!Validator.isNullOrEmpty(_consentController.consentRequest?.hiu)) {
      Map<String, dynamic> providerDetails = await _consentController.fetchProviderDetails(
        _consentController.consentRequest?.hiu?.id ?? '',
      );
      _consentController.consentRequest?.hiu?.name = providerDetails[ApiKeys.responseKeys.identifier][ApiKeys.responseKeys.name];
    }
  }

  Future<void> fetchAndUpdateHipDetails() async {
    if (!Validator.isNullOrEmpty(_consentController.consentRequest?.hip)) {
      Map<String, dynamic> providerDetails = await _consentController.fetchProviderDetails(
        _consentController.consentRequest?.hip?.id ?? '',
      );
      _consentController.consentRequest?.hip?.name = providerDetails[ApiKeys.responseKeys.identifier][ApiKeys.responseKeys.name];
    }
  }

  // Future<void> fetchAndUpdateLinkedFacility() async {
  //   await _consentController.functionHandler(
  //     function: () => _consentController.fetchLinkedFacility(),
  //   );
  // }

  Future<void> fetchAndUpdateConsentArtifacts() async {
    if (_consentController.consentRequest?.status == ConsentStatus.granted) {
      await _consentController.fetchConsentArtifacts(_consentController.consentRequest?.id ?? '');
    }
  }

  Future<void> fetchConsentById() async {
    String consentReqId = widget.arguments[IntentConstant.data];
    await _consentController.fetchConsentRequestById(consentReqId);
    if (_consentController.consentRequest?.status == ConsentStatus.granted) {
      _consentController.consentArtefact = await _consentController.fetchConsentArtifacts(consentReqId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: ConsentMyView,
      mobileBackgroundColor: AppColors.colorWhite1,
      title: LocalizationHandler.of().myConsents.toTitleCase(),
      bodyMobile: ConsentMyMobileView(
        arguments: widget.arguments,
        onClickViewDetails: onClickViewDetails,
        onRevokeClick: onRevokeClick,
      ),
      bodyDesktop: ConsentMyDesktopView(
        arguments: widget.arguments,
        onClickViewDetails: onClickViewDetails,
        onRevokeClick: onRevokeClick,
      ),
    );
  }

  void onRevokeClick(String? consentId) {
    alertDialog(context, consentId);
  }

  void onClickViewDetails(ConsentArtefactModel consentArtefact) {
    context.navigatePush(
      RoutePath.routeConsentDetailsMine,
      arguments: {IntentConstant.data: consentArtefact},
    );
  }

  /// @Here function used to show pop up for revoking the artefacts.
  /// Params used [context] of type BuildContext and [requestID]
  /// of type String.
  void alertDialog(BuildContext context, String? requestID) {
    CustomDialog.showPopupDialog(
      LocalizationHandler.of().deletingConsent,
      title: LocalizationHandler.of().doYouWantToDeleteIt,
      positiveButtonTitle: LocalizationHandler.of().yes,
      negativeButtonTitle: LocalizationHandler.of().no,
      onPositiveButtonPressed: () async {
        _consentController.functionHandler(
          function: () async {
            await _consentController.revokeConsent(requestID!).whenComplete(() async {
              context.navigateBack();
              _consentController.consentArtefact = [];
              await fetchData().whenComplete(() {
                var data = _consentController.consentArtefact;
                if (Validator.isNullOrEmpty(data)) {
                  context.navigateBack();
                }
              });

            });
          },
          isLoaderReq: true,
        );
      },
      onNegativeButtonPressed: CustomDialog.dismissDialog,
    );
  }
}
