import 'package:abha/app/token/token_controller.dart';
import 'package:abha/app/token/widget/token_generator_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';
import 'package:abha/reusable_widget/marquee/marquee_widget.dart';

class TokenView extends StatefulWidget {
  const TokenView({super.key});


  @override
  TokenViewState createState() => TokenViewState();
}

class TokenViewState extends State<TokenView> with TickerProviderStateMixin {
  final TokenController _tokenController = Get.find<TokenController>();
  late AnimationController _animController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() async {
    _animController.dispose();
    super.dispose();
  }

  void _init() async {
    _animController = AnimationController(vsync: this, duration: Duration.zero);
    int timeRemaining = _tokenController.remainsTimeInSeconds;
    if(timeRemaining > 0) {
      await _tokenController.getTimeForTokenExpiry();
      timeRemaining = _tokenController.remainsTimeInSeconds;
      _initAnimationController(timeRemaining);
      _tokenController.update();
    } else if(_tokenController.isUserDetailsShared){
       _onFetchHipTokenDetail();
    }
  }

  Future<void> _onFetchHipTokenDetail() async {
    _tokenController
        .functionHandler(
      function: () => _tokenController.getHipTokenDetails(),
      isUpdateUi: true,
      // isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
      isShowError: false,
    )
        .whenComplete(() {
      _tokenController.isUserDetailsShared = false;
      if (_tokenController.responseHandler.status == Status.success) {
        int timeRemaining = _tokenController.remainsTimeInSeconds;
        _initAnimationController(timeRemaining);
      }
    });
  }

  void _initAnimationController(int timeRemaining) {
    if (timeRemaining > 0) {
      _animController = AnimationController(
        vsync: this,
        duration: Duration(seconds: timeRemaining),
      );
      _animController.addListener(() {
        if (_animController.isDismissed) {
          _tokenController.update();
          _stopTimerHandler();
        }
      });
      _startTimerHandler(timeRemaining);
    }
    // else {
    //   _stopTimerHandler();
    // }
  }

  void _startTimerHandler(int timeRemaining) {
    // to show the dialog only once, when time reduces to 5 seconds then dialog will not be appear again
    _tokenController.startTimer(_animController);
    if ((_tokenController.expiryTime - timeRemaining) < 5) {
      TokenPopup().showTokenCreatedPopup(context, _tokenController);
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   TokenPopup().showTokenCreatedPopup(context, _tokenController);
      // });
    }
  }

  void _stopTimerHandler() {
    _tokenController.stopTimer(_animController);
    TokenPopup().showTokenExpiredPopup(context);
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   TokenPopup().showTokenExpiredPopup(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TokenController>(
      builder: (_) {
        return _tokenController.remainsTimeInSeconds > 0
            ? _tokenController.responseHandler.status == Status.loading
                ? CustomLoadingView(
                    loadingMessage: LocalizationHandler.of().tokenTime,
                    style: CustomTextStyle.labelMedium(context)?.apply(),
                    width: Dimen.d_20,
                    height: Dimen.d_20,
                  )
                : _tokenController.responseHandler.status == Status.success
                    ? _showTokenTimeView().sizedBox(width: 500)
                    : CustomErrorView(
                        status: _tokenController.responseHandler.status ??
                            Status.none,
                        onRetryPressed: _onFetchHipTokenDetail,
                      )
            : const SizedBox.shrink();
      },
    );
  }

  /// @Here widget shows token expiry time in minute
  Widget _showTokenTimeView() {
    return ColoredBox(
      color: AppColors.colorGreyLight8,
      child: MarqueeWidget(
        child: Row(
          children: [
            Text(
              _tokenController.tokenNo,
              style: CustomTextStyle.headlineSmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontSizeDelta: -1,
                fontWeightDelta: 3,
              ),
            ),
            Text(
              LocalizationHandler.of().tokenNoExpiresIn,
              style: CustomTextStyle.labelMedium(context)?.apply(
                color: AppColors.colorAppBlue,
                fontSizeDelta: 1,
                fontWeightDelta: -1,
              ),
            ).marginOnly(left: Dimen.d_4),
            SvgPicture.asset(
              ImageLocalAssets.tokenExpiryClockIconSvg,
            ).marginOnly(left: Dimen.d_5),
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) => Text(
                '${_tokenController.getCountText(_animController)} ${LocalizationHandler.of().min}',
                style: CustomTextStyle.labelMedium(context)?.apply(
                  color: AppColors.colorDarkRed1,
                  fontWeightDelta: 3,
                ),
              ).marginOnly(left: Dimen.d_5),
            )
          ],
        ).paddingAll(Dimen.d_10),
      ),
    );
  }
}
