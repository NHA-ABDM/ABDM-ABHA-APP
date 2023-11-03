import 'package:abha/app/app_intro/app_intro_repo.dart';
import 'package:abha/export_packages.dart';

class AppIntroController extends BaseController {
  // late AppIntroRepo _appIntroRepo;

  AppIntroController(AppIntroRepoImpl repo) : super(LoginController) {
    // _appIntroRepo = repo;
  }

  // Future<void> getRefreshToken() async {
  //   tempResponseData = await _appIntroRepo.callRefreshApiHeaderToken();
  //   abhaSingleton.getApiProvider.addXHeaderToken(tempResponseData);
  // }


}
