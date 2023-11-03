import 'package:abha/localization/localization_handler.dart';
import 'package:abha/reusable_widget/gradient/gradient_background.dart';
import 'package:abha/utils/common/dimes.dart';
import 'package:abha/utils/constants/assets_constants.dart';
import 'package:abha/utils/extensions/extension.dart';
import 'package:abha/utils/theme/app_colors.dart';
import 'package:abha/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class AppIntroScreenMobileView extends StatefulWidget {
  const AppIntroScreenMobileView({super.key});

  @override
  AppIntroScreenMobileViewState createState() =>
      AppIntroScreenMobileViewState();
}

class AppIntroScreenMobileViewState extends State<AppIntroScreenMobileView> {
  List<ContentConfig> slides = [];

  late Function goToTab;

  @override
  void initState() {
    super.initState();
  }

  /// @Here is the initSliderValues() generated the sliders and add it into [List<ContentConfig> slides]
  /// Each slide contains [_title], [description] and [pathImage]
  void initSliderValues() {
    for (int i = 0; i < 5; i++) {
      String title = '';
      String description = '';
      String pathImage = '';
      if (i == 0) {
        title = LocalizationHandler.of().intro1_title;
        description = LocalizationHandler.of().intro1_desc;
        pathImage = ImageLocalAssets.abhaAppIntro1;
      } else if (i == 1) {
        title = LocalizationHandler.of().intro2_title;
        description = LocalizationHandler.of().intro2_desc;
        pathImage = ImageLocalAssets.abhaAppIntro2;
      } else if (i == 2) {
        title = LocalizationHandler.of().intro3_title;
        description = LocalizationHandler.of().intro3_desc;
        pathImage = ImageLocalAssets.abhaAppIntro3;
      } else if (i == 3) {
        title = LocalizationHandler.of().intro4_title;
        description = LocalizationHandler.of().intro4_desc;
        pathImage = ImageLocalAssets.abhaAppIntro4;
      } else {
        title = LocalizationHandler.of().intro5_title;
        description = LocalizationHandler.of().intro5_desc;
        pathImage = ImageLocalAssets.abhaAppIntro5;
      }
      slides.add(
        ContentConfig(
          title: title,
          styleTitle: CustomTextStyle.headlineSmall(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 1,
          ),
          description: description,
          styleDescription: CustomTextStyle.titleLarge(context)?.apply(
            fontWeightDelta: -1,
            fontSizeDelta: -2,
            heightDelta: 0.5,
          ),
          pathImage: pathImage,
        ),
      );
    }
  }

  /// renderListCustomTabs() it returns a list of Widgets containing the slider data
  List<Widget> renderListCustomTabs() {
    initSliderValues();
    return List.generate(
      slides.length,
      (index) => ListView(
        shrinkWrap: true,
        children: <Widget>[
          GradientBackground(
            child: Image.asset(
              slides[index].pathImage!,
              width: (index != 0) ? Dimen.d_350 : null,
              height: context.height * 0.5,
              fit: BoxFit.contain,
            ).centerWidget,
          ),
          Text(
            slides[index].title!,
            style: slides[index].styleTitle,
          ).marginOnly(left: Dimen.d_17, right: Dimen.d_17, top: Dimen.d_10),
          Text(
            slides[index].description!,
            style: slides[index].styleDescription,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ).marginOnly(left: Dimen.d_17, right: Dimen.d_17, top: Dimen.d_10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _introSliderWidget();
  }

  Widget _introSliderWidget() {
    return IntroSlider(
      // Indicator
      indicatorConfig: IndicatorConfig(
        sizeIndicator: Dimen.d_20,
        indicatorWidget: Container(
          width: Dimen.d_20,
          height: Dimen.d_10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.colorGreyLight2,
          ),
        ),
        activeIndicatorWidget: Container(
          width: Dimen.d_40,
          height: Dimen.d_10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.colorAppBlue,
          ),
        ),
        spaceBetweenIndicator: Dimen.d_20,
        typeIndicatorAnimation: TypeIndicatorAnimation.sliding,
      ),
      listCustomTabs: renderListCustomTabs(),
      isAutoScroll: true,
      isLoopAutoScroll: true,
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
      },
      isShowSkipBtn: false,
      isShowNextBtn: false,
      isShowDoneBtn: false,
      isShowPrevBtn: false,
      scrollPhysics: const BouncingScrollPhysics(),
    );
  }
}
