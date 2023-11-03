import 'package:abha/app/app_intro/view/desktop/app_intro_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/expanded/custom_expanded_view.dart';
import 'package:flutter/gestures.dart';

class AppIntroWebMobileView extends StatefulWidget {
  const AppIntroWebMobileView({Key? key}) : super(key: key);

  @override
  State<AppIntroWebMobileView> createState() => _AppIntroWebMobileViewState();
}

class _AppIntroWebMobileViewState extends State<AppIntroWebMobileView> {
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
      children: [topView(context), middleView(context), bottomView(context)],
    );
  }

  Container topView(BuildContext context) {
    return Container(
      color: AppColors.colorPurple4,
      padding:
          EdgeInsets.symmetric(vertical: Dimen.d_20, horizontal: Dimen.d_40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocalizationHandler.of().createABHAAccount,
            style: CustomTextStyle.bodyLarge(context)?.apply(
              color: AppColors.colorAppBlue1,
              fontSizeDelta: Dimen.d_18,
              fontWeightDelta: 2,
            ),
          ).marginOnly(top: Dimen.d_10),
          Text(
            '${LocalizationHandler.of().your} ${LocalizationHandler.of().digitalHealthJourney} ${LocalizationHandler.of().beginsHere.toTitleCase()}\n\n${LocalizationHandler.of().abhaAddress}',
            style: CustomTextStyle.bodyLarge(context)?.apply(
              color: AppColors.colorAppBlue1,
              fontWeightDelta: 1,
              fontSizeDelta: 1,
            ),
          ).marginOnly(top: Dimen.d_10),
          Text(
            LocalizationHandler.of().web_intro_ans2,
            style: CustomTextStyle.labelLarge(context)?.apply(
              fontWeightDelta: -1,
              heightDelta: 0.5,
            ),
          ).marginOnly(top: Dimen.d_10),
          TextButtonOrange.mobile(
            text: LocalizationHandler.of().createAbhaAddress,
            onPressed: () {
              context.navigatePush(RoutePath.routeRegistration);
            },
          ).marginOnly(top: Dimen.d_40),
          RichText(
            text: TextSpan(
              text: LocalizationHandler.of().alreadyHaveABHAAddress,
              style: CustomTextStyle.labelLarge(context)
                  ?.apply(fontWeightDelta: -1),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${LocalizationHandler.of().login}',
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
          ).marginOnly(top: Dimen.d_10),
        ],
      ).marginOnly(right: Dimen.d_24),
    );
  }

  Container middleView(BuildContext context) {
    return Container(
      color: AppColors.colorAppBlue1,
      padding: EdgeInsets.symmetric(
        vertical: Dimen.d_80,
        horizontal: context.width * 0.1,
      ),
      child: Column(
        children: [
          Text(
            LocalizationHandler.of().whatCanYouDoWithYourABHAApplication,
            style: CustomTextStyle.bodyMedium(context)?.apply(
              fontSizeDelta: 2,
              color: AppColors.colorWhite,
            ),
          ).marginOnly(bottom: Dimen.d_40),
          Wrap(
            spacing: Dimen.d_10,
            runSpacing: Dimen.d_10,
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
                  assetImage: ImageLocalAssets.easySharingHealthRecordsIconSvg,
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
          )
        ],
      ),
    );
  }

  Container bottomView(BuildContext context) {
    return Container(
      color: AppColors.colorWhite,
      padding: EdgeInsets.symmetric(
        vertical: Dimen.d_40,
        horizontal: context.width * 0.06,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().faqs,
            style: CustomTextStyle.bodyLarge(context)?.apply(
              color: AppColors.colorAppBlue1,
              fontWeightDelta: 1,
              fontSizeDelta: 4,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          Text(
            LocalizationHandler.of().everythingYouNeedToKnow,
            style: CustomTextStyle.labelLarge(context)?.apply(
              color: AppColors.colorGreyDark4,
              heightDelta: 0.5,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  CustomExpandedView(
                    dataList: _dataList,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _infoContainer(
    BuildContext context,
    String title,
    String description, {
    String? assetImage,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimen.d_24),
      decoration: BoxDecoration(
        color: AppColors.colorPurple4,
        borderRadius: BorderRadius.circular(Dimen.d_12),
      ),
      child: Column(
        children: [
          if (assetImage != null)
            SvgPicture.asset(
              assetImage,
              height: Dimen.d_64,
              width: Dimen.d_64,
            )
          else
            Image.asset(
              ImageLocalAssets.abhaLogo,
              height: Dimen.d_64,
              width: Dimen.d_64,
            ),
          SizedBox(
            // height: Dimen.d_40,
            child: Text(
              title,
              style: CustomTextStyle.labelLarge(context)?.apply(
                color: AppColors.colorAppBlue1,
                fontWeightDelta: 1,
              ),
            ).marginOnly(top: Dimen.d_10, bottom: Dimen.d_10),
          ),
          Text(
            description,
            style: CustomTextStyle.labelLarge(context)?.apply(
              color: AppColors.colorGreyDark4,
              fontWeightDelta: -1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
