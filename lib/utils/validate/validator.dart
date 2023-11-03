import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:abha/app/abha_app.dart';
import 'package:abha/app/registration/model/full_name_model.dart';
import 'package:abha/localization/localization_handler.dart';
import 'package:abha/utils/constants/string_constants.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class Validator {
  // static RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
  static RegExp nameRegex =
      RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
  static RegExp stringWithCommaRegex = RegExp(r'^[a-zA-Z ,]+$');
  static RegExp abhaAddressRegex = RegExp(r'^[A-Za-z\d._%+-]+@(abdm)$');

  static final _panPattern = RegExp(
    r'^([A-Z]){3}([PC]){1}([A-Z]){1}([0-9]){4}([A-Z]){1}?$',
    caseSensitive: false,
  );

  static final _emailPattern = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    caseSensitive: false,
  );

  static final _alphabetPattern = RegExp(
    r'^[a-z A-Z,.\-]+$',
    caseSensitive: false,
  );

  static final _numberPattern = RegExp(
    r'^[1-9,.\-]+$',
    caseSensitive: false,
  );

  static final _passwordPattern = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%&*]).{8,}',
  );

  static final _consecutiveNumbers = RegExp(
    r'^(.*(012|123|234|345|456|567|678|789|890))$',
    // r'^(?!.*(\d)\\1{3})$',
    caseSensitive: false,
  );

  static final _suggestAbhaAddressPattern = RegExp(
    r'^(?=^.{8,18}$)([a-zA-Z0-9]+[.]{0,1}[a-zA-Z0-9]+[_]{0,1}[a-zA-Z0-9]|[a-zA-Z0-9]+[_]{0,1}[a-zA-Z0-9]+[.]{0,1}[a-zA-Z0-9])[a-zA-Z0-9]{0,}$',
    // r'^(?!^\.)(?!.*[_.]$)(?![^0-9a-zA-Z]|.*?([_.]).*\1)[\w.]+[A-Za-z0-9]+[a-zA-Z0-9]*\.*_?[a-zA-Z0-9]$',
  );

  // static Future<File> _writeToFile(ByteData data, String path) async {
  //   final buffer = data.buffer;
  //   return File(path).writeAsBytes(
  //       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }

  // static void _deleteFile(String dirPath) {
  //   final dir = Directory(dirPath);
  //   dir.deleteSync(recursive: true);
  // }
  //
  // static Future<Encrypted> encryptData(var text) async {
  //   var pubKey =
  //       await rootBundle.load("assets/keys/public.pem"); // it is a file
  //   String dirPath =
  //       '${(await getTemporaryDirectory()).path}/public.pem'; // it is path
  //   await _writeToFile(pubKey, dirPath);
  //   final publicKey = await parseKeyFromFile<RSAPublicKey>(File(dirPath).path);
  //   final encryptor = Encrypter(RSA(publicKey: publicKey));
  //   final encrypted = encryptor.encrypt(text);
  //   _deleteFile(dirPath);
  //   return encrypted;
  // }

  static Future<Encrypted> encryptData(var text) async {
    final publicKey = await parseKeyFromAssetFile<RSAPublicKey>(
      File('assets/keys/public.pem').path,
    );
    final encryptor = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encryptor.encrypt(text);
    return encrypted;
  }

  static Future<T> parseKeyFromAssetFile<T extends RSAAsymmetricKey>(
    String filename,
  ) async {
    final key = await rootBundle.loadString(filename);
    final parser = RSAKeyParser();
    return parser.parse(key) as T;
  }

  static bool isPanValid(String value) {
    final matches = _panPattern.allMatches(value);
    final hasMatch = matches.isNotEmpty;
    return hasMatch;
  }

  static bool isAadhaarValid(String aadhaarNum) {
    var mult = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
      [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
      [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
      [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
      [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
      [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
      [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
      [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    ];
    var perm = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
      [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
      [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
      [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
      [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
      [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
      [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
    ];
    int i, j, x;
    if (aadhaarNum.length == 12 && RegExp(r'^[0-9]+$').hasMatch(aadhaarNum)) {
      try {
        i = aadhaarNum.length;
        j = 0;
        x = 0;
        while (i > 0) {
          i -= 1;
          String curr = aadhaarNum[i];
          var index = int.parse(curr);
          x = mult[x][perm[(j % 8)][index]];
          j += 1;
        }
        if (x == 0) {
          return true;
        } else {
          return false;
        }
      } on Exception catch (_) {
        abhaLog.d('Invalid Aadhaar Number');
      }
    }
    return false;
  }

  static bool isNameValid(String value) {
    final matches = _alphabetPattern.allMatches(value);
    final hasMatch = matches.isNotEmpty;
    return hasMatch;
  }

  static bool isNumberValid(String value) {
    final matches = _numberPattern.allMatches(value);
    final hasMatch = matches.isNotEmpty;
    return hasMatch;
  }

  static bool isEmailValid(String value) {
    final matches = _emailPattern.allMatches(value);
    final hasMatch = matches.isNotEmpty;
    return hasMatch;
  }

  static bool isPassValid(String value) {
    final hasMatch = _passwordPattern.hasMatch(value);
    final hasMatch1 = _consecutiveNumbers.hasMatch(value);
    return hasMatch && !hasMatch1;
  }

  static bool isMobileValid(String value) {
    if (value.length == 10) {
      return true;
    }
    return false;
  }

  static bool isAbhaNumberValid(String value) {
    if (value.length == 14) {
      return true;
    }
    return false;
  }

  static bool isAbhaNumberWithDashValid(String value) {
    if (value.length == 17) {
      return true;
    }
    return false;
  }

  static bool isOtpValid(String value) {
    if (value.length == 6) {
      return true;
    }
    return false;
  }

  static bool _isEmpty(dynamic value) {
    if (value is String) {
      return value.toString().trim().isEmpty;
    }
    if (value is Iterable || value is Map) {
      return value.isEmpty as bool;
    }
    return false;
  }

  static bool _isNull(dynamic value) => value == null;

  static bool isNullOrEmpty(dynamic value) {
    if (_isNull(value)) {
      return true;
    }
    return _isEmpty(value);
  }

  static bool isDotCriteriaMatches(String value) {
    if (value[0].toString() == StringConstants.dot ||
        value[value.length - 1].toString() == StringConstants.dot) {
      return true;
    }
    return false;
  }

  static bool isValidAbhaAddressPattern(String value) {
    if (_suggestAbhaAddressPattern.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static String formatAbhaNumber(String data) {
    var firstHealthId = data.substring(0, 2);
    var secondHealthId = data.substring(2, 6);
    var thirdHealthId = data.substring(6, 10);
    var fourthHealthId = data.substring(10, 14);
    String abhaNumber =
        '$firstHealthId-$secondHealthId-$thirdHealthId-$fourthHealthId';
    return abhaNumber;
  }

  static String maskingNumber(String data) {
    List char = [];
    int length = data.length - 4;
    for (int i = 0; i < length; i++) {
      char.add('*');
    }
    String newChar = char.reduce((value, element) => value + element);
    return data.replaceRange(0, length, newChar);
  }

  static String? maskEmail(
    String input, [
    int minFill = 4,
    String fillChar = '*',
  ]) {
    var emailMaskRegExp = RegExp('^(.)(.*?)([^@]?)(?=@[^@]+\$)');
    return input.replaceFirstMapped(emailMaskRegExp, (m) {
      var start = m.group(1);
      var middle = fillChar * max(minFill, m.group(2)!.length);
      var end = m.groupCount >= 3 ? m.group(3) : start;
      return start! + middle + end!;
    });
  }

  static FullNameModel fetchFullName(String fullName) {
    FullNameModel fullNameModel = const FullNameModel();
    String firstName = '';
    String middleName = '';
    String lastName = '';
    if (fullName.trim().contains(' ')) {
      var arrName = fullName.trim().split(' ');
      if (arrName.length == 2) {
        firstName = arrName.removeAt(0);
        lastName = arrName.removeLast();
        fullNameModel = FullNameModel(
          firstName: firstName,
          lastName: lastName,
          middleName: '',
        );
      } else if (arrName.length > 2) {
        firstName = arrName.removeAt(0);
        lastName = arrName.removeLast();
        middleName = arrName.join(' ');
        fullNameModel = FullNameModel(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
        );
      }
    } else {
      fullNameModel = FullNameModel(
        firstName: fullName,
        middleName: '',
        lastName: '',
      );
    }
    return fullNameModel;
  }

  static bool customKeyEventHandler(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete ||
          event.logicalKey == LogicalKeyboardKey.clear) {
        return true;
      }
    }
    return false;
  }

  static int customTECFocusChangedHandler(
    String abhaNumberValue,
    TextEditingController firstTEC,
    TextEditingController lastTEC,
  ) {
    if (Validator.isNullOrEmpty(firstTEC.text) ||
        !Validator.isNullOrEmpty(lastTEC.text)) {
      return 0;
    } else if (abhaNumberValue.trim().length == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  static String? validateMobileNumber(String? number) {
    if (number != null) {
      if (number.isEmpty) {
        return LocalizationHandler.of().errorEnterMobileNumber;
      }
      if (number.trim().length != 10) {
        return LocalizationHandler.of().invalidMobile;
      } else if (int.tryParse(number.trim()) == null) {
        return LocalizationHandler.of().invalidMobile;
      } else {
        return null;
      }
    } else {
      return LocalizationHandler.of().errorEnterMobileNumber;
    }
  }

  static String? validateOtp(String? otp) {
    if (otp != null) {
      if (otp.isEmpty) {
        return 'LocalizationHandler.of()!.errorEnterOTP';
      } else if (otp.trim().length != 6) {
        return 'LocalizationHandler.of()!.invalidOTP';
      } else if (int.tryParse(otp.trim()) == null) {
        return 'LocalizationHandler.of()!.invalidOTP';
      } else {
        return null;
      }
    } else {
      return 'LocalizationHandler.of()!.errorEnterOTP';
    }
  }

  static String? validateAadhaar(String? aadhaar) {
    if (aadhaar != null) {
      if (aadhaar.trim().length != 12) {
        return 'LocalizationHandler.of()!.invalidAadhaar';
      } else if (int.tryParse(aadhaar.trim()) == null) {
        return 'LocalizationHandler.of()!.invalidAadhaar';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? validateHprAddress(String? hprAddress) {
    if (hprAddress != null) {
      if (hprAddress.isEmpty) {
        return 'LocalizationHandler.of()!.errorEnterHprAddress';
      } else if (!RegExp(r'^[A-Za-z0-9._%+-]+@hpr.(abdm)$')
          .hasMatch(hprAddress)) {
        return 'LocalizationHandler.of()!.errorInvalidHprAddress';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? validateHprId(String? hprId) {
    if (hprId != null) {
      if (hprId.isEmpty) {
        return 'LocalizationHandler.of()!.errorEnterHprId';
      } else if (hprId.trim().length != 14) {
        return 'LocalizationHandler.of()!.errorInvalidHprId';
      } else if (int.tryParse(hprId.trim()) == null) {
        return 'LocalizationHandler.of()!.errorInvalidHprId';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? validateFees(String? fees) {
    if (fees != null) {
      if (fees.isEmpty) {
        return 'LocalizationHandler.of()!.errorProvideFees';
      } else if (double.tryParse(fees.trim()) == null) {
        return 'LocalizationHandler.of()!.errorProvideProperFees';
      } else if (double.parse(fees.trim()) <= 0) {
        return 'LocalizationHandler.of()!.errorProvideNonZeroFees';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? validateUpiId(String? upiId) {
    var upiMatch = RegExp(r'^[\w.-]+@[\w.-]+$');
    if (upiId != null) {
      if (upiId.isEmpty) {
        return 'LocalizationHandler.of()!.errorProvideUpi';
      } else if (!upiMatch.hasMatch(upiId)) {
        return 'LocalizationHandler.of()!.errorProvideValidUpi';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? validateAge(String? age) {
    if (age != null) {
      if (age.isEmpty) {
        return 'LocalizationHandler.of()!.errorProvideAge';
      } else if (age.startsWith(' ') || age.trim().contains(' ')) {
        return 'LocalizationHandler.of()!.errorShouldNotContainSpace';
      } else if (double.tryParse(age.trim()) == null) {
        return 'LocalizationHandler.of()!.errorProvideValidAge';
      } else if (double.parse(age.trim()) <= 0) {
        return 'LocalizationHandler.of()!.errorProvideNonZeroAge';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String getGender(String? gender) {
    gender ??= '';
    return gender == 'M'
        ? 'Male'
        : gender == 'F'
            ? 'Female'
            : gender == 'O'
                ? 'Others'
                : gender == 'U'
                    ? "I Don't Want To Disclose"
                    : '';
  }

  static String? validateExperience(String? experience) {
    if (experience != null) {
      if (experience.isEmpty) {
        return 'LocalizationHandler.of()!.errorProvideExperience';
      } else if (double.tryParse(experience.trim()) == null) {
        return 'LocalizationHandler.of()!.errorProvideValidExperience';
      } else if (double.parse(experience.trim()) <= 0) {
        return 'LocalizationHandler.of()!.errorProvideNonZeroExperience';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static List<TextInputFormatter> personNameFormatter({
    bool allowSpace = true,
  }) =>
      [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        if (allowSpace)
          FilteringTextInputFormatter.deny('  ', replacementString: ' '),
      ];

  static List<TextInputFormatter> abhaAddressFormatter() => [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9._]')),
        FilteringTextInputFormatter.deny('@'),
      ];

  static List<TextInputFormatter> withoutSpace() => [
        FilteringTextInputFormatter.deny('  ', replacementString: ''),
        FilteringTextInputFormatter.deny(' ', replacementString: ''),
      ];

  static List<TextInputFormatter> addressFormatter() => [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9 ,.-/]')),
        FilteringTextInputFormatter.deny(' , ,', replacementString: ' ,'),
        FilteringTextInputFormatter.deny('//', replacementString: '/'),
        FilteringTextInputFormatter.deny(', ,', replacementString: ','),
        FilteringTextInputFormatter.deny(',,', replacementString: ','),
        FilteringTextInputFormatter.deny(' ,', replacementString: ','),
        FilteringTextInputFormatter.deny('  ', replacementString: ' '),
        FilteringTextInputFormatter.deny('..', replacementString: '.'),
        FilteringTextInputFormatter.deny('--', replacementString: '-'),
        // FilteringTextInputFormatter.deny('^', replacementString: ''),
        // FilteringTextInputFormatter.deny('&&', replacementString: '&'),
        // FilteringTextInputFormatter.deny('*', replacementString: ''),
      ];

  static List<TextInputFormatter> numberFormatter() => [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ];

  static bool validateAbhaAddress(String abhaAddress) {
    if (!abhaAddressRegex.hasMatch(abhaAddress)) {
      debugPrint('validate AbhaAddress string not matching');
      return false;
    } else {
      return true;
    }
  }

  static bool isTestRunning() {
    return kIsWeb ? false : Platform.environment.containsKey('FLUTTER_TEST');
  }
}
