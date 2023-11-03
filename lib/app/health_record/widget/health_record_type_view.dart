import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/export_packages.dart';

typedef OnClick = Function(String contentData,String contentType,String url);

class HealthRecordTypeView extends StatelessWidget {
  final HealthRecordController _healthRecordController =
      Get.find<HealthRecordController>();
  final String title;
  final List<Widget> _children = [];
  final Color backgroundColor = AppColors.colorWhiteWildSand;
  final bool _isExpand = false;

  HealthRecordTypeView.condition(
    BuildContext context, {
    required this.title,
    required description,
    super.key,
  }) {
    _children.add(
      _childContainer(
        Text(
          '• $description',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorBlack6),
        ),
      ),
    );
  }

  HealthRecordTypeView.composition(
      BuildContext context, {
        required this.title,
        required String data,
        super.key,
      }) {
    _children.add(
      _childContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: CustomTextStyle.bodySmall(context)?.apply(
                // color: AppColors.colorGreyDark2,
                color: AppColors.colorBlack6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  HealthRecordTypeView.procedure(
    BuildContext context, {
    required this.title,
    required String data,
    required String date,
    super.key,
  }) {
    _children.add(
      _childContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: CustomTextStyle.bodySmall(context)?.apply(
                // color: AppColors.colorGreyDark2,
                color: AppColors.colorBlack6,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: WidgetUtility.spreadWidgets(
                [
                  Text(
                    LocalizationHandler.of().performedOn,
                    style: CustomTextStyle.titleSmall(context)?.apply(
                      //color: AppColors.colorGreyDark2,
                      color: AppColors.colorBlack6,
                      fontSizeDelta: -1,
                      fontWeightDelta: 1,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Validator.isNullOrEmpty(date)
                          ? date
                          : date.formatDDMMMMYYYY,
                      textAlign: TextAlign.right,
                      style: CustomTextStyle.titleSmall(context)?.apply(
                        //color: AppColors.colorGreyDark2,
                        color: AppColors.colorBlack6,
                        fontSizeDelta: -1,
                        fontWeightDelta: 1,
                      ),
                    ),
                  )
                ],
                interItemSpace: Dimen.d_20,
                flowHorizontal: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  HealthRecordTypeView.document(
    BuildContext context, {
    required this.title,
    required List<ContentAttachmentLocalModel> contentAttachment,
    required OnClick onClick,
    super.key,
  }) {
    _children.add(
      _childContainer(
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
                        IconAssets.documentScanneRounded,
                        color: AppColors.colorGrey,
                      ),
                      Text(
                        e.title ?? '',
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
      ),
    );
  }

  HealthRecordTypeView.medicationRequest(
    BuildContext context, {
    required this.title,
        required List<String> data,
    super.key,
  }) {
    _children.add(
      _childContainer(
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
      ),
    );
  }

  HealthRecordTypeView.allergyIntolerance(
    BuildContext context, {
    required this.title,
    required List<String?>? notes,
    super.key,
  }) {
    _children.add(
      _childContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: WidgetUtility.spreadWidgets(
            notes!.map((e) {
              return Text(
                e ?? '',
                style: CustomTextStyle.titleSmall(context)
                    ?.apply(color: AppColors.colorBlack6),
              );
            }).toList(),
            interItemSpace: Dimen.d_6,
            flowHorizontal: false,
          ),
        ),
      ),
    );
  }

  HealthRecordTypeView.diagnosticReport(
    BuildContext context, {
    required this.title,
    required String data,
    required List<PresentedFormLocalModel> presentedForm,
    required OnClick onClick,
    super.key,
  }) {
    _children.add(
      _childContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          //   Text(
          //     data,
          //     style: CustomTextStyle.titleSmall(context)?.apply(
          //       color: AppColors.colorBlack6,
          //       fontWeightDelta: -1,
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
                        IconAssets.documentScanneRounded,
                        color: AppColors.colorGrey,
                      ),
                      Text(
                        data,
                        style: CustomTextStyle.titleSmall(context)?.apply(
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
      ),
    );
  }

  HealthRecordTypeView.carePlan(
    BuildContext context, {
    required this.title,
    required String intent,
    required String description,
    required List<DataEntryLocalModel> entry,
    super.key,
  }) {
    _children.add(
      _childContainer(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: WidgetUtility.spreadWidgets(
            [
              RichText(
                text: TextSpan(
                  text: '${LocalizationHandler.of().intent} :',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorGreyDark2,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: intent),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${LocalizationHandler.of().description} :',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorGreyDark2,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: description),
                  ],
                ),
              ),
              Text(LocalizationHandler.of().appointment),
              Column(
                children: entry.map((e) {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: WidgetUtility.spreadWidgets(
                        [
                          RichText(
                            text: TextSpan(
                              text: '${LocalizationHandler.of().startDate}: ',
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                color: AppColors.colorGreyDark2,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: e.startDate?.formatDDMMMYYYYHHMMA,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${LocalizationHandler.of().endDate}:',
                              style: CustomTextStyle.bodySmall(context)?.apply(
                                color: AppColors.colorGreyDark2,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: e.endDate?.formatDDMMMYYYYHHMMA),
                              ],
                            ),
                          ),
                          Text(LocalizationHandler.of().comments)
                        ],
                        interItemSpace: Dimen.d_14,
                        flowHorizontal: false,
                      ),
                    ),
                  ).paddingSymmetric(
                    vertical: Dimen.d_10,
                    horizontal: Dimen.d_10,
                  );
                }).toList(),
              )
            ],
            interItemSpace: Dimen.d_14,
            flowHorizontal: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthRecordController>(
      id: HealthRecordUpdateUiBuilderIds.healthRecordDetails,
      builder: (_) {
        return Container(
          decoration: abhaSingleton.getBorderDecoration.getElevation(
            isLow: true,
            color: AppColors.colorWhite,
            borderColor:
                _isExpand ? AppColors.colorAppBlue : AppColors.colorGreyLight6,
          ),
          margin: EdgeInsets.symmetric(
            vertical: Dimen.d_4,
          ),
          child: ExpansionTile(
            onExpansionChanged: (value) {
              // _isExpand = value;
              _healthRecordController.functionHandler(
                isUpdateUi: true,
                updateUiBuilderIds: [
                  HealthRecordUpdateUiBuilderIds.healthRecordDetails
                ],
              );
            },
            textColor: AppColors.colorGreyDark,
            title: Text(
              title,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark2,
                fontWeightDelta: 2,
                fontSizeDelta: -2,
              ),
            ),
            trailing: !_isExpand
                ? const Icon(
                    IconAssets.navigateNext,
                    color: AppColors.colorGrey3,
                  )
                : const Icon(
                    IconAssets.navigateDown,
                    color: AppColors.colorGrey3,
                  ),
            children: _children,
          ),
        );
      },
    );
  }

  Widget _childContainer(Widget child) {
    return SizedBox(
      width: double.infinity,
      child: child.paddingOnly(
        bottom: Dimen.d_20,
        left: Dimen.d_15,
        right: Dimen.d_15,
      ),
    );
  }
}
