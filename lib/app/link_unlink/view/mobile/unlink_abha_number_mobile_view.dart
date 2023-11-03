import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class UnLinkAbhaNumberMobileView extends StatefulWidget {
  final void Function(String? value) checkOnValidationTypeClick;
  final VoidCallback onAbhaNumberSearch;
  final LinkUnlinkController linkUnlinkController;

  const UnLinkAbhaNumberMobileView({
    required this.checkOnValidationTypeClick,
    required this.onAbhaNumberSearch,
    required this.linkUnlinkController,
    super.key,
  });

  @override
  UnLinkAbhaNumberMobileViewState createState() =>
      UnLinkAbhaNumberMobileViewState();
}

class UnLinkAbhaNumberMobileViewState
    extends State<UnLinkAbhaNumberMobileView> {
  late LinkUnlinkController _linkUnlinkController;

  @override
  void initState() {
    _linkUnlinkController = widget.linkUnlinkController;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _unLinkWidget())
        : _unLinkWidget();
  }

  Widget _unLinkWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().unlinkAbhaNumber,
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).alignAtCenter().marginSymmetric(
                vertical: Dimen.d_20,
                horizontal: Dimen.d_20,
              ),
        _textTitle(LocalizationHandler.of().unLinkAbhaNumberMsg),
        _textTitle(
          '${LocalizationHandler.of().unLinkAbhaNumberMsg_1(abhaSingleton.getAppData.getAbhaNumber(), abhaSingleton.getAppData.getAbhaAddress())} ',
          // '${abhaSingleton.getAppData.getAbhaNumber()} '
          // '${LocalizationHandler.of().unLinkAbhaNumberMsg_2} '
          // '${abhaSingleton.getAppData.getAbhaAddress()} ?',
        ).marginOnly(top: Dimen.d_20),
        GetBuilder<LinkUnlinkController>(
          id: LinkUnlinkUpdateUiBuilderIds.radioToggle,
          builder: (_) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: _selectRadioOption(
                    key: const Key(KeyConstant.radio1),
                    value: StringConstants.yes,
                    groupValue: _linkUnlinkController.selectedValidationMethod,
                    onChanged: widget.checkOnValidationTypeClick,
                    title: LocalizationHandler.of().yes,
                  ),
                ),
                Flexible(
                  child: _selectRadioOption(
                    key: const Key(KeyConstant.radio2),
                    value: StringConstants.no,
                    groupValue: _linkUnlinkController.selectedValidationMethod,
                    onChanged: widget.checkOnValidationTypeClick,
                    title: LocalizationHandler.of().no,
                  ),
                )
              ],
            );
          },
        ).marginOnly(top: Dimen.d_20),
        TextButtonOrange.mobile(
          text: LocalizationHandler.of().continuee,
          onPressed: () {
            widget.onAbhaNumberSearch();
          },
        ).marginOnly(
          top: Dimen.d_30,
        ),
      ],
    ).paddingSymmetric(vertical: Dimen.d_16, horizontal: Dimen.d_16);
  }

  Widget _selectRadioOption({
    required String value,
    required String groupValue,
    required String title,
    required void Function(String?)? onChanged,
    Key? key,
  }) {
    return Row(
      children: [
        Radio(
          key: key,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          title,
          style: CustomTextStyle.bodyLarge(context)?.apply(),
        ).paddingAll(Dimen.d_10),
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
      ),
    );
  }
}
