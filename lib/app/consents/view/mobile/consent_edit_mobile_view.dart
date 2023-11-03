import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/widget/consent_edit_checkbox_widget.dart';
import 'package:abha/app/consents/widget/consent_linked_providers_selection_widget.dart';
import 'package:abha/export_packages.dart';

class ConsentEditMobileView extends StatefulWidget {
  final Function(
    List<HealthInfoTypes> tempSelectHiTypes,
    bool isValidRequest,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? expiryDate,
    TimeOfDay? expiryTime,
  ) onSaveClick;

  const ConsentEditMobileView({required this.onSaveClick, super.key});

  @override
  State<ConsentEditMobileView> createState() => _ConsentEditMobileViewState();
}

class _ConsentEditMobileViewState extends State<ConsentEditMobileView> {
  late ConsentController _consentController;
  late DateTime? fromDate;
  late DateTime? toDate;
  late DateTime? expiryDate;
  late TimeOfDay? expiryTime;
  List<HealthInfoTypes> tempSelectHiTypes = [];
  bool isValidRequest = false;

  @override
  void initState() {
    _consentController = Get.find<ConsentController>();
    ConsentRequestModel? request = _consentController.consentRequest;
    fromDate = DateTime.parse(request?.permission?.dateRange?.from ?? '');
    toDate = DateTime.parse(request?.permission?.dateRange?.to ?? '');
    expiryDate = DateTime.parse(request?.permission?.dataEraseAt ?? '');
    expiryTime =
        TimeOfDay(hour: expiryDate?.hour ?? 0, minute: expiryDate?.minute ?? 0);

    tempSelectHiTypes = request?.hiTypes
            ?.map((element) => HealthInfoTypes.copy(element))
            .toList() ??
        [];
    validateRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return consentEditMobileView();
  }

  Widget consentEditMobileView() {
    return GetBuilder<ConsentController>(
      builder: (_) {
        ConsentRequestModel? request = _consentController.consentRequest;
        if (request != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: WidgetUtility.spreadWidgets(
              [
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: DecoratedBox(
                      decoration:
                          abhaSingleton.getBorderDecoration.getElevation(
                        borderColor: AppColors.colorGrey4,
                        color: AppColors.colorWhite,
                        isLow: true,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: WidgetUtility.spreadWidgets(
                          [
                            requesterNameWidget(request)
                                .paddingSymmetric(horizontal: Dimen.d_15),
                            requestPurposeWidget(request)
                                .paddingSymmetric(horizontal: Dimen.d_15),
                            informationRequestWidget(request)
                                .paddingSymmetric(horizontal: Dimen.d_15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleView(
                                  LocalizationHandler.of()
                                      .informationRequestTypes,
                                  AppColors.colorGreyLight6,
                                ).paddingSymmetric(horizontal: Dimen.d_15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: healthInfoTypesView(request),
                                ).marginOnly(top: Dimen.d_12)
                              ],
                            ),
                            consentExpiryWidget()
                                .paddingSymmetric(horizontal: Dimen.d_15),
                            providersListWidget()
                                .paddingSymmetric(horizontal: Dimen.d_15),
                          ],
                          interItemSpace: Dimen.d_18,
                          flowHorizontal: false,
                        ),
                      ),
                    ),
                  ),
                ),
                buttonSaveConsent(request).sizedBox(width: context.width)
              ],
              interItemSpace: Dimen.d_18,
              flowHorizontal: false,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget requesterNameWidget(ConsentRequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(request.requester?.name ?? '', AppColors.colorGreyLight6),
        Text(
          request.hiu?.name ?? '',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_4),
      ],
    ).marginOnly(top: Dimen.d_20);
  }

