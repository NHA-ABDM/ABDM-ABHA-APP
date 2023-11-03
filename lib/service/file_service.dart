import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:abha/utils/common/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

enum DirectoryType { download, internal, temporary }

/// @Here is the abstract class FileService to perform operations on file [Read/Write].
/// This used method [writeToStorage] and [readFromStorage].
abstract class FileService {
  /// writeToStorage() method writes the data to storage and having params :-
  ///     [fileName] of type String for giving file name.
  ///     [data] of type Uint8List formate.
  ///     [directoryType] of type DirectoryType.
  Future<File?> writeToStorage({
    required String fileName,
    required Uint8List data,
    DirectoryType? directoryType,
  });

  /// readFromStorage() method reads the data from storage and having params :-
  ///     [fileName] of type String for giving file name.
  ///     [directoryType] of type DirectoryType.
  Future<File?> readFromStorage({
    required String fileName,
    DirectoryType? directoryType,
  });
}

/// @Here class [FileServiceImpl] Implements [FileService] class and defines the
/// function [writeToStorage] and [readFromStorage].
class FileServiceImpl implements FileService {
  @override
  Future<File?> writeToStorage({
    required String fileName,
    required Uint8List data,
    DirectoryType? directoryType,
  }) async {
    if (kIsWeb) {
      try {
        final base64 = base64Encode(data);
        final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$base64',
        )..target = 'blank';
        anchor.download = fileName;
        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();
        return null;
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        if (Platform.isAndroid) {
          int deviceVersion = await CustomDeviceInfo.getSDKVersion();
          if (deviceVersion < 33) {
            bool hasPermission =
                await PermissionHandler.requestStoragePermission();
            if (!hasPermission) throw 'Permission Deny';
          }
        } else {
          bool hasPermission =
              await PermissionHandler.requestStoragePermission();
          if (!hasPermission) throw 'Permission Deny';
        }
        var directory =
            await _getDirectoryPath(directoryType ?? DirectoryType.download);
        String filePath = '$directory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(data);
        return file;
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<File?> readFromStorage({
    required String fileName,
    DirectoryType? directoryType,
  }) async {
    if (kIsWeb) {
      return null;
    } else {
      try {
        var directory =
            await _getDirectoryPath(directoryType ?? DirectoryType.download);
        File file = File('$directory/$fileName');
        if (await file.exists()) {
          return Future.value(file);
        }
        return null;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<String?> _getDirectoryPath(DirectoryType directoryType) async {
    if (kIsWeb) {
      return null;
    } else {
      try {
        Directory? directory;

        switch (directoryType) {
          case DirectoryType.download:
            if (Platform.isIOS) {
              directory = await getApplicationDocumentsDirectory();
            } else {
              int deviceVersion = await CustomDeviceInfo.getSDKVersion();
              if (deviceVersion >= 33) {
                directory = await getApplicationDocumentsDirectory();
              } else {
                directory = Directory('/storage/emulated/0/Download');
              }
            }
            break;
          case DirectoryType.internal:
            directory = (Platform.isIOS)
                ? await getApplicationDocumentsDirectory()
                : await getApplicationDocumentsDirectory();
            break;
          case DirectoryType.temporary:
            directory = await getTemporaryDirectory();
            break;
        }
        return directory.path;
      } catch (err) {
        abhaLog.e(err.toString());
      }
      return null;
    }
  }
}
