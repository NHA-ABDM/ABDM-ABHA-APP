import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class CustomErrorView extends StatelessWidget {
  final String? errorMessageTitle;
  final String? errorMessageSubTitle;
  final String? infoMessageTitle;
  final String? infoMessageSubTitle;
  final Function()? onRetryPressed;
  final Color? colorTitle;
  final Color? colorSubTitle;
  final Status status;
  final String? image;
  final double? imageHeight;

  const CustomErrorView({
    required this.status,
    super.key,
    this.errorMessageTitle,
    this.errorMessageSubTitle,
    this.infoMessageTitle,
    this.infoMessageSubTitle,
    this.onRetryPressed,
    this.colorTitle,
    this.colorSubTitle,
    this.image,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return status == Status.loading || status == Status.none
        ? const SizedBox.shrink()
        : status == Status.error
            ? kIsWeb
                ? _errorView(context).sizedBox(height: Dimen.d_400)
                : _errorView(context)
            : kIsWeb
                ? _infoView(context).sizedBox(height: Dimen.d_400)
                : _infoView(context); // success
  }

  Widget _errorView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!Validator.isNullOrEmpty(image))
          if (image!.endsWith('png'))
            Image.asset(
              image!,
              height: imageHeight ?? context.height * 0.30,
            ).marginOnly(bottom: Dimen.d_20)
          else if (image!.endsWith('svg'))
            CustomSvgImageView(
              image!,
              height: imageHeight ?? context.height * 0.30,
            ).marginOnly(bottom: Dimen.d_20),
        Text(
          errorMessageTitle ?? LocalizationHandler.of().somethingWrong,
          textAlign: TextAlign.center,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: colorTitle ?? AppColors.colorBlueDark1),
        ).paddingOnly(left: Dimen.d_20, right: Dimen.d_20),
        if (Validator.isNullOrEmpty(errorMessageSubTitle))
          const SizedBox.shrink()
        else
          Text(
            errorMessageSubTitle ?? '',
            textAlign: TextAlign.center,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: colorSubTitle ?? AppColors.colorBlueDark1),
          ).marginOnly(top: Dimen.d_5),
        if (!Validator.isNullOrEmpty(onRetryPressed))
          ElevatedButtonBlue(
            onPressed: onRetryPressed,
            text: LocalizationHandler.of().retry,
            width: Dimen.d_150,
            height: Dimen.d_10,
            fontSizeDelta: -2,
          ).marginOnly(top: Dimen.d_10)
        else
          const SizedBox.shrink()
      ],
    ).centerWidget;
  }

  Widget _infoView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!Validator.isNullOrEmpty(image))
          if (image!.endsWith('png'))
            Image.asset(
              image!,
              height: imageHeight ?? context.height * 0.30,
            ).marginOnly(bottom: Dimen.d_20)
          else if (image!.endsWith('svg'))
            CustomSvgImageView(
              image!,
              height: imageHeight ?? context.height * 0.30,
            ).marginOnly(bottom: Dimen.d_20),
        Text(
          infoMessageTitle ?? LocalizationHandler.of().noDataAvailable,
          textAlign: TextAlign.center,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: colorTitle ?? AppColors.colorBlueDark1),
        ).paddingOnly(left: Dimen.d_20, right: Dimen.d_20),
        if (!Validator.isNullOrEmpty(infoMessageSubTitle))
          Text(
            infoMessageSubTitle ?? '',
            textAlign: TextAlign.center,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: colorSubTitle ?? AppColors.colorBlueDark1),
          ).marginOnly(top: Dimen.d_5),
      ],
    ).centerWidget;
  }
}
