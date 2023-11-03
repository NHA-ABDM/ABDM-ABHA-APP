import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

/// @Here abstract class ShareService declares the method
/// [shareLink] and [shareFile] of type void. This method share the link or filepath
/// to different application.
abstract class ShareService {
  /// shareLink() shares the link or url to another application and having params :-
  ///     [link] of type String.
  ///     [subject] of type String i.e optional paramter.
  void shareLink(String link, {String? subject});

  /// shareFile() shares the filepath to another application and having params :-
  ///     [filePath] of type List<String> i.e required paramter.
  ///     [subject] of type String.
  ///     [text] of type String.
  void shareFile({
    required List<String> filePath,
    String? subject,
    String? text,
  });
}

/// @Here class [ShareServiceImpl] Implements the [ShareService] class and defines the
/// function [shareLink] and [shareFile].
class ShareServiceImpl implements ShareService {
  @override
  void shareLink(String link, {String? subject}) {
    if (kIsWeb) {
    } else {
      Share.share(link);
    }
  }

  @override
  void shareFile({
    required List<String> filePath,
    String? subject,
    String? text,
  }) {
    if (kIsWeb) {
    } else {
      List<XFile> files = filePath.map((e) => XFile(e)).toList();
      Share.shareXFiles(files, subject: subject, text: text);
    }
  }
}
