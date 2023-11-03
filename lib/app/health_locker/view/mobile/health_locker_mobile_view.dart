import 'package:abha/app/health_locker/widget/health_locker_list_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:flutter/foundation.dart';

class HealthLockerMobileView extends StatefulWidget {
  final VoidCallback onFetchConnectedLocker;
  final Function(HealthLockerConnectedModel locker) onLockerClick;

  const HealthLockerMobileView({
    required this.onFetchConnectedLocker,
    required this.onLockerClick,
    super.key,
  });

  @override
  HealthLockerMobileViewState createState() => HealthLockerMobileViewState();
}

class HealthLockerMobileViewState extends State<HealthLockerMobileView> {
  late HealthLockerController _healthLockerController;

  @override
  void initState() {
    _healthLockerController = Get.find<HealthLockerController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return GetBuilder<HealthLockerController>(
      builder: (_) {
        var data = _healthLockerController.connectedLockers;
        List<HealthLockerConnectedModel> tempConnectedLockers =
            data is List<HealthLockerConnectedModel> ? data : [];
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (Validator.isNullOrEmpty(tempConnectedLockers))
              kIsWeb ? _emptyListWidget() : _emptyListWidget().flexible()
            else
              kIsWeb
                  ? connectedLockerGridListWidget(tempConnectedLockers)
                  : connectedLockerGridListWidget(tempConnectedLockers)
                      .expand(),
            TextButtonOrange.mobile(
              text: LocalizationHandler.of().addNewLocker,
              onPressed: () {
                _lockerList();
              },
            ).marginOnly(bottom: Dimen.d_10)
          ],
        );
      },
    );
  }

  void _lockerList() {
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      mContext: context,
      title: kIsWeb ? LocalizationHandler.of().titleSelectHealthLocker : '',
      subTitle: kIsWeb
          ? LocalizationHandler.of().subscriptionRequestRegistrationLocker
          : '',
      width: kIsWeb ? context.width / 0.3 : null,
      height: kIsWeb ? context.height * 0.7 : null,
      child: HealthLockerListWidget(
        healthLockerController: _healthLockerController,
      ),
    );
  }

  Widget _emptyListWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.emptyHealthLockerSvg,
      infoMessageTitle: LocalizationHandler.of().noHealthLockerAvailable,
      onRetryPressed: widget.onFetchConnectedLocker,
      status: _healthLockerController.responseHandler.status ?? Status.none,
    );
  }

  Widget connectedLockerGridListWidget(
    List<HealthLockerConnectedModel>? connectedLockers,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: Dimen.d_10,
      mainAxisSpacing: Dimen.d_10,
      shrinkWrap: true,
      childAspectRatio: kIsWeb ? 1.8 : 1.3,
      children: List.generate(
        connectedLockers!.length,
        (index) {
          HealthLockerConnectedModel tempConnectedLocker =
              connectedLockers[index];
          return DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getElevation(
              isLow: true,
              borderColor: AppColors.colorGrey4,
              color: AppColors.colorWhite,
            ),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(Dimen.d_10)),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  widget.onLockerClick(tempConnectedLocker);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgImageView(
                      ImageLocalAssets.lokerIconSvg,
                      width: Dimen.d_40,
                      height: Dimen.d_40,
                    ),
                    Center(
                      child: Text(
                        tempConnectedLocker.lockerName.toString(),
                        softWrap: true,
                        style: CustomTextStyle.bodySmall(context)
                            ?.apply(color: AppColors.colorAppBlue),
                        textAlign: TextAlign.center,
                      ).marginOnly(top: Dimen.d_10),
                    ),
                  ],
                ).centerWidget,
              ),
            ),
          ).paddingAll(Dimen.d_5);
        },
      ),
    );
  }
}
