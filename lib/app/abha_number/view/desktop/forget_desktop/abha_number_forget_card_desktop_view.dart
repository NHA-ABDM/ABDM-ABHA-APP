import 'package:abha/app/abha_number/model/abha_number_user_detail_model.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberForgetCardDesktopView extends StatefulWidget {
  const AbhaNumberForgetCardDesktopView({super.key});

  @override
  AbhaNumberForgetCardDesktopViewState createState() =>
      AbhaNumberForgetCardDesktopViewState();
}

class AbhaNumberForgetCardDesktopViewState
    extends State<AbhaNumberForgetCardDesktopView> {
  late AbhaNumberController _abhaNumberController;
  Account? _usersAccounts;
  @override
  void initState() {
    _abhaNumberController = Get.find<AbhaNumberController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getAbhaNumberCardWidget();
  }

  Widget _getAbhaNumberCardWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ABHA Card',
              style: CustomTextStyle.titleLarge(context)
                  ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
            ),
            _navigateToLoginScreen()
          ],
        ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
        _getAbhaCardAccountList()
      ],
    );
  }

  Widget _getAbhaCardAccountList() {
    return GridView.extent(
      shrinkWrap: true,
      childAspectRatio: 2.3,
      mainAxisSpacing: Dimen.d_10,
      crossAxisSpacing: Dimen.d_10,
      maxCrossAxisExtent: Dimen.d_500,
      children:
          List.generate(_abhaNumberController.accounts!.length, (position) {
        _usersAccounts = _abhaNumberController.accounts?[position] ?? Account();
        return _getUsersCardDetail(_usersAccounts);
      }),
    );
  }

  Widget _getUsersCardDetail(Account? user) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
        topLeft: 10,
        topRight: 10,
        bottomLeft: 10,
        bottomRight: 10,
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCircularBorderBackground(
            image: user?.profilePhoto ?? '',
          ).marginOnly(
            left: Dimen.d_20,
            right: Dimen.d_20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user?.name}',
                style: CustomTextStyle.bodyLarge(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(
                top: Dimen.d_20,
              ),
              Text(
                LocalizationHandler.of().abhaNumber,
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGrey,
                ),
              ).marginOnly(top: Dimen.d_20),
              Text(
                '${user?.abhaNumber}',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(top: Dimen.d_5),
              Text(
                LocalizationHandler.of().abhaAddress,
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorGrey,
                ),
              ).marginOnly(top: Dimen.d_20),
              Text(
                '${user?.preferredAbhaAddress}',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorWhite,
                ),
              ).marginOnly(top: Dimen.d_5),
            ],
          ).marginOnly(
            left: Dimen.d_20,
            right: Dimen.d_20,
          ),
        ],
      ),
    )
        .sizedBox(height: Dimen.d_220)
        .marginOnly(top: Dimen.d_10, left: Dimen.d_20, right: Dimen.d_20);
  }

  Widget _navigateToLoginScreen() {
    return TextButtonOrange.desktop(
      text: LocalizationHandler.of().go_to_login,
      onPressed: () {
        bool isLogin = abhaSingleton.getAppData.getLogin();
        String route = '';
        if (isLogin) {
          route = RoutePath.routeAccount;
        } else {
          route = RoutePath.routeAppIntro;
        }
        context.navigateGo(route);
      },
    ).marginOnly(top: Dimen.d_30);
  }
}
