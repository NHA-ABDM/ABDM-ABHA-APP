import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dropdown/dropdown_field.dart';

class Month {
  final String name;
  final int code;

  Month(this.name, this.code);
}

typedef OnDateChange = Function(DateOfBirth? date);

class DatePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final DateOfBirth? selectedDate;
  final OnDateChange? onDateChange;
  final bool enable;
  bool isFromDesktop;

  TextStyle? titleStyle;
  TextStyle? style;
  InputDecoration? decoration;

  DatePicker({
    required this.selectedDate,
    super.key,
    this.startDate,
    this.endDate,
    this.onDateChange,
    this.enable = true,
    this.isFromDesktop = false,
  });

  DatePicker.mobile({
    required this.selectedDate,
    required BuildContext context,
    super.key,
    this.startDate,
    this.endDate,
    this.onDateChange,
    this.enable = true,
    this.isFromDesktop = false,
  });

  DatePicker.desktop({
    required this.selectedDate,
    required BuildContext context,
    super.key,
    this.startDate,
    this.endDate,
    this.onDateChange,
    this.enable = true,
    this.isFromDesktop = true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime startDate;
  late DateTime lastDate;
  late DateOfBirth? selectedDate;
  bool isDayMonthSelected = false;

  final List<Month> _months = [
    Month('January', 01),
    Month('February', 02),
    Month('March', 03),
    Month('April', 04),
    Month('May', 05),
    Month('June', 06),
    Month('July', 07),
    Month('August', 08),
    Month('September', 09),
    Month('October', 10),
    Month('November', 11),
    Month('December', 12),
  ];
  List<int> years = [];
  List<int> days = [];
  Month? selectedMonth;

  @override
  void initState() {
    selectedDate = widget.selectedDate;
    startDate = widget.startDate ?? DateTime(DateTime.now().year - 120);
    lastDate = widget.endDate ?? DateTime.now();
    years.add(selectedDate?.year ?? startDate.year);

    days.add(selectedDate?.date ?? startDate.day);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<int> tempYears = [];
      List<int> tempDays = [];
      for (int i = lastDate.year; i >= startDate.year; i--) {
        tempYears.add(i);
      }
      selectedDate?.month == null
          ? selectedMonth = null
          : selectedMonth = _months
              .firstWhere((element) => element.code == selectedDate?.month);

      int lastDayDateTime = 31; //_getLastDateOfMonth(startDate);

      for (int i = 1; i <= lastDayDateTime; i++) {
        tempDays.add(i);
      }
      years = tempYears;
      days = tempDays;
      setState(() {});
    });
    super.initState();
  }

  // int _getLastDateOfMonth(DateTime date) {
  //   int lastDayDateTime = (date.month < 12)
  //       ? DateTime(date.year, date.month + 1, 0).day
  //       : DateTime(date.year + 1, 1, 0).day;
  //   return lastDayDateTime;
  // }

  @override
  Widget build(BuildContext context) {
    return (widget.isFromDesktop) ? desktopView(context) : mobileView(context);
  }

  Row mobileView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Flexible(
            flex: 2,
            child: DropDownField.mobile(
              context: context,
              key: const Key(KeyConstant.dateDropDown),
              title: LocalizationHandler.of().birthdate,
              isRequired: true,
              validator: (value) {
                if (!Validator.isNullOrEmpty(
                      selectedDate?.month,
                    ) &&
                    Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectDate;
                }
                return null;
              },
              hint: LocalizationHandler.of().date,
              items: days
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '$item',
                        style: InputFieldStyleMobile.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate?.date,
              onChanged: widget.enable
                  ? (int? value) {
                      setState(() {
                        selectedDate = DateOfBirth(
                          year: selectedDate?.year,
                          month: selectedMonth?.code,
                          date: value,
                        );
                      });
                      widget.onDateChange!(selectedDate);
                    }
                  : null,
            ),
          ),
          Flexible(
            flex: 2,
            child: DropDownField.mobile(
              context: context,
              key: const Key(KeyConstant.monthDropDown),
              validator: (value) {
                // Validator.isNullOrEmpty(value)
                //     ? isDayMonthSelected = false : isDayMonthSelected = true;
                if (!Validator.isNullOrEmpty(
                      selectedDate?.date,
                    ) &&
                    Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectMonth;
                }
                return null;
              },
              hint: LocalizationHandler.of().month,
              items: _months
                  .map(
                    (item) => DropdownMenuItem<Month>(
                      value: item,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: InputFieldStyleMobile.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedMonth,
              onChanged: widget.enable
                  ? (Month? value) {
                      selectedMonth = value;
                      /*  int lastDayDateTime = (value!.code < 12)
                  ? DateTime(selectedDate?.year ?? startDate.year, value.code + 1, 0).day
                  : DateTime(selectedDate?.year ?? startDate.year + 1, 1, 0).day;
              days.clear();
              for (int i = 1; i <= lastDayDateTime; i++) {
                days.add(i);
              }*/
                      setState(() {
                        /* int day = selectedDate?.date ?? 0;
                if (lastDayDateTime < day) {
                  day = lastDayDateTime;
                }*/
                        selectedDate = DateOfBirth(
                          year: selectedDate?.year,
                          month: selectedMonth?.code,
                          date: selectedDate?.date,
                        );
                        widget.onDateChange!(selectedDate);
                      });
                    }
                  : null,
            ),
          ),
          Flexible(
            flex: 2,
            child: DropDownField.mobile(
              context: context,
              isRequired: true,
              key: const Key(KeyConstant.yearDropDown),
              hint: LocalizationHandler.of().year,
              validator: (value) {
                // if (isDayMonthSelected == false) {
                //   return '';
                // }
                if (Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectYear;
                }
                return null;
              },
              items: years
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '$item',
                        style: InputFieldStyleMobile.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate?.year,
              onChanged: widget.enable
                  ? (int? value) {
                      /*int lastDayDateTime = DateTime(value! + 1, 1, 0).day;
                    if (selectedMonth != null) {
                      lastDayDateTime = (selectedMonth!.code < 12)
                          ? DateTime(value, selectedMonth!.code + 1, 0).day
                          : DateTime(value + 1, 1, 0).day;
                    }
                    days.clear();
                    for (int i = 1; i <= lastDayDateTime; i++) {
                      days.add(i);
                    }*/

                      setState(() {
                        /*int? day = selectedDate?.date;
                      if (day != null && lastDayDateTime < day) {
                        day = lastDayDateTime;
                      }*/
                        selectedDate = DateOfBirth(
                          year: value,
                          month: selectedMonth?.code,
                          date: selectedDate?.date,
                        );
                        widget.onDateChange!(selectedDate);
                      });
                    }
                  : null,
            ),
          )
        ],
        interItemSpace: Dimen.d_12,
      ),
    );
  }

  Widget desktopView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Flexible(
            flex: 2,
            child: DropDownField.desktop(
              context: context,
              key: const Key(KeyConstant.dateDropDown),
              title: LocalizationHandler.of().birthdate,
              isRequired: true,
              validator: (value) {
                if (!Validator.isNullOrEmpty(
                      selectedDate?.month,
                    ) &&
                    Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectDate;
                }
                return null;
              },
              hint: LocalizationHandler.of().date,
              items: days
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '$item',
                        style: InputFieldStyleDesktop.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate?.date,
              onChanged: widget.enable
                  ? (int? value) {
                      setState(() {
                        selectedDate = DateOfBirth(
                          year: selectedDate?.year,
                          month: selectedMonth?.code,
                          date: value,
                        );
                      });
                      widget.onDateChange!(selectedDate);
                    }
                  : null,
            ),
          ),
          Flexible(
            flex: 2,
            child: DropDownField.desktop(
              context: context,
              key: const Key(KeyConstant.monthDropDown),
              validator: (value) {
                // Validator.isNullOrEmpty(value)
                //     ? isDayMonthSelected = false : isDayMonthSelected = true;
                if (!Validator.isNullOrEmpty(
                      selectedDate?.date,
                    ) &&
                    Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectMonth;
                }
                return null;
              },
              hint: LocalizationHandler.of().month,
              items: _months
                  .map(
                    (item) => DropdownMenuItem<Month>(
                      value: item,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: InputFieldStyleDesktop.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedMonth,
              onChanged: widget.enable
                  ? (Month? value) {
                      selectedMonth = value;
                      /*  int lastDayDateTime = (value!.code < 12)
                  ? DateTime(selectedDate?.year ?? startDate.year, value.code + 1, 0).day
                  : DateTime(selectedDate?.year ?? startDate.year + 1, 1, 0).day;
              days.clear();
              for (int i = 1; i <= lastDayDateTime; i++) {
                days.add(i);
              }*/
                      setState(() {
                        /* int day = selectedDate?.date ?? 0;
                if (lastDayDateTime < day) {
                  day = lastDayDateTime;
                }*/
                        selectedDate = DateOfBirth(
                          year: selectedDate?.year,
                          month: selectedMonth?.code,
                          date: selectedDate?.date,
                        );
                        widget.onDateChange!(selectedDate);
                      });
                    }
                  : null,
            ),
          ),
          Flexible(
            flex: 2,
            child: DropDownField.desktop(
              context: context,
              isRequired: true,
              hint: LocalizationHandler.of().year,
              key: const Key(KeyConstant.yearDropDown),
              validator: (value) {
                // if (isDayMonthSelected == false) {
                //   return '';
                // }
                if (Validator.isNullOrEmpty(value)) {
                  return LocalizationHandler.of().pleaseSelectYear;
                }
                return null;
              },
              items: years
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '$item',
                        style: InputFieldStyleDesktop.inputFieldStyle,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate?.year,
              onChanged: widget.enable
                  ? (int? value) {
                      /*int lastDayDateTime = DateTime(value! + 1, 1, 0).day;
                    if (selectedMonth != null) {
                      lastDayDateTime = (selectedMonth!.code < 12)
                          ? DateTime(value, selectedMonth!.code + 1, 0).day
                          : DateTime(value + 1, 1, 0).day;
                    }
                    days.clear();
                    for (int i = 1; i <= lastDayDateTime; i++) {
                      days.add(i);
                    }*/

                      setState(() {
                        /*int? day = selectedDate?.date;
                      if (day != null && lastDayDateTime < day) {
                        day = lastDayDateTime;
                      }*/
                        selectedDate = DateOfBirth(
                          year: value,
                          month: selectedMonth?.code,
                          date: selectedDate?.date,
                        );
                        widget.onDateChange!(selectedDate);
                      });
                    }
                  : null,
            ),
          )
        ],
        interItemSpace: Dimen.d_12,
      ),
    );
  }
}

