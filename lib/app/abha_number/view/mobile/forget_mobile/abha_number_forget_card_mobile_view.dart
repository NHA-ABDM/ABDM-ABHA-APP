import 'package:abha/app/abha_number/model/abha_number_user_detail_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetCardMobileView extends StatefulWidget {
  const AbhaNumberForgetCardMobileView({super.key});

  @override
  AbhaNumberForgetCardMobileViewState createState() =>
      AbhaNumberForgetCardMobileViewState();
}

class AbhaNumberForgetCardMobileViewState
    extends State<AbhaNumberForgetCardMobileView> {
  late AbhaNumberController _abhaNumberController;
  Account? _usersAccounts;

  @override
  void initState() {
    _abhaNumberController = Get.find<AbhaNumberController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _getAbhaNumberCardWidget())
        : _getAbhaNumberCardWidget();
  }

  Widget _getAbhaNumberCardWidget() {
    return Column(
      children: [
        if (kIsWeb)
          SizedBox(
            height: context.height / 2,
            child: _getAbhaCardAccountList(),
          )
        else
          Expanded(child: _getAbhaCardAccountList()),
        _navigateToLoginScreen()
      ],
    );
  }

  Widget _getAbhaCardAccountList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _abhaNumberController.accounts?.length,
      itemBuilder: (context, position) {
        _usersAccounts = _abhaNumberController.accounts?[position] ?? Account();
        return _getUsersCardDetail(_usersAccounts);
      },
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
        children: [
          CustomCircularBorderBackground(
            image: user?.profilePhoto ?? '',
          ).marginOnly(left: Dimen.d_20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_20),
              ],
            ).marginSymmetric(horizontal: Dimen.d_15),
          ),
        ],
      ),
    ).sizedBox(height: Dimen.d_220);
  }

  Widget _navigateToLoginScreen() {
    return TextButtonOrange.mobile(
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
    ).marginOnly(
      bottom: Dimen.d_30,
    );
  }
}
