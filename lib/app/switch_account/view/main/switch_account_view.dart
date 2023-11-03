import 'package:abha/app/switch_account/view/desktop/switch_account_desktop_view.dart';
import 'package:abha/app/switch_account/view/mobile/switch_account_mobile_view.dart';
import 'package:abha/export_packages.dart';

class SwitchAccountView extends StatefulWidget {
  const SwitchAccountView({Key? key}) : super(key: key);

  @override
  State<SwitchAccountView> createState() => _SwitchAccountViewState();
}

class _SwitchAccountViewState extends State<SwitchAccountView> {
  late List<ProfileModel> _mappedPhrAddress;
  String? abhaAddressSelectedValue;

  @override
  void initState() {
    super.initState();
    getMappedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isAppBar: true,
      type: SwitchAccountView,
      bodyMobile: SwitchAccountMobileView(mappedPhrAddress: _mappedPhrAddress),
      bodyDesktop: const SwitchAccountDesktopView(),
    );
  }

  Future<List<ProfileModel>> getMappedUsers() async {
    _mappedPhrAddress = [];
    String? usersString =
        await abhaSingleton.getSharedPref.get(SharedPref.userLists);
    for (Map<String, dynamic> jsonMap in jsonDecode(usersString!)) {
      _mappedPhrAddress.add(ProfileModel.fromMappedUserMap(jsonMap));
    }
    return _mappedPhrAddress;
  }
}
