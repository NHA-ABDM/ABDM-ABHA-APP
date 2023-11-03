import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LinkUnlinkConfirmMobileView extends StatefulWidget {
  final LinkUnlinkController linkUnlinkController;
  //final String actionType;

  const LinkUnlinkConfirmMobileView({
    required this.linkUnlinkController,
    // required this.actionType,
    super.key,
  });

  @override
  LinkUnlinkConfirmMobileViewState createState() =>
      LinkUnlinkConfirmMobileViewState();
}

class LinkUnlinkConfirmMobileViewState
    extends State<LinkUnlinkConfirmMobileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _confirmWidget())
        : _confirmWidget();
  }

  Widget _confirmWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.linkUnlinkController.actionType == StringConstants.deLink)
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  abhaSingleton.getAppData.getUserName(),
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    fontWeightDelta: 2,
                    color: AppColors.colorAppBlue,
                  ),
                ),
                Text(
                  LocalizationHandler.of().linkUnlinkConfirmPageMsg_2(
                    abhaSingleton.getAppData.getAbhaNumber(),
                    abhaSingleton.getAppData.getAbhaAddress(),
                  ),
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    heightDelta: 0.5,
                    color: AppColors.colorBlack6,
                  ),
                ).marginOnly(top: Dimen.d_25).centerWidget,
                // Text(
                //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg} ${abhaSingleton.getAppData.getAbhaNumber()} '
                //   '${widget.actionType} ${abhaSingleton.getAppData.getAbhaAddress()} '
                //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg_3}',
                //   style: CustomTextStyle.bodyLarge(context)?.apply(
                //     fontSizeDelta: -2,
                //     heightDelta: 0.5,
                //     color: AppColors.colorBlack6,
                //   ),
                // ).marginOnly(top: Dimen.d_25),
                Text(
                  LocalizationHandler.of().abhaNoNotVisibleOnProfile,
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    heightDelta: 0.5,
                    color: AppColors.colorBlack4,
                  ),
                ).marginOnly(top: Dimen.d_25),
              ],
            ).paddingAll(Dimen.d_20),
          )
        else
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSvgImageView(
                  ImageLocalAssets.successfulTickIconSvg,
                  width: Dimen.d_40,
                  height: Dimen.d_40,
                ).alignAtCenter(),
                Text(
                  LocalizationHandler.of().congratulations,
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    fontWeightDelta: 2,
                    color: AppColors.colorGreenDark2,
                  ),
                ).marginOnly(top: Dimen.d_24).alignAtCenter(),
                Text(
                  LocalizationHandler.of().linkUnlinkConfirmPageMsg(
                    abhaSingleton.getAppData.getAbhaNumber(),
                    abhaSingleton.getAppData.getAbhaAddress(),
                  ),
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    color: AppColors.colorBlack6,
                  ),
                ).marginOnly(top: Dimen.d_25).centerWidget,
                // Text(
                //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg()} ${abhaSingleton.getAppData.getAbhaNumber()} '
                //   '${widget.actionType} ${abhaSingleton.getAppData.getAbhaAddress()} '
                //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg_4}',
                //   style: CustomTextStyle.bodyLarge(context)?.apply(
                //     fontSizeDelta: -2,
                //     color: AppColors.colorBlack6,
                //   ),
                // ).marginOnly(top: Dimen.d_25).centerWidget,
                Text(
                  LocalizationHandler.of().abhaNoVisibleOnProfile,
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    fontSizeDelta: -2,
                    color: AppColors.colorBlack4,
                  ),
                ).marginOnly(top: Dimen.d_25),
              ],
            ).paddingAll(Dimen.d_20),
          ),
        if (kIsWeb)
          SizedBox(
            height: Dimen.d_20,
          )
        else
          const Expanded(child: SizedBox()),
        TextButtonOrange.mobile(
          text: LocalizationHandler.of().go_to_profile,
          onPressed: () {
            context.navigateBack();
          },
        ).alignAtCenter().marginOnly(top: Dimen.d_50, bottom: Dimen.d_16),
      ],
    );
  }
}
