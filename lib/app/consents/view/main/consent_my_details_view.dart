import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_my_details_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consent_my_details_mobile_view.dart';
import 'package:abha/export_packages.dart';

class ConsentMyDetailsView extends StatefulWidget {
  final Map arguments;

  const ConsentMyDetailsView({required this.arguments, super.key});

  @override
  State<ConsentMyDetailsView> createState() => _ConsentMyDetailsViewState();
}

class _ConsentMyDetailsViewState extends State<ConsentMyDetailsView> {
  late ConsentArtefactModel _consentArtefact;
  late ConsentController _consentController;

  @override
  void initState() {
    _consentArtefact = widget.arguments[IntentConstant.data];
    _init();
    super.initState();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    await _consentController.functionHandler(
      function: () async {
        await fetchAndUpdateHiuDetails();
        await fetchAndUpdateHipDetails();
      },
      isUpdateUi: true,
      isLoaderReq: true,
    );
  }

  Future<void> fetchAndUpdateHiuDetails() async {
    if (!Validator.isNullOrEmpty(_consentArtefact.consentDetail?.hiu)) {
      Map<String, dynamic> providerDetails =
          await _consentController.fetchProviderDetails(
        _consentArtefact.consentDetail?.hiu?.id ?? '',
      );
      _consentArtefact.consentDetail?.hiu?.name =
          providerDetails[ApiKeys.responseKeys.identifier]
              [ApiKeys.responseKeys.name];
    }
  }

  Future<void> fetchAndUpdateHipDetails() async {
    if (!Validator.isNullOrEmpty(_consentArtefact.consentDetail?.hip)) {
      Map<String, dynamic> providerDetails =
          await _consentController.fetchProviderDetails(
        _consentArtefact.consentDetail?.hip?.id ?? '',
      );
      _consentArtefact.consentDetail?.hip?.name =
          providerDetails[ApiKeys.responseKeys.identifier]
              [ApiKeys.responseKeys.name];
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: ConsentMyDetailsView,
      title: '${_consentArtefact.status?.capitalize()} '
          '${LocalizationHandler.of().consentsRequestTitle.toTitleCase()}',
      bodyMobile: ConsentMyDetailsMobileView(consentArtefact: _consentArtefact),
      bodyDesktop:
          ConsentMyDetailsDesktopView(consentArtefact: _consentArtefact),
    );
  }
}
