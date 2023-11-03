import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/expanded/custom_expanded_view.dart';
import 'package:flutter/gestures.dart';

class ExpandModel {
  String title = '';
  String desc = '';
}

class AppIntroDesktopView extends StatefulWidget {
  const AppIntroDesktopView({Key? key}) : super(key: key);

  @override
  State<AppIntroDesktopView> createState() => _AppIntroDesktopViewState();
}

class _AppIntroDesktopViewState extends State<AppIntroDesktopView> {
  final List<ExpandModel> _dataList = [];

  @override
  void initState() {
    super.initState();
  }

  void prepData() {
    _dataList.clear();
    for (int i = 0; i < 5; i++) {
      ExpandModel expandModel = ExpandModel();
      if (i == 0) {
        expandModel.title = LocalizationHandler.of().web_intro_question2;
        expandModel.desc = LocalizationHandler.of().web_intro_ans2;
      } else if (i == 1) {
        expandModel.title = LocalizationHandler.of().web_intro_question3;
        expandModel.desc = LocalizationHandler.of().web_intro_ans3;
      } else if (i == 2) {
        expandModel.title = LocalizationHandler.of().web_intro_question4;
        expandModel.desc = LocalizationHandler.of().web_intro_ans4;
      } else if (i == 3) {
        expandModel.title = LocalizationHandler.of().web_intro_question1;
        expandModel.desc = LocalizationHandler.of().web_intro_ans1;
      } else if (i == 4) {
        expandModel.title = LocalizationHandler.of().web_intro_question5;
        expandModel.desc = LocalizationHandler.of().web_intro_ans5;
      }
      _dataList.add(expandModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    prepData();
    return Column(
      children: [topView(context), _middleView(context), _bottomView(context)],
    );
  }

  Widget topView(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorPurple4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: WidgetUtility.spreadWidgets(
                [
                  Text(
                    LocalizationHandler.of().createABHAAccount,
                    style: CustomTextStyle.bodyLarge(context)?.apply(
                      color: AppColors.colorAppBlue1,
                      fontSizeDelta: Dimen.d_18,
                      fontWeightDelta: 2,
                    ),
                  ),
                  Text(
                    '${LocalizationHandler.of().your} ${LocalizationHandler.of().digitalHealthJourney} ${LocalizationHandler.of().beginsHere.toTitleCase()}\n\n${LocalizationHandler.of().abhaAddress}',
                    style: CustomTextStyle.bodyLarge(context)?.apply(
                      color: AppColors.colorAppBlue1,
                      fontWeightDelta: 1,
                      fontSizeDelta: 1,
                    ),
                  ),
                  Text(
                    '${LocalizationHandler.of().web_intro_ans2}.',
                    style: CustomTextStyle.labelLarge(context)?.apply(
                      fontWeightDelta: -1,
                      heightDelta: 0.5,
                    ),
                  ),
                  TextButtonOrange.desktop(
                    text: LocalizationHandler.of().createAbhaAddress,
                    onPressed: () {
                      context.navigatePush(RoutePath.routeRegistration);
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      text:
                          '${LocalizationHandler.of().alreadyHaveABHAAddress} ',
                      style: CustomTextStyle.labelLarge(context)
                          ?.apply(fontWeightDelta: -1),
                      children: <TextSpan>[
                        TextSpan(
                          text: LocalizationHandler.of().login,
                          style: CustomTextStyle.labelLarge(context)?.apply(
                            color: AppColors.colorAppOrange,
                            fontWeightDelta: 1,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.navigatePush(RoutePath.routeLogin);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
                interItemSpace: Dimen.d_20,
                flowHorizontal: false,
              ),
            ).marginOnly(right: Dimen.d_50),
          ),
          Expanded(
            flex: 2,
            child: CustomSvgImageView(
              ImageLocalAssets.webIntro1,
              height: Dimen.d_250,
            ),
          )
        ],
      ).paddingSymmetric(
        vertical: Dimen.d_20,
        horizontal: context.width * 0.10,
      ),
    );
  }

  Widget _bottomView(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorWhite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHandler.of().faqs,
                  style: CustomTextStyle.displayMedium(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 1,
                    fontSizeDelta: 4,
                    heightDelta: 0.1,
                  ),
                ).marginOnly(bottom: Dimen.d_20),
                Text(
                  LocalizationHandler.of().everythingYouNeedToKnow,
                  style: CustomTextStyle.labelLarge(context)?.apply(
                    color: AppColors.colorGreyDark4,
                    heightDelta: 0.5,
                  ),
                ).marginOnly(bottom: Dimen.d_20),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: CustomExpandedView(dataList: _dataList)
                .marginOnly(left: Dimen.d_50),
          )
        ],
      ).paddingSymmetric(
        vertical: Dimen.d_30,
        horizontal: context.width * 0.10,
      ),
    );
  }

  Widget _middleView(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorAppBlue1,
      child: Column(
        children: [
          Text(
            LocalizationHandler.of().whatCanYouDoWithYourABHAApplication,
            style: CustomTextStyle.displaySmall(context)?.apply(
              fontSizeDelta: 2,
              color: AppColors.colorWhite,
            ),
          ).marginOnly(bottom: Dimen.d_40),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: WidgetUtility.spreadWidgets(
                [
                  _infoContainer(
                    context,
                    LocalizationHandler.of().paperlessManagement,
                    LocalizationHandler.of().web_intro1,
                    assetImage: ImageLocalAssets.paperlessManagementIconSvg,
                  ),
                  _infoContainer(
                    context,
                    LocalizationHandler.of().continuumOfCare,
                    LocalizationHandler.of().web_intro2,
                    assetImage: ImageLocalAssets.continuumOfCareIconSvg,
                  ),
                  _infoContainer(
                    context,
                    LocalizationHandler.of().uniqueIdentityViaABHANumber,
                    LocalizationHandler.of().web_intro3,
                    assetImage: ImageLocalAssets.uniqueIdentityIconSvg,
                  ),
                  _infoContainer(
                    context,
                    LocalizationHandler.of().easySharingOfHealthRecords,
                    LocalizationHandler.of().web_intro4,
                    assetImage:
                        ImageLocalAssets.easySharingHealthRecordsIconSvg,
                  ),
                  _infoContainer(
                    context,
                    LocalizationHandler.of().consentBasedSharingAndLinking,
                    LocalizationHandler.of().web_intro5,
                    assetImage: ImageLocalAssets.consentBasedLinking,
                  ),
                ],
                interItemSpace: Dimen.d_14,
              ),
            ),
          )
        ],
      ).paddingSymmetric(
        vertical: Dimen.d_30,
        horizontal: context.width * 0.10,
      ),
    );
  }

  Widget _infoContainer(
    BuildContext context,
    String title,
    String description, {
    String? assetImage,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(Dimen.d_12),
        ),
        child: Column(
          children: [
            if (assetImage != null)
              CustomSvgImageView(
                assetImage,
                height: Dimen.d_64,
                width: Dimen.d_64,
              ).marginOnly(bottom: Dimen.d_24)
            else
              Image.asset(
                ImageLocalAssets.abhaLogo,
                height: Dimen.d_64,
                width: Dimen.d_64,
              ).marginOnly(bottom: Dimen.d_24),
            Text(
              title,
              style: CustomTextStyle.labelLarge(context)
                  ?.apply(color: AppColors.colorAppBlue1, fontSizeDelta: 1),
              textAlign: TextAlign.center,
            ).marginOnly(bottom: Dimen.d_5),
            Text(
              description,
              style: CustomTextStyle.labelLarge(context)?.apply(
                color: AppColors.colorBlack,
                heightDelta: Dimen.d_0_5,
                fontSizeDelta: -1,
                fontWeightDelta: -1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ).paddingAll(Dimen.d_24),
      ),
    );
  }
}
