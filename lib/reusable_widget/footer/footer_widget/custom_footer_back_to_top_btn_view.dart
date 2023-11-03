import 'package:abha/export_packages.dart';

class CustomFooterBackToTopBtnView extends StatelessWidget {
  final ScrollController scrollController;
  const CustomFooterBackToTopBtnView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: Container(
        width: Dimen.d_160,
        padding: EdgeInsets.all(Dimen.d_12),
        decoration: BoxDecoration(
          color: AppColors.colorBlueDark1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimen.d_10),
            bottomLeft: Radius.circular(Dimen.d_10),
            topRight: Radius.circular(Dimen.d_10),
            bottomRight: Radius.circular(Dimen.d_10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocalizationHandler.of().backToTop,
              style: CustomTextStyle.labelMedium(context)?.apply(
                color: AppColors.colorWhite,
              ),
            ),
            const Icon(
              Icons.arrow_upward,
              color: AppColors.colorWhite,
            ),
          ],
        ),
      ),
    );
  }
}
