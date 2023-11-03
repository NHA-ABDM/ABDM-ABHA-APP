import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/export_packages.dart';

typedef OnClick = Function(String contentData,String contentType,String urlPath);

class HealthRecordTypeDesktopView extends StatelessWidget {
  final String title;
  late Widget child;
  final Color backgroundColor = AppColors.colorWhiteWildSand;

  HealthRecordTypeDesktopView.condition(
    BuildContext context, {
    required this.title,
    required description,
    super.key,
  }) {
    child = _childContainer(
      Text(
        !Validator.isNullOrEmpty(description) ? description : 'NA',
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorBlack,
          fontWeightDelta: -1,
        ),
      ),
    );
  }

  HealthRecordTypeDesktopView.procedure(
    BuildContext context, {
    required this.title,
    required String? data,
    required String date,
    super.key,
  }) {
    child = _childContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Validator.isNullOrEmpty(data))
            Text(
              data ?? 'NA',
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack,
                fontWeightDelta: -1,
              ),
            )
          else
            const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: WidgetUtility.spreadWidgets(
              [
                Text(
                  LocalizationHandler.of().performedOn,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack,
                    fontWeightDelta: -1,
                  ),
                ),
                Text(
                  Validator.isNullOrEmpty(date) ? 'NA' : date.formatDDMMMMYYYY,
                  textAlign: TextAlign.right,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack,
                  ),
                )
              ],
              interItemSpace: Dimen.d_4,
            ),
          )
        ],
      ),
    );
  }

  HealthRecordTypeDesktopView.document(
    BuildContext context, {
    required this.title,
    required List<ContentAttachmentLocalModel> contentAttachment,
    required OnClick onClick,
    super.key,
  }) {
    child = _childContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: WidgetUtility.spreadWidgets(
          contentAttachment.map((e) {
            return GestureDetector(
              onTap: () {
                onClick(e.contentData ?? '',e.contentType ?? '',e.url ?? '');
              },
              child: Row(
                children: WidgetUtility.spreadWidgets(
                  [
                    const Icon(
                      Icons.document_scanner_rounded,
                      color: AppColors.colorGrey,
                    ),
                    Text(
                      e.title ?? '',
                      style: CustomTextStyle.titleSmall(context)?.apply(
                        color: AppColors.colorBlack,
                      ),
                    ),
                  ],
                  interItemSpace: Dimen.d_6,
                ),
              ),
            );
          }).toList(),
          interItemSpace: Dimen.d_6,
          flowHorizontal: false,
        ),
      ),
    );
  }

  HealthRecordTypeDesktopView.medicationRequest(
      BuildContext context, {
        required this.title,
        required List<String> data,
        super.key,
      }) {
   child =  _childContainer(
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: WidgetUtility.spreadWidgets(
         data.map((e) {
           return Text(
             e.toString().replaceAll('\n ', '\n'),
             style: CustomTextStyle.titleSmall(context)
                 ?.apply(color: AppColors.colorBlack6),
           );
         }).toList(),
         interItemSpace: Dimen.d_6,
         flowHorizontal: false,
       ),
     ),
   );
  }

  HealthRecordTypeDesktopView.allergyIntolerance(
    BuildContext context, {
    required this.title,
    required List<String?>? notes,
    super.key,
  }) {
    child = _childContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: WidgetUtility.spreadWidgets(
          notes!.map((e) {
            return Text(
              e!,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack,
                fontWeightDelta: -1,
              ),
            );
          }).toList(),
          interItemSpace: Dimen.d_6,
          flowHorizontal: false,
        ),
      ),
    );
  }

  HealthRecordTypeDesktopView.diagnosticReport(
    BuildContext context, {
    required this.title,
    required String data,
    required List<PresentedFormLocalModel> presentedForm,
    required OnClick onClick,
    super.key,
  }) {
    child = _childContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        //   Text(
        //     data,
        //     style: CustomTextStyle.titleSmall(context)?.apply(
        //       color: AppColors.colorBlack6,
        //     ),
        //   ),
        // ],
        children: WidgetUtility.spreadWidgets(
          presentedForm.map((e) {
            return GestureDetector(
              onTap: () {
                onClick(e.contentData ?? '', e.contentType ?? '', e.url ?? '');
              },
              child: Row(
                children: WidgetUtility.spreadWidgets(
                  [
                    const Icon(
                      Icons.document_scanner_rounded,
                      color: AppColors.colorGrey,
                    ),
                    Text(
                      data,
                      style: CustomTextStyle.titleSmall(context)?.apply(
                        //color: AppColors.colorBlueLight1
                        color: AppColors.colorBlack6,
                        fontWeightDelta: -1,
                      ),
                    ),
                  ],
                  interItemSpace: Dimen.d_6,
                ),
              ),
            );
          }).toList(),
          interItemSpace: Dimen.d_6,
          flowHorizontal: false,
        ),
      ),
    );
  }

  HealthRecordTypeDesktopView.carePlan(
    BuildContext context, {
    required this.title,
    required String intent,
    required String description,
    required List<DataEntryLocalModel> entry,
    super.key,
  }) {
    child = _childContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: WidgetUtility.spreadWidgets(
          [
            RichText(
              text: TextSpan(
                text: '${LocalizationHandler.of().intent}: ',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack, fontWeightDelta: -1),
                children: <TextSpan>[
                  TextSpan(
                    text: !Validator.isNullOrEmpty(intent) ? intent : 'NA',
                    style: CustomTextStyle.bodySmall(context)
                        ?.apply(color: AppColors.colorBlack),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: '${LocalizationHandler.of().description}: ',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack, fontWeightDelta: -1),
                children: <TextSpan>[
                  TextSpan(
                    text: !Validator.isNullOrEmpty(description)
                        ? description
                        : 'NA',
                    style: CustomTextStyle.bodySmall(context)
                        ?.apply(color: AppColors.colorBlack),
                  ),
                ],
              ),
            ),
            if (entry.isNotEmpty)
              Text(
                LocalizationHandler.of().appointment,
                style: CustomTextStyle.labelLarge(context)?.apply(
                  color: AppColors.colorGreyDark5,
                  fontSizeDelta: -1,
                  fontWeightDelta: -1,
                ),
              ).marginOnly(top: Dimen.d_8)
            else
              const SizedBox(),
            Column(
              children: entry.map((e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: WidgetUtility.spreadWidgets(
                    [
                      RichText(
                        text: TextSpan(
                          text: '${LocalizationHandler.of().startDate}: ',
                          style: CustomTextStyle.bodySmall(context)?.apply(
                            color: AppColors.colorBlack,
                            fontWeightDelta: -1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: e.startDate?.formatDDMMMYYYYHHMMA,
                              style: CustomTextStyle.bodySmall(context)
                                  ?.apply(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${LocalizationHandler.of().endDate}: ',
                          style: CustomTextStyle.bodySmall(context)?.apply(
                            color: AppColors.colorBlack,
                            fontWeightDelta: -1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: e.endDate?.formatDDMMMYYYYHHMMA,
                              style: CustomTextStyle.bodySmall(context)
                                  ?.apply(color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                      )
                    ],
                    interItemSpace: Dimen.d_0,
                    flowHorizontal: false,
                  ),
                ).sizedBox(width: double.infinity);
              }).toList(),
            ).marginOnly(left: Dimen.d_8)
          ],
          interItemSpace: Dimen.d_0,
          flowHorizontal: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthRecordController>(
      id: HealthRecordUpdateUiBuilderIds.healthRecordDetails,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title, style: InputFieldStyleDesktop.labelTextStyle),
            child.sizedBox(width: Dimen.d_300).marginOnly(left: Dimen.d_0, top: Dimen.d_4)
          ],
        );
      },
    ).marginOnly(top: Dimen.d_16);
  }

  Widget _childContainer(Widget child) {
    return Container(
      child: child,
    );
  }
}
