import 'package:abha/export_packages.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDDMMYYYY => DateFormat('dd-MM-yyyy').format(this);

  String get formatSlashDDMMYYYY => DateFormat('dd/MM/yyyy').format(this);

  String get formatDDMMMMYYYY => DateFormat('dd-MMMM-yyyy').format(this);

  String get formatDDMMMYYYY => DateFormat('dd-MMM-yyyy').format(this);

  String get formatMMDDYYYY => DateFormat('MMMM, dd yyyy').format(this);

  String get formatDOMMYYYY => DateFormat('dd-MMM-yyyy').format(this);

  /// @Here function isSameDate() returns boolean value.
  /// This function takes [date] as parameter of type DateTime and matches
  /// the day, month and year with default day, month and year.
  bool isSameDate(DateTime? date) {
    return day == date?.day && month == date?.month && year == date?.year;
  }

  DateTime convertToDateTime(DateOfBirth? date) {
    if (Validator.isNullOrEmpty(date)) {
      return DateTime.now();
    }
    var dateObj = DateTime(date!.year!, date.month!, date.date!, 0, 0, 0, 0, 0);
    return dateObj;
  }

  /// @Here function is used to add the hours and minutes into the existing dateTime and
  /// returns the String value as date After Addition.
  /// Params used [dateTime] of type String.
  String getAddedDateTime(String dateTime) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    DateTime dateAfterAddition =
        date.add(const Duration(hours: 5, minutes: 30));
    return dateAfterAddition.toString();
  }
}
