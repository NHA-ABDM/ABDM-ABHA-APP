import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class SwitchAccountMobileView extends StatefulWidget {
  final List<ProfileModel> mappedPhrAddress;
  String? abhaAddressSelectedValue;
  SwitchAccountMobileView({required this.mappedPhrAddress, Key? key})
      : super(key: key);

  @override
  State<SwitchAccountMobileView> createState() =>
      _SwitchAccountMobileViewState();
}

class _SwitchAccountMobileViewState extends State<SwitchAccountMobileView> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              constraints: BoxConstraints(maxHeight: context.height * 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSvgImageView(
                        ImageLocalAssets.switchAccountIconSvg,
                        width: Dimen.d_20,
                        height: Dimen.d_20,
                        color: AppColors.colorAppBlue,
                      ).marginOnly(left: Dimen.d_10),
                      Text(
                        LocalizationHandler.of().switchAccount,
                        style: CustomTextStyle.bodyMedium(context)?.apply(
                          color: AppColors.colorAppBlue,
                        ),
                        textAlign: TextAlign.center,
                      ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                    ],
                  ).marginOnly(top: Dimen.d_5),
                  Text(
                    LocalizationHandler.of().switchAccountMessage,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack,
                      fontWeightDelta: -1,
                    ),
                    textAlign: TextAlign.center,
                  ).marginOnly(
                    top: Dimen.d_10,
                    left: Dimen.d_10,
                    right: Dimen.d_5,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.mappedPhrAddress.length,
                      itemBuilder: (context, position) {
                        /// mapped phr address list item
                        var item = widget.mappedPhrAddress[position];

                        if (item.status != StringConstants.deleted) {
                          return CustomRadioTileWidget(
                            titleWidget: Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.abhaAddress ?? '',
                                        style:
                                            CustomTextStyle.labelLarge(context)
                                                ?.apply(
                                          color: AppColors.colorBlack,
                                          fontWeightDelta: -1,
                                        ),
                                      ).paddingOnly(top: Dimen.d_5),
                                      Text(
                                        item.fullName ?? '',
                                        style:
                                            CustomTextStyle.labelLarge(context)
                                                ?.apply(
                                          color: AppColors.colorGreyLight1,
                                        ),
                                      ).paddingOnly(top: Dimen.d_5),
                                    ],
                                  ),
                                )
                              ],
                            ).paddingSymmetric(
                              vertical: Dimen.d_6,
                              horizontal: Dimen.d_6,
                            ),
                            radioValue: item.abhaAddress ?? '',
                            radioGroupValue: widget.abhaAddressSelectedValue,
                            horizontalMargin: Dimen.d_0,
                            onChanged: (value) {
                              setModalState(() {
                                widget.abhaAddressSelectedValue =
                                    value as String;
                                abhaLog.i(
                                  'Selected ABHA address is ${item.abhaAddress}',
                                );
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    ).marginOnly(top: Dimen.d_10),
                  ),
                  TextButtonOrange.mobile(
                    text: LocalizationHandler.of().continuee,
                    onPressed: () {},
                  ).marginOnly(
                    top: Dimen.d_10,
                    bottom: Dimen.d_10,
                    left: kIsWeb ? Dimen.d_16 : Dimen.d_0,
                    right: kIsWeb ? Dimen.d_16 : Dimen.d_0,
                  )
                ],
              ).marginSymmetric(
                horizontal: Dimen.d_16,
                vertical: Dimen.d_16,
              ),
            );
          },
        ),
      );
    });
    return Container();
  }
}
