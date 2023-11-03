import 'package:abha/app/link_unlink/view/widget/common_link_unlink_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class UnLinkAbhaNumberDesktopView extends StatefulWidget {
  final void Function(String? value) checkOnValidationTypeClick;
  final VoidCallback onAbhaNumberSearch;
  final LinkUnlinkController linkUnlinkController;
  final ValueNotifier<bool> isButtonEnable;

  const UnLinkAbhaNumberDesktopView({
    required this.checkOnValidationTypeClick,
    required this.onAbhaNumberSearch,
    required this.linkUnlinkController,
    required this.isButtonEnable,
    super.key,
  });

  @override
  UnLinkAbhaNumberDesktopViewState createState() =>
      UnLinkAbhaNumberDesktopViewState();
}

class UnLinkAbhaNumberDesktopViewState
    extends State<UnLinkAbhaNumberDesktopView> {
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
    return CustomDrawerDesktopView(
      widget: _unLinkParentWidget(),
    );
  }

  Widget _unLinkParentWidget() {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().unlinkAbhaNumber,
          style: CustomTextStyle.titleLarge(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 2,
          ),
        ).alignAtTopLeft().marginOnly(bottom: Dimen.d_20),
        CommonBackgroundCard(
          child: CommonLinkUnlinkWidget(
            image: ImageLocalAssets.unlinkAbhaNumberSvg,
            child: _unLinkWidget(),
          ),
        )
      ],
    ).marginAll(
      Dimen.d_20,
    );
  }

  Widget _unLinkWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textTitle(LocalizationHandler.of().unLinkAbhaNumberMsg),
        _textTitle(
          '${LocalizationHandler.of().unLinkAbhaNumberMsg_1(abhaSingleton.getAppData.getAbhaNumber(), abhaSingleton.getAppData.getAbhaAddress())} ',
          // '${abhaSingleton.getAppData.getAbhaNumber()} '
          // '${LocalizationHandler.of().unLinkAbhaNumberMsg_2} '
          // '${abhaSingleton.getAppData.getAbhaAddress()} ?',
        ).marginOnly(top: Dimen.d_10),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  key: const Key(KeyConstant.continueBtn),
                  text: LocalizationHandler.of().continuee,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    context.navigatePush(
                      RoutePath.routeUnlinkAbhaNumberValidator,
                    );
                  },
                ).marginOnly(top: Dimen.d_30);
              },
            ),
            TextButtonPurple.desktop(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(
              left: Dimen.d_20,
              right: Dimen.d_20,
              top: Dimen.d_30,
            )
          ],
        ),
      ],
    );
  }

  /// @Here common widget to display the text.
  Widget _textTitle(String msg) {
    return Text(
      msg,
      style: CustomTextStyle.bodyMedium(context)?.apply(
        color: AppColors.colorBlack4,
        fontWeightDelta: -1,
        fontSizeDelta: -2,
        heightDelta: 0.3,
      ),
    );
  }
}
