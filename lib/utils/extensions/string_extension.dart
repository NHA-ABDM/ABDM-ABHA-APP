part of 'extension.dart';

extension StrExtension on String {
  String getDataAfterGivenCharacter(String value) =>
      substring(lastIndexOf(value) + 1);

  String getDataBeforeGivenCharacter(String value) =>
      substring(0, lastIndexOf(value));

  String get removeSpecialChar => replaceAll(RegExp(r'\s+[^\w\s]+'), '');

  String get getDataFromArrayBrackets =>
      substring(indexOf('[') + 1, lastIndexOf(']'));

  String get getDataFromCurlyBrackets =>
      substring(indexOf('{'), lastIndexOf('}'));

  String get getCodeData =>
      substring(indexOf('${ApiKeys.responseKeys.code}:') + 5, indexOf(','));

  String get getMessageData =>
      substring(indexOf('${ApiKeys.responseKeys.message}:') + 8, indexOf('}'));

  String get formatDDMMYYYY =>
      DateFormat('dd-MM-yyyy').format(DateTime.parse(this));

  String get formatYYYYMMDD =>
      DateFormat('yyyy-MM-dd').format(DateTime.parse(this));

  String get formatDDMMMMYYYY =>
      //DateFormat('dd MMM, yyyy').format(DateTime.parse(this));
      DateFormat('dd-MMMM-yyyy').format(DateTime.parse(this));

  String get formatDDMMMYYYY =>
      //DateFormat('dd MMM, yyyy').format(DateTime.parse(this));
      DateFormat('dd-MMM-yyyy').format(DateTime.parse(this));

  String get formatMMMDDYYYY =>
      DateFormat('MMM dd, yyyy').format(DateTime.parse(this));

  String get formatHHMMADDMMYYYY =>
      DateFormat('HH:mm a, dd MMM, yyyy').format(DateTime.parse(this));

  /////
  String get formatYYYYMMDDHHMMSSA =>
      DateFormat('hh:mm:ss aa, dd MMM, yyyy').format(DateTime.parse(this));

  String get formatDDMMMYYYYHHMMA =>
      DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(this));

  String get formatHHMMA => DateFormat('hh:mm a').format(DateTime.parse(this));

  String get formatMM => DateFormat.LLLL().format(DateTime.parse(this));

  String get formatYYYYMMMddHHMMMSS =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(this));

  String get formatLocalWithoutZ =>
      DateFormat('yyyy-MM-ddTHH:mm:ss.mmm').format(DateTime.parse(this));

  int get parseInt => int.parse(this);

  String get formatDD_MMM_YYYY =>
      //DateFormat('dd MMM, yyyy').format(DateTime.parse(this));
      DateFormat('dd/MMM/yyyy').format(DateTime.parse(this));

  String get formatAbhaNumberValueWithDash => replaceAllMapped(
        RegExp(r'(\d{2})(\d{4})(\d{4})(\d{4})'),
        (Match m) => '${m[1]}-${m[2]}-${m[3]}-${m[4]}',
      );

  String get formatAadhaarNumberValueWithDash => replaceAllMapped(
        RegExp(r'(\d{4})(\d{4})(\d{4})'),
        (Match m) => '${m[1]}-${m[2]}-${m[3]}',
      );

  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    } else {
      return false;
    }
  }

  String get inCaps => '${this[0]}${substring(1)}';

  String get allInCaps => toUpperCase();

  String? get capitalizeFirstOfEach {
    if (length <= 1) {
      return toUpperCase();
    }
    // Split string into multiple words
    final List<String> words = split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1);
        final String remainingLetters = word.trim().substring(1);
        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Returns a new string with the first letter capitalized.
  ///
  /// This function capitalizes the first letter of a string by accessing the first
  /// character using the index 0 and capitalizing it using the toUpperCase() method.
  /// The substring(1) method is then used to retrieve the remaining part of the
  /// original string, starting from the second character. The resulting string is
  /// a concatenation of the capitalized first character and the remaining part of
  /// the original string.
  ///
  /// Example:
  /// ```dart
  /// String name = "flutter";
  /// String capitalized = name.capitalizeFirstLetter(); // "Flutter"
  /// ```
  ///
  /// Note:
  /// - This function assumes that the input string is not null and has at least one character.
  /// - If the input string is an empty string, the function will return an empty string.
  String get capitalizeFirstLetter {
    return this[0].toUpperCase() + substring(1);
  }

  String get convertPascalCaseString {
    // Single character look-ahead for capital letter.
    // Matches before a capital letter that is not also at beginning of string.
    final beforeNonLeadingCapitalLetter = RegExp(r'(?=(?!^)[A-Z])');
    List<String> splitPascalCase(String input) =>
        input.split(beforeNonLeadingCapitalLetter);
    List<String> stringList = splitPascalCase(this);
    var normalString = stringList.join(' ');
    return normalString;
  }

  String calculatePastTime({bool utc = true}) {
    DateTime current = DateTime.now();
    var dateTime = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(this, utc);
    var date = dateTime.toLocal();
    Duration duration = current.difference(date);
    if (duration.inSeconds <= 10) {
      return LocalizationHandler.of().just_now;
    } else if (duration.inSeconds <= 59) {
      return '${duration.inSeconds} ${LocalizationHandler.of().seconds_ago}';
    } else if (duration.inMinutes <= 59) {
      return '${duration.inMinutes} ${LocalizationHandler.of().minutes_ago}';
    } else if (duration.inHours <= 24) {
      return '${duration.inHours} ${LocalizationHandler.of().hour_ago}';
    } else if (duration.inDays <= 7) {
      return '${duration.inDays} ${LocalizationHandler.of().days_ago}';
    } else {
      return formatDDMMMYYYY;
    }
  }

  String toSentanceCase() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toSentanceCase())
      .join(' ');
}
