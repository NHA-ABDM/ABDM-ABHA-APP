import 'package:abha/app/app_intro/model/login_option_model.dart';
import 'package:abha/export_packages.dart';

class RegistrationMobileView extends StatefulWidget {
  final List<LoginOptionModel> registrationViewOptions;
  final int crossAxisCount;
  final String? title;
  final Function(int index, BuildContext context) onClick;
  final Color? backgroundColor;
  final double? elevation;

  const RegistrationMobileView({
    required this.registrationViewOptions,
    required this.crossAxisCount,
    required this.onClick,
    Key? key,
    this.title,
    this.backgroundColor = AppColors.colorTransparent,
    this.elevation = 0,
  }) : super(key: key);

  @override
  State<RegistrationMobileView> createState() => _RegistrationMobileViewState();
}

class _RegistrationMobileViewState extends State<RegistrationMobileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title ?? '',
          style: CustomTextStyle.headlineSmall(context)?.apply(
            color: AppColors.colorAppBlue1,
            fontWeightDelta: 2,
          ),
        ).marginOnly(left: Dimen.d_16, top: Dimen.d_32).alignAtTopLeft(),
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: Dimen.d_10,
            mainAxisSpacing: Dimen.d_10,
            shrinkWrap: true,
            childAspectRatio: 1.3,
            children: List.generate(
              widget.registrationViewOptions.length,
              (index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimen.d_10),
                  ),
                  color: widget.backgroundColor,
                  elevation: widget.elevation,
                  child: InkWell(
                    onTap: () {
                      widget.onClick(index, context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (Validator.isNullOrEmpty(
                          widget.registrationViewOptions[index].icon,
                        ))
                          const SizedBox.shrink()
                        else
                          CustomCircularBackground(
                            image: widget.registrationViewOptions[index].icon,
                            radius: context.width * 0.18,
                            width: context.width * 0.25,
                            height: context.width * 0.25,
                          ),
                        if (Validator.isNullOrEmpty(
                          widget.registrationViewOptions[index].title,
                        ))
                          const SizedBox.shrink()
                        else
                          Text(
                            widget.registrationViewOptions[index].title,
                            style: CustomTextStyle.bodySmall(context)?.apply(
                              color: AppColors.colorGreyDark2,
                            ),
                          ).marginOnly(top: Dimen.d_5),
                      ],
                    ),
                  ),
                ).paddingAll(Dimen.d_10);
              },
            ),
          ).marginOnly(top: Dimen.d_20),
        ),
        Row(
          children: [
            Text(
              LocalizationHandler.of().otherRegistrationMethod,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark2,
              ),
            ).marginOnly(left: Dimen.d_25, right: Dimen.d_5),
            Expanded(child: _horizontalDivider()),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                widget.onClick(2, context);
              },
              child: Column(
                children: [
                  CustomCircularBackground(
                    image: ImageLocalAssets.loginEmailIconSvg,
                    radius: context.width * 0.18,
                    width: context.width * 0.25,
                    height: context.width * 0.25,
                  ),
                  Text(
                    LocalizationHandler.of().emailId,
                    style: CustomTextStyle.bodySmall(context)
                        ?.apply(color: AppColors.colorGreyDark2),
                  ).marginOnly(top: Dimen.d_5),
                ],
              ).marginOnly(left: Dimen.d_55),
            ),
          ],
        ).marginOnly(top: Dimen.d_10, bottom: Dimen.d_30),
      ],
    );
  }

  Widget _horizontalDivider() {
    return Container(
      color: AppColors.colorGreyLight11,
      height: Dimen.d_1,
    );
  }
}
