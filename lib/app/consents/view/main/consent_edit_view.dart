import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/view/desktop/consent_edit_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consent_edit_mobile_view.dart';
import 'package:abha/export_packages.dart';

class ConsentEditView extends StatefulWidget {
  const ConsentEditView({super.key});

  @override
  State<ConsentEditView> createState() => _ConsentEditViewState();
}

class _ConsentEditViewState extends State<ConsentEditView> {
  late ConsentController _consentController;
  late DateTime? fromDate;
  late DateTime? toDate;
  late DateTime? expiryDate;
  late TimeOfDay? expiryTime;
  // List<HealthInfoTypes> tempSelectHiTypes = [];
  bool isValidRequest = false;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    ConsentRequestModel? request = _consentController.consentRequest;
    fromDate = DateTime.parse(request?.permission?.dateRange?.from ?? '');
    toDate = DateTime.parse(request?.permission?.dateRange?.to ?? '');
    expiryDate = DateTime.parse(request?.permission?.dataEraseAt ?? '');
    expiryTime =
        TimeOfDay(hour: expiryDate?.hour ?? 0, minute: expiryDate?.minute ?? 0);
    // tempSelectHiTypes = request?.hiTypes
    //         ?.map((element) => HealthInfoTypes.copy(element))
    //         .toList() ??
    //     [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: ConsentEditView,
      title: LocalizationHandler.of().consentsRequestTitle.toTitleCase(),
      bodyDesktop: ConsentEditDesktopView(onSaveClick: onSaveClick),
      bodyMobile: ConsentEditMobileView(onSaveClick: onSaveClick),
    );
  }

  bool validateHipTypeInfo(List<HealthInfoTypes> tempSelectHiTypes) {
    bool isInfoTypeSelected =
        tempSelectHiTypes.where((element) => element.check).toList().isNotEmpty;
    bool isProvidersSelected = _consentController.selectedHipContextCount() > 0;
    bool isLinkedProvidersSelected = _consentController.selectedLinkedHipContextCount() > 0;
    if (!isInfoTypeSelected) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().selectAleastOneHipType,
      );
      return false;
    }

    if (!isProvidersSelected && !isLinkedProvidersSelected) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().selectAleastOneHipFacility,
      );
      return false;
    }
    return true;
  }

  void onSaveClick(
    List<HealthInfoTypes> tempSelectHiTypes,
    bool isValidRequest,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? expiryDate,
    TimeOfDay? expiryTime,
  ) {
    if (!validateHipTypeInfo(tempSelectHiTypes)) {
      return;
    }
    if (isValidRequest) {
      _consentController.consentRequest?.permission?.dateRange?.from =
          fromDate?.toIso8601String();

      _consentController.consentRequest?.permission?.dateRange?.to =
          toDate?.toIso8601String();

      _consentController.consentRequest?.permission?.dataEraseAt = DateTime(
        expiryDate?.year ?? 1999,
        expiryDate?.month ?? 1,
        expiryDate?.day ?? 1,
        expiryTime?.hour ?? 00,
        expiryTime?.minute ?? 00,
      ).toIso8601String();

      _consentController.consentRequest?.hiTypes?.clear();
      for (var element in tempSelectHiTypes) {
        element.check;
      }

      _consentController.consentRequest?.hiTypes?.addAll(tempSelectHiTypes);

      context.navigateBack();
    }
  }
}
