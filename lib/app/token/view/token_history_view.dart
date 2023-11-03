import 'package:abha/app/token/token_controller.dart';
import 'package:abha/app/token/token_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';

class TokenHistoryView extends StatefulWidget {
  const TokenHistoryView({super.key});

  @override
  TokenHistoryViewState createState() => TokenHistoryViewState();
}

class TokenHistoryViewState extends State<TokenHistoryView> {
  late TokenModel _tokenDetailModel;
  final TokenController _tokenController = Get.find<TokenController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHipTokens();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getHipTokens() async {
    if (Validator.isNullOrEmpty(_tokenController.tokenDetailModelList)) {
      await _tokenController.functionHandler(
        function: () => _tokenController.getHipTokenDetails(),
        isLoaderReq: true,
        isUpdateUi: true,
        isUpdateUiOnLoading: true,
        isUpdateUiOnError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: TokenHistoryView,
      title: LocalizationHandler.of().tokenHistory.toTitleCase(),
      bodyMobile: getTokenList(),
    );
  }

  Widget getTokenList() {
    return GetBuilder<TokenController>(
      builder: (_) {
        return !Validator.isNullOrEmpty(_tokenController.tokenDetailModelList)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _tokenController.tokenDetailModelList?.length,
                itemBuilder: (context, position) {
                  _tokenDetailModel =
                      _tokenController.tokenDetailModelList?[position] ??
                          TokenModel();
                  return _cardItemViewWidget(_tokenDetailModel);
                },
              )
            : _errorWidget();
      },
    );
  }

  Widget _errorWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.emptyNotificationSvg,
      status: _tokenController.responseHandler.status ?? Status.none,
      infoMessageTitle: LocalizationHandler.of().tokenNotAvailable,
      onRetryPressed: _getHipTokens,
    );
  }

  Widget _cardItemViewWidget(
    TokenModel dashboardTokenDetailModel,
  ) {
    return Card(
      key: const Key('Card'),
      color: AppColors.colorWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimen.d_15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dashboardTokenDetailModel.hipId.toString(),
                style: CustomTextStyle.bodyLarge(context)?.apply(
                  color: AppColors.colorGreyDark2,
                  fontWeightDelta: 2,
                ),
              ),
            ],
          ),
          Divider(
            thickness: Dimen.d_0,
            color: AppColors.colorBlack,
          ).marginOnly(top: Dimen.d_10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              columTitleAndValue(
                context,
                LocalizationHandler.of().date,
                dashboardTokenDetailModel.dateCreated
                    .toString()
                    .formatDDMMMMYYYY,
              ),
              columTitleAndValue(
                context,
                LocalizationHandler.of().time,
                _tokenController
                    .utcTime(
                      dashboardTokenDetailModel.dateCreated ?? DateTime.now(),
                    )
                    .toString()
                    .formatHHMMA,
              ),
              columTitleAndValue(
                context,
                LocalizationHandler.of().tokenNo,
                dashboardTokenDetailModel.tokenNumber.toString(),
              ),
            ],
          ).marginOnly(top: Dimen.d_10),
        ],
      ).paddingAll(Dimen.d_20),
    ).paddingSymmetric(vertical: Dimen.d_5);
  }
}

Widget columTitleAndValue(
  BuildContext context,
  String title,
  String value,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark2,
          fontWeightDelta: 2,
          fontSizeDelta: 2,
        ),
      ),
      Text(
        value,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark2,
        ),
      ).marginOnly(top: Dimen.d_3),
    ],
  );
}
