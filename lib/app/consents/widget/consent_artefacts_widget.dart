import 'package:abha/app/consents/model/consent_artefact_model.dart';
import 'package:abha/app/consents/widget/consent_linked_providers_selection_widget.dart';
import 'package:abha/export_packages.dart';

class ConsentArtefactsWidget extends StatelessWidget {
  final List<LinkFacilityLinkedData?> links;
  final ConsentArtefactModel consentArtefact;

  const ConsentArtefactsWidget({
    required this.links,
    required this.consentArtefact,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Text(
            LocalizationHandler.of().youHaveGivenAccessTo,
            style: CustomTextStyle.bodySmall(context)?.apply(),
          ).marginOnly(top: Dimen.d_4),
          // Text(
          //   '${LocalizationHandler.of().allLinkedProvider} '
          //   '(${consentArtefact.consentDetail?.permission?.frequency?.value})',
          //   style: CustomTextStyle.bodySmall(context)?.apply(),
          // ),
          Container(
            height: Dimen.d_1,
            width: double.infinity,
            color: AppColors.colorPurple4,
          ),
          if (consentArtefact.consentDetail?.hip != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConsentLinkedProvidersSelectionWidget(
                  header: AppCheckBox(
                    color: AppColors.colorAppBlue,
                    value: true,
                    onChanged: null,
                    title: Text(consentArtefact.consentDetail?.hip?.name ?? ''),
                  ).paddingSymmetric(horizontal: Dimen.d_20),
                  child: Column(
                    children: consentArtefact.consentDetail!.careContexts!
                        .map((careContext) {
                      String hipName =
                          consentArtefact.consentDetail?.hip?.name ?? '';

                      return AppCheckBox(
                        color: AppColors.colorAppBlue,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              careContext.careContextReference ?? '',
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: context.width * 0.5,
                                    child: Text(
                                      '${careContext.patientReference}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        value: true,
                        onChanged: null,
                      ).paddingSymmetric(
                        vertical: Dimen.d_10,
                        horizontal: Dimen.d_30,
                      );
                    }).toList(),
                  ),
                )
              ],
            ).marginOnly(top: Dimen.d_15, bottom: Dimen.d_15)
        ],
        interItemSpace: Dimen.d_20,
        flowHorizontal: false,
      ),
    );
  }

  Column artefactDetailView(LinkFacilityCareContext e, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          e.referenceNumber ?? '',
          style: CustomTextStyle.bodySmall(context),
        ),
        Text(
          e.display ?? '',
          style: CustomTextStyle.bodySmall(context),
        ),
      ],
    );
  }

  Column facilityTitleView(LinkFacilityLinkedData? link, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          link?.hip?.name ?? '',
          style: CustomTextStyle.titleMedium(context),
        ),
        Text(
          link?.referenceNumber ?? '',
          style: CustomTextStyle.titleMedium(context),
        ).marginOnly(top: Dimen.d_10),
      ],
    );
  }
}
