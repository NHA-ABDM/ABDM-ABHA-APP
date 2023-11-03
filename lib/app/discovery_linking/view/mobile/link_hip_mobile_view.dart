import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/model/care_context_req_model.dart';
import 'package:abha/app/discovery_linking/widget/steps_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LinkHipMobileView extends StatefulWidget {
  final List hipDataToLink;
  final VoidCallback onLinkHip;

  const LinkHipMobileView({
    required this.hipDataToLink,
    required this.onLinkHip,
    super.key,
  });

  @override
  LinkHipMobileViewState createState() => LinkHipMobileViewState();
}

class LinkHipMobileViewState extends State<LinkHipMobileView> {
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
    return _hipDetailsWidget();
  }

  Widget _hipDetailsWidget() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepsMobileView(
                title: LocalizationHandler.of().search_Record,
                icon: IconAssets.done,
                bgColor: AppColors.colorGreen,
              ),
              StepsMobileView(
                steps: '2',
                title: LocalizationHandler.of().discoverRecord,
                bgColor: AppColors.colorAppBlue,
                fgColor: AppColors.colorWhite,
              ),
              StepsMobileView(
                steps: '3',
                title: LocalizationHandler.of().otp,
              ),
            ],
          ),
          Text(
            LocalizationHandler.of().foundDetails,
            style: CustomTextStyle.titleLarge(context)?.apply(),
          ).marginOnly(top: Dimen.d_50, left: Dimen.d_20),
          Text(
            _hipDataToLink[ApiKeys.responseKeys.display],
            style:
                CustomTextStyle.titleLarge(context)?.apply(fontSizeDelta: -1),
          ).marginOnly(top: Dimen.d_30, left: Dimen.d_20),
          Text(
            _hipDataToLink[ApiKeys.responseKeys.referenceNumber],
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: AppColors.colorGreyDark7,
            ),
          ).marginOnly(top: Dimen.d_5, left: Dimen.d_20),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
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
              //     _careContextData
              //         .elementAt(position)[ApiKeys.responseKeys.referenceNumber],
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
              //   selected: checkBoxValue,
              //   onChanged: (value) {
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
          TextButtonOrange.mobile(
            text: LocalizationHandler.of().linkRecords,
            onPressed: () {
              _discoveryLinkingController
                  .addCareContext(_tempCareContextDataModel);
              if (_discoveryLinkingController.careContextData.isNotEmpty) {
                widget.onLinkHip();
              } else {
                MessageBar.showToastError(
                  'Please select at least one record',
                );
              }
            },
          ).marginOnly(top: Dimen.d_15, bottom: Dimen.d_15),
        ],
      ),
    );
  }
}
