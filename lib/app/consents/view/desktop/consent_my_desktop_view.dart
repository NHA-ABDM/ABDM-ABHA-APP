import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/button/custom/text_button_custom.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class ConsentMyDesktopView extends StatefulWidget {
  final Map arguments;
  final Function(ConsentArtefactModel model) onClickViewDetails;
  final Function(String? consentId) onRevokeClick;

  const ConsentMyDesktopView({
    required this.arguments,
    required this.onClickViewDetails,
    required this.onRevokeClick,
    super.key,
  });

  @override
  State<ConsentMyDesktopView> createState() => _ConsentMyDesktopViewState();
}

class _ConsentMyDesktopViewState extends State<ConsentMyDesktopView> {
  late ConsentController _consentController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _consentController = Get.find<ConsentController>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().myConsents.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          myConsentsView(),
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget myConsentsView() {
    return GetBuilder<ConsentController>(
      builder: (_) {
        var data = _consentController.consentArtefact;
        List<ConsentArtefactModel> consentArtefactData =
            data is List<ConsentArtefactModel> ? data : [];
        return (Validator.isNullOrEmpty(consentArtefactData))
            ? const SizedBox.shrink()
            : artefactsListWidget(consentArtefactData);
      },
    );
  }

  Widget artefactsListWidget(List<ConsentArtefactModel>? consentArtefacts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableHeaderView(
          children: [
            Expanded(
              flex: 2,
              child: getTitleText(LocalizationHandler.of().requester),
            ),
            Expanded(
              flex: 2,
              child: getTitleText(LocalizationHandler.of().hiu),
            ),
            Expanded(
              flex: 3,
              child: getTitleText(LocalizationHandler.of().purposeOfRequest),
            ),
            Expanded(
              flex: 2,
              child: getTitleText(LocalizationHandler.of().hipType),
            ),
            Expanded(
              flex: 2,
              child: getTitleText(LocalizationHandler.of().last_updated),
            ),
            Expanded(
              flex: 2,
              child: getTitleText(LocalizationHandler.of().action),
            ),
          ],
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: consentArtefacts?.length,
            itemBuilder: (context, index) {
              ConsentArtefactModel model =
                  consentArtefacts?[index] ?? ConsentArtefactModel();
              model.consentDetail?.hiu?.name =
                  _consentController.consentRequest?.hiu?.name;

              return TableRowView(
                onClick: () {
                  widget.onClickViewDetails(model);
                },
                backgroundColor: (index % 2 == 0)
                    ? AppColors.colorWhite
                    : AppColors.colorPurple4,
                children: [
                  Expanded(
                    flex: 2,
                    child: getValueText(
                      model.consentDetail?.requester?.name ?? '-',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: getValueText(model.consentDetail?.hiu?.name ?? '-'),
                  ),
                  Expanded(
                    flex: 3,
                    child: getValueText(
                      model.consentDetail?.purpose?.text ?? '-',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: getValueText(model.consentDetail?.hip?.name ?? '-'),
                  ),
                  Expanded(
                    flex: 2,
                    child: getValueText(
                      model.consentDetail?.lastUpdated
                              ?.calculatePastTime(utc: false) ??
                          '-',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: (model.status == ConsentStatus.granted)
                        ? TextButtonCustom(
                            height: Dimen.d_30,
                            backgroundColor: AppColors.colorRed,
                            textColor: AppColors.colorWhite,
                            leadingIconColor: AppColors.colorWhite,
                            leadingIconSize: 18,
                            text: LocalizationHandler.of().revoke,
                            fontSizeDelta: -2.0,
                            leadingIcon: Icons.settings_backup_restore,
                            onPressed: () {
                              widget.onRevokeClick(
                                model.consentDetail?.consentId,
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// @Here widget shows the information i.e is dateRange (from and to date).
  /// Params used [consentArtefact] of type ConsentArtefact.
  Widget informationRequestWidget(ConsentArtefactModel consentArtefact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().informationRequest,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '${LocalizationHandler.of().from} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text:
                    '${consentArtefact.consentDetail?.permission?.dateRange?.from?.formatDDMMMMYYYY}',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontSizeDelta: -3,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text: ' ${LocalizationHandler.of().to} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
              TextSpan(
                text:
                    '${consentArtefact.consentDetail?.permission?.dateRange?.to?.formatDDMMMMYYYY} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontSizeDelta: -3,
                  fontWeightDelta: 2,
                ),
              ),
            ],
          ),
        ).marginOnly(top: Dimen.d_4),
      ],
    ).marginOnly(top: Dimen.d_15, left: Dimen.d_20, right: Dimen.d_20);
  }

  /// @Here common widget to display the text.
  /// Params used [title] of type String.
  Widget titleView(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelMedium(context)
          ?.apply(color: AppColors.colorGreyLight6, fontSizeDelta: 2),
    );
  }

  Widget getTitleText(String text) {
    return Text(
      text,
      maxLines: 2,
      style: CustomTextStyle.bodySmall(
        context,
      )?.apply(color: AppColors.colorWhite),
    );
  }

  Widget getValueText(String text) {
    return Text(
      text,
      maxLines: 2,
      style: CustomTextStyle.bodySmall(context)?.apply(
        color: AppColors.colorBlack,
        fontWeightDelta: -1,
      ),
    );
  }
}