  Widget requestPurposeWidget(ConsentRequestModel request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(
          LocalizationHandler.of().purposeOfRequest,
          AppColors.colorGreyLight6,
        ),
        Text(
          request.purpose?.text ?? '',
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(top: Dimen.d_4),
      ],
    );
  }

  Widget informationRequestWidget(ConsentRequestModel? request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          titleView(
            LocalizationHandler.of().informationRequest,
            AppColors.colorGreyLight6,
          ),
          Row(
            children: [
              _informationRequestFromDate(),
              _informationRequestToDate()
            ],
          ),
        ],
        interItemSpace: Dimen.d_10,
        flowHorizontal: false,
      ),
    );
  }

  /// Here Widget function displays the 'From' Date of Consent.
  Widget _informationRequestFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(LocalizationHandler.of().from, AppColors.colorBlack6)
            .marginOnly(bottom: Dimen.d_5),
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorAppOrange,
            color: AppColors.colorWhite,
            size: Dimen.d_5,
            //isLow: true,
          ),
          child: GestureDetector(
            onTap: () async {
              DateTime? tempDate = await datePicker(fromDate, null, today());

              setState(() {
                if (tempDate != null) {
                  fromDate = tempDate;
                }
              });
              validateRequest();
            },
            child: iconTextRowWidget(
              fromDate!.formatDOMMYYYY,
              ImageLocalAssets.calendarFrom,
            ),
          ),
        ),
      ],
    );
  }

  /// Here Widget function displays the 'To' Date of Consent.
  Widget _informationRequestToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(LocalizationHandler.of().to, AppColors.colorBlack6)
            .marginOnly(bottom: Dimen.d_5),
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorAppOrange,
            color: AppColors.colorWhite,
            size: Dimen.d_5,
            //isLow: true,
          ),
          child: GestureDetector(
            onTap: () async {
              DateTime? from =
                  (toDate!.isBefore(fromDate!)) ? toDate : fromDate;
              DateTime? tempDate = await datePicker(toDate, from, null);
              setState(() {
                if (tempDate != null) {
                  if (toDate!.isBefore(fromDate!)) {
                    CustomDialog.showPopupDialog(
                      LocalizationHandler.of().toDateCanNotLes,
                      onPositiveButtonPressed: () {
                        CustomDialog.dismissDialog();
                      },
                      backDismissible: false,
                    );
                  } else {
                    toDate = tempDate;
                  }
                }
              });
              validateRequest();
            },
            child: iconTextRowWidget(
              toDate!.formatDOMMYYYY,
              ImageLocalAssets.calendarTo,
            ),
          ),
        )
      ],
    ).marginOnly(left: Dimen.d_12, right: Dimen.d_12);
  }

  /// Here Widget to show expired consent date and time.
  Widget consentExpiryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          titleView(
            LocalizationHandler.of().consent_expiry,
            AppColors.colorGreyLight6,
          ),
          Row(
            children: [
              _consentExpiryDate(),
              _consentExpiryTime(),
            ],
          )
        ],
        interItemSpace: Dimen.d_12,
        flowHorizontal: false,
      ),
    );
  }

  /// This widget shows the date of consent will expired.
  Widget _consentExpiryDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(LocalizationHandler.of().date, AppColors.colorBlack6)
            .marginOnly(bottom: Dimen.d_5),
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorAppOrange,
            color: AppColors.colorWhite,
            size: Dimen.d_5,
            //isLow: true,
          ),
          child: GestureDetector(
            onTap: () async {
              DateTime? tempDate =
                  await datePicker(expiryDate, DateTime.now(), null);

              setState(() {
                if (tempDate != null) {
                  expiryDate = tempDate;
                }
              });
              validateRequest();
            },
            child: iconTextRowWidget(
              expiryDate!.formatDDMMMMYYYY,
              ImageLocalAssets.calendarTo,
            ),
          ),
        )
      ],
    );
  }

  /// This widget shows the time of consent will expired.
  Widget _consentExpiryTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleView(LocalizationHandler.of().time, AppColors.colorBlack6)
            .marginOnly(bottom: Dimen.d_5),
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorAppOrange,
            color: AppColors.colorWhite,
            size: Dimen.d_5,
          ),
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: expiryTime ??
                    const TimeOfDay(
                      hour: 0,
                      minute: 0,
                    ),
              );

              setState(() {
                if (time != null) {
                  expiryTime = time;
                }
              });
              validateRequest();
            },
            child: iconTextRowWidget(
              expiryTime?.format(context) ?? '',
              ImageLocalAssets.time,
            ),
          ),
        )
      ],
    ).marginOnly(left: Dimen.d_15, right: Dimen.d_15);
  }

  /// This is common widget for icon and text in Row.
  Widget iconTextRowWidget(String text, String icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: CustomTextStyle.bodySmall(context)?.apply(fontSizeDelta: -2),
        ),
        SvgPicture.asset(
          icon,
          width: Dimen.d_25,
        ).marginOnly(left: Dimen.d_15, right: Dimen.d_15),
      ],
    ).paddingSymmetric(horizontal: Dimen.d_8, vertical: Dimen.d_8);
  }

  Widget providersListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().healthDataShare,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorBlack1),
        ).marginSymmetric(horizontal: Dimen.d_10),
        if (_consentController.consentRequest?.hip != null &&
            !Validator.isNullOrEmpty(
              _consentController.consentRequest?.careContexts,
            ))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConsentLinkedProvidersSelectionWidget(
                header: AppCheckBox(
                  color: AppColors.colorAppBlue,
                  value: _consentController
                          .selectedHipContext[
                              _consentController.consentRequest?.hip?.name]
                          ?.length ==
                      _consentController.consentRequest?.careContexts.length,
                  onChanged: (value) {
                    setState(() {
                      String hipName =
                          _consentController.consentRequest?.hip?.name ?? '';
                      if (value == true) {
                        _consentController.selectedHipContext[hipName]?.addAll(
                          _consentController.consentRequest?.careContexts ?? [],
                        );
                      } else {
                        _consentController.selectedHipContext[hipName]?.clear();
                      }
                    });
                    validateRequest();
                  },
                  title:
                      Text(_consentController.consentRequest?.hip?.name ?? ''),
                ).paddingSymmetric(horizontal: Dimen.d_20),
                child: Column(
                  children: _consentController.consentRequest!.careContexts
                      .map((careContext) {
                    String hipName =
                        _consentController.consentRequest?.hip?.name ?? '';

                    bool selected = _consentController
                            .selectedHipContext[hipName]
                            ?.contains(careContext) ??
                        false;
                    // bool selected =  false;
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
                      value: selected,
                      onChanged: (value) {
                        setState(() {
                          String hipName =
                              _consentController.consentRequest?.hip?.name ??
                                  '';
                          if (value == false) {
                            _consentController.selectedHipContext[hipName]
                                ?.remove(careContext);
                          } else {
                            _consentController.selectedHipContext[hipName]
                                ?.add(careContext);
                          }
                        });
                        validateRequest();
                      },
                    ).paddingSymmetric(
                      vertical: Dimen.d_10,
                      horizontal: Dimen.d_30,
                    );
                  }).toList(),
                ),
              )

              // AppCheckBox(
              //   color: AppColors.colorAppBlue,
              //   value: _consentController.allHipContextSelected(),
              //   onChanged: (value) {
              //     setState(() {
              //       // if (value == true) {
              //       //   _consentController.selectedHipContext.forEach((key, value) {
              //       //     value.clear();
              //       //   });
              //       //   for (final element in _consentController.linksFacilityData) {
              //       //     _consentController.selectedHipContext[element?.hip?.name]?.addAll(
              //       //       element?.careContexts ?? [],
              //       //     );
              //       //   }
              //       // } else {
              //       //   _consentController.selectedHipContext.forEach((key, value) {
              //       //     value.clear();
              //       //   });
              //       // }
              //     });
              //     validateRequest();
              //   },
              //   title: const Text('ALL'),
              // ).paddingAll(Dimen.d_10),
              // Column(
              //   children: _consentController.consentRequest!.careContexts!.map((link) {
              //     return hipExpandableView(link);
              //   }).toList(),
              // ).marginOnly(bottom: Dimen.d_15)
            ],
          ).marginOnly(top: Dimen.d_15, bottom: Dimen.d_15),
        if (!Validator.isNullOrEmpty(_consentController.consentRequest?.links))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppCheckBox(
              //   color: AppColors.colorAppBlue,
              //   value: _consentController.allHipContextSelected(),
              //   onChanged: (value) {
              //     setState(() {
              //       if (value == true) {
              //         _consentController.selectedHipContext
              //             .forEach((key, value) {
              //           value.clear();
              //         });
              //         // for (final element in _consentController.consentRequest.links) {
              //         //   _consentController
              //         //       .selectedHipContext[element.hip?.name]
              //         //       ?.addAll(
              //         //     element?.careContexts ?? [],
              //         //   );
              //         // }
              //       } else {
              //         _consentController.selectedHipContext
              //             .forEach((key, value) {
              //           value.clear();
              //         });
              //       }
              //     });
              //     validateRequest();
              //   },
              //   title: const Text('ALL'),
              // ).paddingAll(Dimen.d_10),
              if (!Validator.isNullOrEmpty(
                _consentController.consentRequest?.links,
              ))
                Column(
                  children:
                      _consentController.consentRequest!.links!.map((link) {
                    return hipExpandableView(link);
                  }).toList(),
                ).marginOnly(bottom: Dimen.d_15),
            ],
          ),
        // if (_consentController.linksFacilityData.isEmpty)
        //   Text(
        //     LocalizationHandler.of().hipNotLinkPleaseLink,
        //     style: CustomTextStyle.labelMedium(context)
        //         ?.apply(color: AppColors.colorRed),
        //   ).paddingAll(Dimen.d_10),
      ],
    );
  }

  /// @Here function displays the list of HiTypes. Params used:-
  ///   [consents] of type Requests.
  List<Widget> healthInfoTypesView(ConsentRequestModel consents) {
    return tempSelectHiTypes.map((e) {
      return ConsentEditCheckBoxWidget(
        title: Text(
          e.name!.convertPascalCaseString,
          style: CustomTextStyle.bodyLarge(
            context,
          )?.copyWith(
            fontSize: Dimen.d_16,
            color: AppColors.colorBlack,
            fontWeight: FontWeight.normal,
          ),
        ),
        value: e.check,
        iconEnabledWidget: SvgPicture.asset(
          'assets/images/${e.name}.svg',
          height: Dimen.d_35,
          width: Dimen.d_18,
        ).marginOnly(left: Dimen.d_24, right: Dimen.d_24),
        iconDisabledWidget: SvgPicture.asset(
          'assets/images/${e.name}_disabled.svg',
          height: Dimen.d_35,
          width: Dimen.d_18,
        ).marginOnly(left: Dimen.d_24, right: Dimen.d_24),
        onTap: () {
          setState(() {
            if (e.check) {
              e.check = false;
            } else {
              e.check = true;
            }
            validateRequest();
          });
        },
        onChanged: (value) {
          /// set the boolean into object 'e' of type HealthInfoTypes
          /// on selecting or unselecting of HiTypes.
          setState(() {
            if (e.check) {
              e.check = false;
            } else {
              e.check = true;
            }
            validateRequest();
          });
        },
      ).marginSymmetric(horizontal: Dimen.d_15);
    }).toList();
  }

  Widget hipExpandableView(LinkFacilityLinkedData? link) {
    String? hipName = link?.hip?.name;
    List<LinkFacilityCareContext> careContexts = link?.careContexts ?? [];
    bool allContextSelected =
        _consentController.linkFacilityHipContext[hipName]?.length ==
            careContexts.length;
    return ConsentLinkedProvidersSelectionWidget(
      header: AppCheckBox(
        color: AppColors.colorAppBlue,
        value: allContextSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _consentController.linkFacilityHipContext[hipName]
                  ?.addAll(careContexts);
            } else {
              _consentController.linkFacilityHipContext[hipName]?.clear();
            }
          });
          validateRequest();
        },
        title: Text(hipName ?? ''),
      ).paddingSymmetric(horizontal: Dimen.d_20),
      child: Column(
        children: careContexts.map((careContext) {
          bool selected = _consentController.linkFacilityHipContext[hipName]
                  ?.contains(careContext) ??
              false;
          return AppCheckBox(
            color: AppColors.colorAppBlue,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  careContext.referenceNumber ?? '',
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
                          '${careContext.display}',
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
            value: selected,
            onChanged: (value) {
              setState(() {
                if (value == false) {
                  _consentController.linkFacilityHipContext[hipName]
                      ?.remove(careContext);
                } else {
                  _consentController.linkFacilityHipContext[hipName]
                      ?.add(careContext);
                }
              });
              validateRequest();
            },
          ).paddingSymmetric(vertical: Dimen.d_10, horizontal: Dimen.d_30);
        }).toList(),
      ),
    );
  }

  /// @Here function datePicker of type Future<DateTime?> shows the DatePicker
  /// to pick the date.
  Future<DateTime?> datePicker(
    DateTime? selectedDate,
    DateTime? firstDate,
    DateTime? lastDate,
  ) async {
    selectedDate = selectedDate ?? today();
    return showDatePicker(
      context: context,
      initialDate:
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
      currentDate: today(),
      firstDate: firstDate ?? today().subtract(const Duration(days: 36525)),
      lastDate: lastDate ?? today().add(const Duration(days: 36525)),
    );
  }

  /// @Here function titleView of type Text returns the
  /// Text. This is a common Widget to display for multiple text views.
  /// return Text.
  /// Params used [title] of type String.
  Text titleView(String title, Color color) {
    return Text(
      title,
      style: CustomTextStyle.labelMedium(context)?.apply(color: color),
    );
  }

  /// @Here function validateRequest used to satisfy some condition
  /// and if condition matches assigns true to variable isValidRequest else assign
  /// false.
  void validateRequest() {
    bool isDurationDateValid = fromDate?.isBefore(toDate!) ?? false;
    bool isSameDate = fromDate?.isSameDate(toDate) ?? false;
    bool isInfoTypeSelected =
        tempSelectHiTypes.where((element) => element.check).toList().isNotEmpty;
    bool isProvidersSelected = _consentController.selectedHipContextCount() > 0;
    bool isLinkedProvidersSelected =
        _consentController.selectedLinkedHipContextCount() > 0;
    if ((isDurationDateValid || isSameDate) &&
        isInfoTypeSelected &&
        (isProvidersSelected || isLinkedProvidersSelected)) {
      setState(() {
        isValidRequest = true;
      });
    } else {
      setState(() {
        isValidRequest = false;
      });
    }
  }

  /// @Here widget button to save the edited consent fields
  /// Param used [request] of type Requests.
  Widget buttonSaveConsent(ConsentRequestModel? request) {
    return TextButtonOrange.mobile(
      text: LocalizationHandler.of().updateConsent,
      onPressed: () {
        widget.onSaveClick(
          tempSelectHiTypes,
          isValidRequest,
          fromDate,
          toDate,
          expiryDate,
          expiryTime,
        );
      },
    ).marginOnly(bottom: Dimen.d_10);
  }

  DateTime today() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
