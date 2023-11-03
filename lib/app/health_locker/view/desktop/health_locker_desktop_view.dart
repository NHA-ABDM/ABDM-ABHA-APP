import 'package:abha/app/health_locker/widget/health_locker_list_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class HealthLockerDesktopView extends StatefulWidget {
  final VoidCallback onFetchConnectedLocker;
  final Function(HealthLockerConnectedModel locker) onLockerClick;

  const HealthLockerDesktopView({
    required this.onFetchConnectedLocker,
    required this.onLockerClick,
    super.key,
  });

  @override
  HealthLockerDesktopViewState createState() => HealthLockerDesktopViewState();
}

class HealthLockerDesktopViewState extends State<HealthLockerDesktopView> {
  late HealthLockerController _healthLockerController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _healthLockerController = Get.find<HealthLockerController>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _lockerWidget()
          .paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
      showBackOption: false,
    );
  }

  Widget _lockerWidget() {
    return GetBuilder<HealthLockerController>(
      builder: (_) {
        var data = _healthLockerController.connectedLockers;
        List<HealthLockerConnectedModel> tempConnectedLockers =
            data is List<HealthLockerConnectedModel> ? data : [];
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationHandler.of().drawer_healthlocker.toTitleCase(),
                  style: CustomTextStyle.titleLarge(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
                TextButtonOrange.desktop(
                  text: LocalizationHandler.of().addNewLocker,
                  // width: context.width * 0.12,
                  onPressed: () {
                    _lockerList();
                  },
                ),
              ],
            ).marginOnly(bottom: Dimen.d_20),
            if (Validator.isNullOrEmpty(tempConnectedLockers))
              _emptyListWidget()
            else
              _connectedLockerListWidget(tempConnectedLockers),
          ],
        );
      },
    );
  }

  void _lockerList() {
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      mContext: context,
      title: LocalizationHandler.of().titleSelectHealthLocker,
      subTitle: LocalizationHandler.of().subscriptionRequestRegistrationLocker,
      child: HealthLockerListWidget(
        healthLockerController: _healthLockerController,
      ).paddingSymmetric(vertical: Dimen.d_10),
    );
  }

  Widget _emptyListWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.emptyHealthLockerSvg,
      infoMessageTitle: LocalizationHandler.of().noHealthLockerAvailable,
      //infoMessageSubTitle: LocalizationHandler.of().let_s_start,
      onRetryPressed: widget.onFetchConnectedLocker,
      status: _healthLockerController.responseHandler.status ?? Status.none,
    );
  }

  Widget _connectedLockerListWidget(
    List<HealthLockerConnectedModel>? connectedLockers,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableHeaderView(
          children: [
            Text(
              LocalizationHandler.of().lockerRequest,
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorWhite),
            ),
            Text(
              LocalizationHandler.of().last_updated,
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorWhite),
            )
          ],
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: connectedLockers?.length,
            itemBuilder: (context, position) {
              HealthLockerConnectedModel tempConnectedLocker =
                  connectedLockers![position];
              return TableRowView(
                onClick: () {
                  widget.onLockerClick(tempConnectedLocker);
                },
                backgroundColor: (position % 2 == 0)
                    ? AppColors.colorWhite
                    : AppColors.colorGreyVeryLight,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      tempConnectedLocker.lockerName.toString(),
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorBlack,
                        fontWeightDelta: -1,
                      ),
                    ),
                  ),
                  Text(
                    getAddedDateTime(
                      tempConnectedLocker.dateModified.toString(),
                    ).formatDDMMMYYYY,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack,
                      fontWeightDelta: -1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String getAddedDateTime(String dateTime) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    return date.getAddedDateTime(date.toString());
  }
}
