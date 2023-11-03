import 'package:abha/export_packages.dart';
import 'package:universal_html/html.dart' as html;

typedef OnDownloaded = Function(String path);

class WebDownloadService {
  void download({required String url}) {
    html.window.open(url, '_blank');
  }
}

class MobileDownloadService {
  static Future<void> download({
    required String url,
    required String fileName,
    OnDownloaded? onDownloaded,
  }) async {
    try {
      bool hasPermission = await PermissionHandler.requestStoragePermission();
      if (!hasPermission) throw 'Permission Deny';
      var directory = await getApplicationDocumentsDirectory();
      String path = '${directory.path}/$fileName';
      Dio dio = Dio();
      await dio.download(url, path);
      onDownloaded!(path);
    } catch (e) {
      rethrow;
    }
  }
}
