// import 'dart:html';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/expanded/custom_expanded_view.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';
import 'package:flutter/gestures.dart';
// import 'package:google_maps/google_maps.dart' as gMap;

class SupportDesktopView extends StatefulWidget {
  const SupportDesktopView({Key? key}) : super(key: key);

  @override
  State<SupportDesktopView> createState() => _SupportDesktopViewState();
}

class _SupportDesktopViewState extends State<SupportDesktopView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          _titleContactUsWidget(), // title contact us
          _addressAndContactBoxWidget(), // address and contact
          // _faqDetailsExpandedWidget() // Faq details in Expandable widget
        ],
        interItemSpace: Dimen.d_20,
        flowHorizontal: false,
      ),
    ).paddingSymmetric(vertical: Dimen.d_50, horizontal: context.width * 0.10);
  }

  Widget _titleContactUsWidget() {
    return Text(
      LocalizationHandler.of().contactUs,
      style: CustomTextStyle.displayMedium(context)?.apply(
        color: AppColors.colorAppBlue,
        fontWeightDelta: 1,
        fontSizeDelta: 4,
      ),
    );
  }

  Widget _addressAndContactBoxWidget() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        width: 0,
        color: AppColors.colorAppBlue1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.colorWhite,
                      size: Dimen.d_18,
                    ).marginOnly(right: Dimen.d_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationHandler.of().addres.toUpperCase(),
                            style: CustomTextStyle.titleMedium(context)
                                ?.apply(color: AppColors.colorWhite),
                          ).marginOnly(bottom: Dimen.d_10),
                          Text(
                            LocalizationHandler.of().detailAddress,
                            style: CustomTextStyle.titleMedium(context)?.apply(
                              color: AppColors.colorWhite,
                              fontWeightDelta: -1,
                              heightDelta: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ).marginOnly(bottom: Dimen.d_24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone,
                      color: AppColors.colorWhite,
                      size: Dimen.d_18,
                    ).marginOnly(right: Dimen.d_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationHandler.of().contactUs.toUpperCase(),
                            style: CustomTextStyle.titleMedium(context)
                                ?.apply(color: AppColors.colorWhite),
                          ).marginOnly(bottom: Dimen.d_10),
                          Text(
                            LocalizationHandler.of().tollFreeNoWeb,
                            style: CustomTextStyle.titleMedium(context)?.apply(
                              color: AppColors.colorWhite,
                              fontWeightDelta: -1,
                              heightDelta: 0.5,
                            ),
                          ).marginOnly(bottom: Dimen.d_4),
                          Text(
                            LocalizationHandler.of().contactEmail,
                            style: CustomTextStyle.titleMedium(context)?.apply(
                              color: AppColors.colorWhite,
                              fontWeightDelta: -1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ).marginOnly(bottom: Dimen.d_32),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: DecoratedBox(
              decoration: abhaSingleton.getBorderDecoration
                  .getRectangularBorder(width: 0),
              child: RichText(
                text: TextSpan(
                  text: LocalizationHandler.of().contactUsNote,
                  style: CustomTextStyle.titleMedium(context)?.apply(
                    color: AppColors.colorAppBlue1,
                    heightDelta: 0.5,
                  ),
                  children: [
                    TextSpan(
                      text: ' https://grievance.abdm.gov.in ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          LaunchURLServiceImpl().openInAppWebView(
                            context,
                            title: LocalizationHandler.of()
                                .grievancePortal
                                .toTitleCase(),
                            url: AbdmUrlConstant.getGrievancePortal(),
                          );
                        },
                      style: CustomTextStyle.titleMedium(context)
                          ?.apply(color: AppColors.colorAppOrange),
                    ),
                    TextSpan(
                      text: LocalizationHandler.of()
                          .andRegisterYourGrievancesThere,
                      style: CustomTextStyle.titleMedium(context)
                          ?.apply(color: AppColors.colorAppBlue1),
                    ),
                  ],
                ),
              ).paddingSymmetric(vertical: Dimen.d_30, horizontal: Dimen.d_30),
            ),
          )
        ],
      ).paddingSymmetric(vertical: Dimen.d_30, horizontal: Dimen.d_30),
    );
  }

  Widget _faqDetailsExpandedWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationHandler.of().support,
                style: CustomTextStyle.titleLarge(context)
                    ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: -1),
              ).marginOnly(bottom: Dimen.d_10),
              Text(
                LocalizationHandler.of().faqs,
                style: CustomTextStyle.displayMedium(context)?.apply(
                  color: AppColors.colorAppBlue,
                  fontWeightDelta: 1,
                  fontSizeDelta: 4,
                ),
              ).marginOnly(bottom: Dimen.d_20),
              Text(
                LocalizationHandler.of().everythingYouNeedToKnow,
                style: CustomTextStyle.labelLarge(context)
                    ?.apply(color: AppColors.colorGreyDark4, heightDelta: 0.5),
              ).marginOnly(bottom: Dimen.d_20),
            ],
          ),
        ),
        SizedBox(width: Dimen.d_50),
        const Expanded(
          flex: 3,
          child: CustomExpandedView(),
        )
      ],
    );
  }
}
