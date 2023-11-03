import 'package:abha/export_packages.dart';

class LinkUnlinkConfirmDesktopView extends StatefulWidget {
  final LinkUnlinkController linkUnlinkController;
  // final String actionType;

  const LinkUnlinkConfirmDesktopView({
    required this.linkUnlinkController,
    //required this.actionType,
    super.key,
  });

  @override
  LinkUnlinkConfirmDesktopViewState createState() =>
      LinkUnlinkConfirmDesktopViewState();
}

class LinkUnlinkConfirmDesktopViewState
    extends State<LinkUnlinkConfirmDesktopView> {
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
    return _confirmWidget();
  }

  Widget _confirmWidget() {
    return Column(
      children: [
        if (widget.linkUnlinkController.actionType == StringConstants.deLink)
          _abhaNumberDelinkMessageWidget()
        else
          _abhaNumberLinkMessageWidget(),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().go_to_home,
          onPressed: () {
            context.navigateBack();
          },
        ).marginOnly(top: Dimen.d_40, bottom: Dimen.d_15),
      ],
    ).paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20);
  }

  Widget _abhaNumberLinkMessageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSvgImageView(
          ImageLocalAssets.successfulTickIconSvg,
          width: Dimen.d_50,
          height: Dimen.d_50,
        ).alignAtCenter(),
        Text(
          LocalizationHandler.of().congratulations,
          style: CustomTextStyle.bodyLarge(context)?.apply(
            fontSizeDelta: -2,
            fontWeightDelta: 2,
            color: AppColors.colorGreenDark2,
          ),
        ).marginOnly(top: Dimen.d_20).alignAtCenter(),
        Text(
          LocalizationHandler.of().linkUnlinkConfirmPageMsg(
            abhaSingleton.getAppData.getAbhaNumber(),
            abhaSingleton.getAppData.getAbhaAddress(),
          ),
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontSizeDelta: -2,
            color: AppColors.colorBlack6,
          ),
        ).marginOnly(top: Dimen.d_25),
        // Text(
        //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg} ${abhaSingleton.getAppData.getAbhaNumber()} \n'
        //   '${widget.actionType} ${abhaSingleton.getAppData.getAbhaAddress()} '
        //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg_4}; \n${LocalizationHandler.of().abhaNoVisibleOnProfile}',
        //   // textAlign: TextAlign.center,
        //   style: CustomTextStyle.bodySmall(context)?.apply(
        //     fontSizeDelta: -2,
        //     color: AppColors.colorBlack6,
        //   ),
        // ).marginOnly(top: Dimen.d_25),
        Text(
          LocalizationHandler.of().abhaNoVisibleOnProfile,
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontSizeDelta: -2,
            color: AppColors.colorBlack4,
          ),
        ).marginOnly(
          top: Dimen.d_10,
        ),
      ],
    );
  }

  Widget _abhaNumberDelinkMessageWidget() {
    return Column(
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
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontSizeDelta: -2,
            heightDelta: 0.3,
            color: AppColors.colorBlack6,
          ),
        ).marginOnly(top: Dimen.d_20),
        // Text(
        //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg} ${abhaSingleton.getAppData.getAbhaNumber()} \n'
        //   '${widget.actionType} ${abhaSingleton.getAppData.getAbhaAddress()} '
        //   '${LocalizationHandler.of().linkUnlinkConfirmPageMsg_3}; \n${LocalizationHandler.of().abhaNoNotVisibleOnProfile}',
        //   style: CustomTextStyle.bodySmall(context)?.apply(
        //     fontSizeDelta: -2,
        //     heightDelta: 0.3,
        //     color: AppColors.colorBlack6,
        //   ),
        // ).marginOnly(top: Dimen.d_20),
        Text(
          LocalizationHandler.of().abhaNoNotVisibleOnProfile,
          style: CustomTextStyle.bodySmall(context)?.apply(
            fontSizeDelta: -2,
            heightDelta: 0.5,
            color: AppColors.colorBlack4,
          ),
        ).marginOnly(top: Dimen.d_10),
      ],
    );
  }
}
