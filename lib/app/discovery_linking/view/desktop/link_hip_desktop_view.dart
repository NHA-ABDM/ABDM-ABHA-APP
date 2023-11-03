import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/model/care_context_req_model.dart';
import 'package:abha/app/discovery_linking/widget/steps_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class LinkHipDesktopView extends StatefulWidget {
  final List hipDataToLink;
  final VoidCallback onLinkHip;

  const LinkHipDesktopView({
    required this.hipDataToLink,
    required this.onLinkHip,
    super.key,
  });

  @override
  LinkHipViewState createState() => LinkHipViewState();
}

class LinkHipViewState extends State<LinkHipDesktopView> {
  late DiscoveryLinkingController _discoveryLinkingController;
  late Map _hipDataToLink;
  List _careContextData = [];
  final List<CareContextReqModel> _tempCareContextDataModel = [];
  bool checkBoxValue = true;

  @override
  void initState() {
    _discoveryLinkingController = Get.find<DiscoveryLinkingController>();
    _hipDataToLink = widget.hipDataToLink.elementAtOrNull(0);
    _careContextData = _discoveryLinkingController.careContextData;
    for (int i = 0; i < _careContextData.length; i++) {
      CareContextReqModel careContextReqModel = CareContextReqModel(
        isCheck: true,
        referenceNumber: _careContextData.elementAt(i)['referenceNumber'],
        display: _careContextData.elementAt(i)['display'],
      );
      _tempCareContextDataModel.add(careContextReqModel);
    }
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
          Text(
            LocalizationHandler.of().linkMyHealthRecord,
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StepsDesktopView(
                  steps: '1',
                  title: LocalizationHandler.of().search_Record,
                  bgColor: AppColors.colorGreen,
                  fgColor: AppColors.colorWhite,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  steps: '2',
                  title: LocalizationHandler.of().discoverRecord,
                  bgColor: AppColors.colorAppBlue,
                  fgColor: AppColors.colorWhite,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  steps: '3',
                  title: LocalizationHandler.of().otpVerification,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          CommonBackgroundCard(child: _hipDetailsWidget())
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget _hipDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().foundDetails,
          style: CustomTextStyle.labelLarge(context)?.apply(
            color: AppColors.colorGreyDark5,
            fontSizeDelta: -1,
            fontWeightDelta: -1,
            // fontSizeDelta: 1,
          ),
        ),
        Text(
          _hipDataToLink[ApiKeys.responseKeys.display],
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack,
            fontWeightDelta: -1,
          ),
        ).marginOnly(top: Dimen.d_30, left: Dimen.d_20),
        Text(
          _hipDataToLink[ApiKeys.responseKeys.referenceNumber],
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack,
            fontWeightDelta: -1,
          ),
        ).marginOnly(top: Dimen.d_5, left: Dimen.d_20),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const Divider(
              color: AppColors.colorBlack,
            );
          },
          itemCount: _careContextData.length,
          itemBuilder: (context, position) {
            // return CheckboxListTile(
            //   controlAffinity: ListTileControlAffinity.leading,
            //   title: Text(
            //     _careContextData.elementAt(
            //       position,
            //     )[ApiKeys.responseKeys.referenceNumber],
            //     style: CustomTextStyle.titleLarge(context)
            //         ?.apply(fontSizeDelta: -1),
            //   ),
            //   subtitle: Text(
            //     _careContextData
            //         .elementAt(position)[ApiKeys.responseKeys.display],
            //     style: CustomTextStyle.titleSmall(context)?.apply(
            //       color: AppColors.colorGreyDark7,
            //     ),
            //   ),
            //   activeColor: context.themeData.primaryColor,
            //   value: checkBoxValue,
            //   // selected: checkBoxValue,
            //   onChanged: (value) {
            //     // if(_careContextData.length > 1){
            //     //   setState(() {
            //     //     // value == true
            //     //     //     ? _tempCareContextData.add(_careContextData.elementAt(position))
            //     //     //     : _tempCareContextData.removeAt(position);
            //     //     checkBoxValue = value ?? true;
            //     //   });
            //     // }
            //   },
            // );
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                _tempCareContextDataModel.elementAt(position).referenceNumber,
                style: CustomTextStyle.titleLarge(context)
                    ?.apply(fontSizeDelta: -1),
              ),
              subtitle: Text(
                _tempCareContextDataModel.elementAt(position).display,
                style: CustomTextStyle.titleSmall(context)?.apply(
                  color: AppColors.colorGreyDark7,
                ),
              ),
              activeColor: context.themeData.primaryColor,
              value: _tempCareContextDataModel.elementAt(position).isCheck,
              onChanged: (value) {
                if (_careContextData.length > 1) {
                  setState(() {
                    _tempCareContextDataModel.elementAt(position).isCheck =
                        value ?? true;
                  });
                }
              },
            );
          },
        ).marginOnly(top: Dimen.d_20),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().linkRecords,
          onPressed: () {
            _discoveryLinkingController
                .addCareContext(_tempCareContextDataModel);
            if (_discoveryLinkingController.careContextData.isNotEmpty) {
              widget.onLinkHip();
            } else {
              MessageBar.showToastError('Please select at least one record');
            }
          },
        ).marginOnly(top: Dimen.d_25),
      ],
    );
  }
}
