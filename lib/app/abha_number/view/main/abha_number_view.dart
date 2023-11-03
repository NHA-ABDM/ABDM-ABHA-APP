import 'package:abha/app/abha_number/view/desktop/abha_number_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/abha_number_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberView extends StatefulWidget {
  const AbhaNumberView({super.key});

  @override
  AbhaNumberViewState createState() => AbhaNumberViewState();
}

class AbhaNumberViewState extends State<AbhaNumberView> {
  final AbhaNumberController _abhaNumberController =
      Get.put(AbhaNumberController(AbhaNumberRepoImpl()));
  String _aadhaarNumber = '';
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _abhaNumberController.aadhaarNumberTextController.clear();
    DeleteControllers().deleteAbhaNumber();
    super.dispose();
  }

  void _isAadhaarValid() {
    _aadhaarNumber = _abhaNumberController.aadhaarNumberTextController.text
        .replaceAll('-', '');
    if (!Validator.isAadhaarValid(_aadhaarNumber)) {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidAadhaarNumber);
    } else if (!_abhaNumberController.aadhaarDecelerationCheckBox) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().userInformationAgreementError,
      );
    } else {
      _abhaNumberController.aadhaarNumber = _aadhaarNumber;
      _abhaNumberController.aadhaarNumberTextController.clear();
      _abhaNumberController.isButtonEnable = ValueNotifier(false);
      _abhaNumberController.aadhaarDecelerationCheckBox = false;
      _abhaNumberController.stopSpeech();
      context.navigatePush(RoutePath.routeAbhaNumberOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().createAbhaNumber,
      type: AbhaNumberView,
      paddingValueMobile: Dimen.d_0,
      webBackgroundColor: AppColors.colorBlueLight8,
      bodyMobile: AbhaNumberMobileView(
        isAadhaarValid: _isAadhaarValid,
      ),
      bodyDesktop: AbhaNumberDesktopView(
        isAadhaarValid: _isAadhaarValid,
      ),
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }
}
