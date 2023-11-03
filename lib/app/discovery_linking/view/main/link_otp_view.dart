import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/view/desktop/link_otp_desktop_view.dart';
import 'package:abha/app/discovery_linking/view/mobile/link_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:flutter/foundation.dart';

class LinkOtpView extends StatefulWidget {
  final Map arguments;

  const LinkOtpView({required this.arguments, super.key});

  @override
  LinkOtpViewState createState() => LinkOtpViewState();
}

class LinkOtpViewState extends State<LinkOtpView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  late Map _hipDataToConfirm;

  @override
  void initState() {
    super.initState();
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    _hipDataToConfirm = widget.arguments[IntentConstant.data];
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here function verifies the entered otp on text field.
  /// Otp value is verified by calling api by passing the entered otp value and
  /// referenceNumber of hip Data.
  Future<void> _onOtpVerify(String otpValue) async {
    String referenceNumber = _hipDataToConfirm[ApiKeys.requestKeys.link]
        [ApiKeys.requestKeys.referenceNumber];
    if (Validator.isOtpValid(otpValue)) {
      _discoveryLinkingController.getLinkConfirmHip(
        otpValue,
        referenceNumber,
        (responseModel) => _getLinkHipConfirmOnResponse(responseModel),
      );
      // _discoveryLinkingController.functionHandler(
      //   function: () => _discoveryLinkingController.getLinkConfirmHip(
      //     otpValue,
      //     referenceNumber,
      //   ),
      //   isLoaderReq: true,
      // ).then((value) {
      //   if (_discoveryLinkingController.responseHandler.status == Status.success) {
      //     _showConfirmDialog();
      //   }
      // });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  Future<void> _getLinkHipConfirmOnResponse(
    ApiSocketLocalResponseModel responseModel,
  ) async {
    _showConfirmDialog();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().linkMyHealthRecord,
      type: LinkOtpView,
      bodyMobile: LinkOtpMobileView(onOtpVerify: _onOtpVerify),
      bodyDesktop: LinkOtpDesktopView(onOtpVerify: _onOtpVerify),
    );
  }

  void _showConfirmDialog() {
    context.openDialog(
      CustomSimpleDialog(
        paddingLeft: Dimen.d_5,
        child: Column(
          children: [
            CustomSvgImageView(
              ImageLocalAssets.successfulTickIconSvg,
              width: Dimen.d_40,
              height: Dimen.d_40,
            ),
            Text(
              LocalizationHandler.of().linkHipSuccess,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack6,
                fontWeightDelta: 2,
              ),
            ).marginOnly(
              top: Dimen.d_20,
              left: Dimen.d_40,
              right: Dimen.d_40,
            ),
            TextButtonOrange.desktop(
              text: LocalizationHandler.of().viewMyRecords,
              onPressed: () {
                context.navigateBack();
                kIsWeb
                    ? context.navigatePush(RoutePath.routeLinkFacility)
                    : context.navigateBack(result: true);
              },
            ).marginAll(
              Dimen.d_50,
            ),
          ],
        ),
      ),
    );
  }
}