/*typedef OnDateChange = Function(DateTime date);

class DatePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime selectedDate;
  final OnDateChange? onDateChange;
  final bool enable;

  const DatePicker({
    super.key,
    this.startDate,
    this.endDate,
    required this.selectedDate,
    this.onDateChange,
    this.enable=true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime startDate;
  late DateTime lastDate;
  late DateTime selectedDate;

  final List<Month> _months = [
    Month('January', 1),
    Month('February', 2),
    Month('March', 3),
    Month('April', 4),
    Month('May', 5),
    Month('June', 6),
    Month('July', 7),
    Month('August', 8),
    Month('September', 9),
    Month('October', 10),
    Month('November', 11),
    Month('December', 12),
  ];
  List<int> years = [];
  List<int> days = [];
  Month? selectedMonth;

  @override
  void initState() {
    startDate = widget.startDate ?? DateTime(DateTime.now().year - 50);
    lastDate = widget.endDate ?? DateTime.now();
    selectedDate = widget.selectedDate;
    years.add(selectedDate.year);

    days.add(selectedDate.day);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<int> tempYears = [];
      List<int> tempDays = [];
      for (int i = startDate.year; i <= lastDate.year; i++) {
        tempYears.add(i);
      }
      selectedMonth = _months[startDate.month - 1];

      int lastDayDateTime = _getLastDateOfMonth(startDate);

      for (int i = 1; i <= lastDayDateTime; i++) {
        tempDays.add(i);
      }
      years = tempYears;
      days = tempDays;
      setState(() {});
    });
    super.initState();
  }

  int _getLastDateOfMonth(DateTime date) {
    int lastDayDateTime = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 0).day
        : DateTime(date.year + 1, 1, 0).day;
    return lastDayDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: WidgetUtility.spreadWidgets(
        [
          Flexible(
            child: CustomDropdownButtonFormField2(
              icon: const CustomDropDownArrowIcon(),
              key: const Key('selectdayDrpDwn'),
             // decoration: abhaSingleton.getBorderDecoration.getDropdownRectangularBorder(),
              isExpanded: true,
              validator: (value) {
                if (Validator.isNullOrEmpty(value)) {
                  return 'Please Select Day';
                }
                return null;
              },
              items: days
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '  $item',
                        style: CustomTextStyle.bodySmall(
                          context,
                        )?.apply(),
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate.day,
              onChanged: widget.enable? (int? value) {
                int day = value!;
                setState(() {
                  selectedDate =
                      DateTime(selectedDate.year, selectedMonth!.code, day);
                });
                widget.onDateChange!(selectedDate);
              }: null,
              buttonWidth: Dimen.d_280,
              buttonHeight: Dimen.d_25,
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomDropdownButtonFormField2(
              icon:const CustomDropDownArrowIcon(),
              key: const Key('selectmonthDrdpDwn'),
              //decoration: abhaSingleton.getBorderDecoration.getDropdownRectangularBorder(),
              isExpanded: true,
              validator: (value) {
                if (Validator.isNullOrEmpty(value)) {
                  return 'Please Select Month';
                }
                return null;
              },
              items: _months
                  .map(
                    (item) => DropdownMenuItem<Month>(
                      value: item,
                      child: Text(
                        '  ${item.name}',
                        style: CustomTextStyle.bodySmall(
                          context,
                        )?.apply(),
                      ),
                    ),
                  )
                  .toList(),
              value: selectedMonth,
              onChanged: widget.enable? (Month? value) {
                selectedMonth = value;
                int lastDayDateTime = (value!.code < 12)
                    ? DateTime(selectedDate.year, value.code + 1, 0).day
                    : DateTime(selectedDate.year + 1, 1, 0).day;
                days.clear();
                for (int i = 1; i <= lastDayDateTime; i++) {
                  days.add(i);
                }

                setState(() {
                  int day = selectedDate.day;
                  if (lastDayDateTime < day) {
                    day = lastDayDateTime;
                  }
                  selectedDate = DateTime(selectedDate.year, value.code, day);
                  widget.onDateChange!(selectedDate);
                });
              }
              : null,
              buttonWidth: Dimen.d_280,
              buttonHeight: Dimen.d_25,
            ),
          ),
          Flexible(
            flex: 2,
            child: CustomDropdownButtonFormField2(
              icon: const CustomDropDownArrowIcon(),
              key: const Key('selectYearDrpDown'),
             // decoration: abhaSingleton.getBorderDecoration.getDropdownRectangularBorder(),
              isExpanded: true,
              validator: (value) {
                if (Validator.isNullOrEmpty(value)) {
                  return 'Please Select Year';
                }
                return null;
              },
              items: years
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                        '  $item',
                        style: CustomTextStyle.bodySmall(
                          context,
                        )?.apply(),
                      ),
                    ),
                  )
                  .toList(),
              value: selectedDate.year,
              onChanged: widget.enable
                  ? (int? value) {
                int lastDayDateTime = (selectedMonth!.code < 12)
                    ? DateTime(value!, selectedMonth!.code + 1, 0).day
                    : DateTime(value! + 1, 1, 0).day;
                days.clear();
                for (int i = 1; i <= lastDayDateTime; i++) {
                  days.add(i);
                }

                setState(() {
                  int day = selectedDate.day;
                  if (lastDayDateTime < day) {
                    day = lastDayDateTime;
                  }
                  selectedDate = DateTime(value, selectedMonth!.code, day);
                  widget.onDateChange!(selectedDate);
                });
              }
              : null,
              buttonWidth: Dimen.d_280,
              buttonHeight: Dimen.d_25,
            ),
          )
        ],
        interItemSpace: Dimen.d_12,
      ),
    );
  }
}*/
