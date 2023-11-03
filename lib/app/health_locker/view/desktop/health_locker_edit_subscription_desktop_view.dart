import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/app/health_locker/widget/locker_request_expansion_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/button/gray/text_button_gray.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';

class HealthLockerEditSubscriptionDesktopView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onSubmitClick;

  const HealthLockerEditSubscriptionDesktopView({
    required this.arguments,
    required this.onSubmitClick,
    super.key,
  });

  @override
  HealthLockerEditSubscriptionDesktopViewState createState() =>
      HealthLockerEditSubscriptionDesktopViewState();
}

class HealthLockerEditSubscriptionDesktopViewState
    extends State<HealthLockerEditSubscriptionDesktopView> {
  late HealthLockerController _healthLockerController;
  String? hipName;
  DateTime? fromDate, toDate;
  String? hipID;
  bool isChkBoxClicked = false;

  @override
  void initState() {
    _healthLockerController = Get.find<HealthLockerController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                LocalizationHandler.of().editsubscription,
                style: CustomTextStyle.titleLarge(context)?.apply(
                  color: AppColors.colorAppBlue,
                  fontWeightDelta: 2,
                ),
              ),
              CustomToolTipMessage(
                message: LocalizationHandler.of().automaticallySyncData,
              ).paddingOnly(left: Dimen.d_8)
            ],
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(child: getSubscriptionHipDetail())
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget getSubscriptionHipDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: WidgetUtility.spreadWidgets(
            [
              /// This widget for Option "All"
              getOptionAll(),

              /// This widget for Remaining Hip Names Item
              getOptionsHIPName().marginOnly(left: Dimen.d_12)
            ],
            interItemSpace: Dimen.d_0,
            flowHorizontal: false,
          ),
        ),
        GetBuilder<HealthLockerController>(
          id: UpdateLockerBuilderIds.subscriptionRequest,
          builder: (_) {
            return Row(
              children: [
                submitButtonInOrange().marginOnly(right: Dimen.d_16),
                TextButtonPurple.desktop(
                  text: LocalizationHandler.of().cancel,
                  onPressed: () {
                    context.navigateBack();
                  },
                )
              ],
            ).marginOnly(top: Dimen.d_30);
          },
        )
      ],
    );
  }

  /// Here is the widget to show the item of [All] in list
  Widget getOptionAll() {
    return GetBuilder<HealthLockerController>(
      id: UpdateLockerBuilderIds.subscriptionRequest,
      builder: (_) {
        hipID = '';
        if (!isChkBoxClicked) {
          hipName = LocalizationHandler.of().all;
        }

        /// when checkbox not clicked
        return ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: AppCheckBox(
            color: AppColors.colorAppBlue,
            enable: true,
            title: Text(
              LocalizationHandler.of().all.toUpperCase(),
              style: CustomTextStyle.bodyLarge(context)?.apply(
                color: _healthLockerController.isOptionAllSelected
                    ? AppColors.colorBlack
                    : AppColors.colorGrey3,
              ),
            ),
            value: _healthLockerController.listHipName.contains('All')
                ? true
                : false,
            onChanged: (value) {
              /// change the boolean when clicked on checkbox
              isChkBoxClicked = true;

              /// if HipId is not null in Subscription then assign 'All' to variable
              /// to show different button in UI
              // if (!_healthLockerController.isHIPIdNullInSubscription()) {
              hipName = 'All';
              //}
              onChangeChkBoxValueAll(value);
            },
          ),
          children: [
            GetBuilder<HealthLockerController>(
              id: UpdateLockerBuilderIds.subscriptionRequest,
              builder: (_) {
                return Column(
                  children: [
                    recordTypesWidget(null, true),
                    typeOfVisitWidget(null),
                    timePeridodWidget(null),
                  ],
                ).marginOnly(bottom: Dimen.d_8);
              },
            ),
          ],
        );
      },
    );
  }

  /// Here is the widget to show the item of HIP in list
  Widget getOptionsHIPName() {
    return Column(
      children: WidgetUtility.spreadWidgets(
        _healthLockerController.linksFacilityData.map((link) {
          return GetBuilder<HealthLockerController>(
            id: UpdateLockerBuilderIds.subscriptionRequest,
            builder: (_) {
              /// when checkbox not clicked
              if (isChkBoxClicked == false) {
                if (_healthLockerController.isHIPIdMatches(link?.hip?.id)) {
                  hipID = link?.hip?.id;
                  _healthLockerController.hipName = link?.hip?.name;
                }
              }

              return IgnorePointer(
                ignoring:
                    _healthLockerController.isOptionAllSelected ? true : false,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: AppCheckBox(
                    color: AppColors.colorAppBlue,
                    enable: _healthLockerController.isOptionAllSelected
                        ? false
                        : true,
                    title: Flexible(
                      child: Text(
                        link?.hip?.name ?? '',
                        style: CustomTextStyle.bodyLarge(context)?.apply(
                          color: _healthLockerController.isOptionAllSelected
                              ? AppColors.colorGrey3
                              : AppColors.colorBlack,
                        ),
                      ),
                    ),
                    value: _healthLockerController.listHipName
                            .contains(link?.hip?.name)
                        ? true
                        : false,
                    onChanged: (value) {
                      /// change the boolean when clicked on checkbox
                      isChkBoxClicked = true;

                      /// if HipId is null in Subscription then put hip Name into variable
                      /// to show different button in UI
                      //if (!_healthLockerController.isHIPIdMatches(link?.hip?.id)) {
                      if (_healthLockerController.isHIPIdNullInSubscription()) {
                        hipName = link?.hip?.name;
                      }

                      onChangeChkBoxValueOfHipNameOptions(
                        value,
                        link?.hip?.name,
                      );
                    },
                  ),
                  children: [
                    GetBuilder<HealthLockerController>(
                      id: UpdateLockerBuilderIds.subscriptionRequest,
                      builder: (_) {
                        if (Validator.isNullOrEmpty(
                          _healthLockerController.subscription,
                        )) {
                          return const SizedBox();
                        }

                        return IgnorePointer(
                          ignoring: _healthLockerController.listHipName
                                  .contains(link?.hip?.name)
                              ? false
                              : true,
                          child: Opacity(
                            opacity: !_healthLockerController.listHipName
                                        .contains(link?.hip?.name) ||
                                    _healthLockerController.isOptionAllSelected
                                ? 0.5
                                : 1.0,
                            child: Column(
                              children: [
                                recordTypesWidget(link?.hip?.id, false),
                                typeOfVisitWidget(link?.hip?.id),
                                timePeridodWidget(link?.hip?.id),
                              ],
                            ),
                          ).marginOnly(bottom: Dimen.d_8),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
        interItemSpace: Dimen.d_20,
        flowHorizontal: false,
      ),
    );
  }

  //////////////////////////// HIP Types Record ///////////////////////////////////
  Widget recordTypesWidget(String? linkHipID, bool isHipTypeAll) {
    List<String>? recordType;
    _healthLockerController
        .subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.forEach(
      (element) {
        /// for the case of HIP's
        if (element.hip?.id == linkHipID) {
          recordType = element.hiTypes;
        }

        /// for the case of 'All'
        if (isHipTypeAll) {
          if (element.hip?.id == null) {
            recordType = element.hiTypes;
          }
        }
      },
    );

    return LockerRequestExpansionWidget(
      title: LocalizationHandler.of().forRecordsOfTypes,
      expanded: true,
      child: GetBuilder<HealthLockerController>(
        builder: (_) {
          return Wrap(
            runSpacing: 12,
            spacing: 12,
            children: hiTypesCode.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCheckBox(
                    isDesktopView: true,
                    shoulToggleOpacity: false,
                    iconEnabledWidget: CustomSvgImageView(
                      'assets/images/$e.svg',
                      height: Dimen.d_24,
                      width: Dimen.d_24,
                    ),
                    iconDisbledWidget: CustomSvgImageView(
                      'assets/images/$e.svg',
                      height: Dimen.d_24,
                      width: Dimen.d_24,
                    ),
                    labelWidget: Text(
                      e.convertPascalCaseString,
                      style: CustomTextStyle.bodyLarge(context)?.copyWith(
                        fontSize: Dimen.d_16,
                        color: AppColors.colorBlack,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    value: recordType!.contains(e) ? true : false,
                    enable: true,
                    onChanged: (value) {
                      selectUnselectHiTypes(value, linkHipID, e);
                    },
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void selectUnselectHiTypes(
    bool? value,
    String? linkHipID,
    String hipTypeName,
  ) {
    _healthLockerController
        .subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.forEach(
      (element) {
        String? id = element.hip?.id;

        /// if linkHipID not blank
        if (linkHipID != '') {
          /// if linkHipID equals to hip Id in model
          if (linkHipID == id) {
            if (element.hiTypes!.contains(hipTypeName)) {
              /// if model contains hipType name then
              /// remove from model on unselect operation
              element.hiTypes?.remove(hipTypeName);
            } else {
              /// add the hipType name if not available into model
              /// on select operation
              element.hiTypes?.add(hipTypeName);
            }
          }
        } else {
          /// In case of linkHipID null
          if (element.hiTypes!.contains(hipTypeName)) {
            element.hiTypes?.remove(hipTypeName);
          } else {
            element.hiTypes?.add(hipTypeName);
          }
        }
      },
    );
  }

  ////////////////////  Category of HIP //////////////////////////////////

  Widget typeOfVisitWidget(String? hipId) {
    List<String?> listCategoryType = getListCategoryType(hipId);
    return LockerRequestExpansionWidget(
      title: LocalizationHandler.of().typeOfVisitCareContent,
      expanded: true,
      child: Row(
        children: WidgetUtility.spreadWidgets(
          visitTypes.map((e) {
            return GetBuilder<HealthLockerController>(
              id: UpdateLockerBuilderIds.subTypeVisitRequest,
              builder: (_) {
                return DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    borderColor: AppColors.colorAppOrange,
                    color: AppColors.colorWhite,
                    size: Dimen.d_5,
                    //isLow: true,
                  ),
                  child: AppCheckBox(
                    color: AppColors.colorAppBlue,
                    enable: true,
                    value: listCategoryType.contains(e.convertPascalCaseString)
                        ? true
                        : false,
                    onChanged: (value) {
                      selectUnselectCategoryOnclick(
                        listCategoryType,
                        value,
                        hipId,
                        e,
                      );
                    },
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgImageView(
                          'assets/images/visitType$e.svg',
                          height: Dimen.d_24,
                          width: Dimen.d_24,
                        ).marginOnly(right: Dimen.d_6),
                        Text(
                          e.convertPascalCaseString,
                          style: CustomTextStyle.bodyLarge(context)?.copyWith(
                            fontSize: Dimen.d_16,
                            color: AppColors.colorBlack,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ).paddingAll(Dimen.d_12),
                );
              },
            );
          }).toList(),
          interItemSpace: Dimen.d_12,
        ),
      ),
    );
  }

  List<String?> getListCategoryType(String? hipId) {
    List<String?> listCategoryType = [];
    _healthLockerController
        .subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.forEach((element) {
      if (element.hip?.id == hipId) {
        /// If type belongs to 'LINK'
        if (element.categories!.contains(Categories.link.name.toUpperCase())) {
          /// category list to show checkbox value selected for 'New'
          if (!listCategoryType
              .contains(visitTypes[0].convertPascalCaseString)) {
            listCategoryType.add(visitTypes[0].convertPascalCaseString);
          }
        }

        /// If type belongs to 'DATA'
        if (element.categories!.contains(Categories.data.name.toUpperCase())) {
          /// category list to show checkbox value selected for 'Existing'
          if (!listCategoryType
              .contains(visitTypes[1].convertPascalCaseString)) {
            listCategoryType.add(visitTypes[1].convertPascalCaseString);
          }
        }
      }
    });
    return listCategoryType;
  }

  void selectUnselectCategoryOnclick(
    List<String?> listCategoryType,
    bool? value,
    String? hipId,
    String e,
  ) {
    _healthLockerController
        .subscriptionModel.subscriptionEditAndApprovalRequest?.includedSources
        ?.forEach((element) {
      String? id = element.hip?.id;
      if (hipId != '') {
        if (id == hipId) {
          addAndRemoveCategory(listCategoryType, value, element, e);
        }
      } else {
        addAndRemoveCategory(listCategoryType, value, element, e);
      }
    });
    _healthLockerController
        .update([UpdateLockerBuilderIds.subTypeVisitRequest]);
  }

  void addAndRemoveCategory(
    List<String?> listCategoryType,
    bool? value,
    SubscriptionIncludedSource element,
    String e,
  ) {
    if (value!) {
      if (e.convertPascalCaseString == StringConstants.newCategory) {
        element.categories?.add(Categories.link.name.toUpperCase());
        listCategoryType.add(e.convertPascalCaseString);
      } else {
        element.categories?.add(Categories.data.name.toUpperCase());
        listCategoryType.add(e.convertPascalCaseString);
      }
    } else {
      if (e.convertPascalCaseString == StringConstants.newCategory) {
        element.categories?.remove(Categories.link.name.toUpperCase());
        listCategoryType.remove(e.convertPascalCaseString);
      } else {
        element.categories?.remove(Categories.data.name.toUpperCase());
        listCategoryType.remove(e.convertPascalCaseString);
      }
    }
  }

  ///////////////////// Time Period ////////////////////////////////////////////
  Widget _titleView(String title) {
    return Text(
      title,
      style: CustomTextStyle.labelLarge(context)?.apply(
        color: AppColors.colorGreyDark5,
        fontSizeDelta: -1,
        fontWeightDelta: -1,
        // fontSizeDelta: 1,
      ),
    );
  }

  Widget timePeridodWidget(String? hipId) {
    DateTime? fromDate;
    DateTime? toDate;
    _healthLockerController.subscription?.includedSources?.forEach((element) {
      if (element.hip?.id == hipId) {
        fromDate = element.period?.from;
        toDate = element.period?.to;
      }
    });

    return LockerRequestExpansionWidget(
      title: LocalizationHandler.of().forTimePeriod,
      expanded: true,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleView(LocalizationHandler.of().from)
                  .marginOnly(bottom: Dimen.d_5),
              Material(
                child: DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    borderColor: AppColors.colorAppOrange,
                    color: AppColors.colorWhite,
                    size: Dimen.d_5,
                    //isLow: true,
                  ),
                  child: InkWell(
                    onTap: () async {
                      DateTime? selected = await datePicker(fromDate);
                      if (selected != null) {
                        _healthLockerController.subscription?.includedSources
                            ?.forEach((element) {
                          if (element.hip?.id == hipId) {
                            setState(() {
                              element.period?.from = selected;
                            });
                          }
                        });
                      }
                    },
                    child: iconTextRowWidget(
                      fromDate?.formatDOMMYYYY ?? '-',
                      ImageLocalAssets.calendarFrom,
                    ),
                  ),
                ),
              ),
            ],
          ).marginOnly(right: Dimen.d_14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleView(LocalizationHandler.of().to)
                  .marginOnly(bottom: Dimen.d_5),
              DecoratedBox(
                decoration:
                    abhaSingleton.getBorderDecoration.getRectangularBorder(
                  borderColor: AppColors.colorAppOrange,
                  color: AppColors.colorWhite,
                  size: Dimen.d_5,
                  //isLow: true,
                ),
                child: InkWell(
                  onTap: () async {
                    DateTime? selected = await datePicker(toDate);
                    if (selected != null) {
                      _healthLockerController.subscription?.includedSources
                          ?.forEach((element) {
                        if (element.hip?.id == hipId) {
                          setState(() {
                            element.period?.to = selected;
                          });
                        }
                      });
                    }
                  },
                  child: iconTextRowWidget(
                    toDate?.formatDOMMYYYY ?? '-',
                    ImageLocalAssets.calendarFrom,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// This is common widget for icon and text in Row.
  Widget iconTextRowWidget(String text, String icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSvgImageView(
          icon,
          width: Dimen.d_18,
          height: Dimen.d_18,
        ).marginOnly(right: Dimen.d_6),
        Text(
          text,
          style: CustomTextStyle.bodyLarge(context)?.copyWith(
            fontSize: Dimen.d_16,
            color: AppColors.colorBlack,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: Dimen.d_8, vertical: Dimen.d_8);
  }

  /// Here is the function perform [add] and [remove] operation of 'option All' into list
  /// on the basis of select and unselect of Checkbox.
  /// params [value] bool
  /// params [hipName] String
  void onChangeChkBoxValueAll(bool? value) {
    bool? select = value;
    if (select == true) {
      /// When checkbox is selected, add the name into the list.
      _healthLockerController.listHipName.add('All');

      /// if checkbox all is select then disables the other hip options
      _healthLockerController.isOptionAllSelected = true;
    } else {
      /// When checkbox unselect, remove the name from the list.
      _healthLockerController.listHipName.remove('All');

      /// if checkbox all is de-select then enable the other hip options
      _healthLockerController.isOptionAllSelected = false;
    }
    _healthLockerController
        .update([UpdateLockerBuilderIds.subscriptionRequest]);
  }

  /// Here is the function perform [add] and [remove] operation of hipName into list
  /// on the basis of select and unselect of Checkbox.
  /// params [value] bool
  /// params [hipName] String
  void onChangeChkBoxValueOfHipNameOptions(bool? value, String? hipName) {
    bool? select = value;
    if (select == true) {
      /// When checkbox is selected, add the hip name into the list.
      _healthLockerController.listHipName.add(hipName);
    } else {
      /// When checkbox unselect, remove the hip name from the list.
      _healthLockerController.listHipName.remove(hipName);
    }
    _healthLockerController
        .update([UpdateLockerBuilderIds.subscriptionRequest]);
  }

  Widget submitButtonInOrange() {
    return TextButtonOrange.desktop(
      text: LocalizationHandler.of().submit,
      onPressed: () {
        if (!isChkBoxClicked) {
          widget.onSubmitClick();
        } else if (Validator.isNullOrEmpty(
          _healthLockerController.listHipName,
        )) {
        } else if ((_healthLockerController.isHIPIdNullInSubscription() &&
            _healthLockerController.listHipName.contains('All'))) {
          widget.onSubmitClick();
        } else if ((!Validator.isNullOrEmpty(hipName) &&
            !_healthLockerController.isHIPIdNullInSubscription() &&
            _healthLockerController.listHipName.contains(hipName))) {
        } else {
          widget.onSubmitClick();
        }
      },
    );
  }

  Widget submitButtonInGray() {
    return TextButtonGray(
      text: LocalizationHandler.of().submit.toUpperCase(),
      onPressed: () {},
    );
  }

  /// @Here function datePicker of type Future<DateTime?> shows the DatePicker
  /// to pick the date.
  Future<DateTime?> datePicker(DateTime? selectedDate) async {
    selectedDate = selectedDate ?? DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: selectedDate,
      currentDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 36525)),
      lastDate: DateTime.now().add(const Duration(days: 36525)),
    );
  }
}
