import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dropdown/decoration/drop_down_field_decoration.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';

class DropDownField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final bool isRequired;
  final FormFieldValidator<T>? validator;
  final String? hint;
  final String? info;
  final BuildContext context;
  final VoidCallback? onClick;

  TextStyle? titleStyle;
  TextStyle? hintStyle;
  InputDecoration? decoration;

  DropDownField({
    required this.context,
    Key? key,
    this.items,
    this.value,
    this.onChanged,
    this.title,
    this.isRequired = false,
    this.validator,
    this.hint,
    this.info,
    this.onClick,
  }) : super(key: key);

  DropDownField.mobile({
    required this.context,
    super.key,
    this.items,
    this.value,
    this.onChanged,
    this.title,
    this.isRequired = false,
    this.validator,
    this.hint,
    this.info,
    this.onClick,
  }) {
    titleStyle = InputFieldStyleMobile.labelTextStyle;
    hintStyle = InputFieldStyleMobile.hintTextStyle;
    decoration = DropDownDecoration().underLineBorderDecoration(
      context: context,
      hintText: LocalizationHandler.of().pleaseSelectGender,
    );
  }

  DropDownField.desktop({
    required this.context,
    super.key,
    this.items,
    this.value,
    this.onChanged,
    this.title,
    this.isRequired = false,
    this.validator,
    this.hint,
    this.info,
    this.onClick,
  }) {
    titleStyle = InputFieldStyleDesktop.labelTextStyle;
    hintStyle = InputFieldStyleDesktop.hintTextStyle;
    decoration = DropDownDecoration().circularBorderDecoration(
      context: context,
      hintText: LocalizationHandler.of().pleaseSelectGender,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: title ?? '',
                style: titleStyle,
                children: <TextSpan>[
                  if (isRequired && !Validator.isNullOrEmpty(title))
                    TextSpan(
                      text: '*',
                      style: InputFieldStyleDesktop.labelMandatoryTextStyle,
                    ),
                ],
              ),
            ),
            if (!Validator.isNullOrEmpty(info))
              CustomToolTipMessage(
                message: info ?? '',
              ).marginOnly(left: Dimen.d_5)
          ],
        ).marginOnly(bottom: Validator.isNullOrEmpty(title) ? 6 : 4),
        Row(
          children: [
            if (onClick != null)
              Expanded(
                child: GestureDetector(
                  onTap: onClick,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimen.d_4,
                      horizontal: Dimen.d_0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: InputFieldStyleMobile.focusedBorderColor,
                          width: InputFieldStyleMobile.borderWidth,
                        ),
                        // border: (
                        //   borderSide: BorderSide(
                        //     color: InputFieldStyleMobile.focusedBorderColor,
                        //     width: InputFieldStyleMobile.borderWidth,
                        //   ),
                        // )
                      ),
                    ),
                    child: (value != null)
                        ? Text(value.toString())
                        : Text(hint ?? ''),
                  ),
                ),
              )
            else
              Expanded(
                child: CustomDropdownButtonFormField2<T>(
                  title: title,
                  isRequired: isRequired,
                  icon: const CustomDropDownArrowIcon(),
                  decoration: decoration,
                  key: key,
                  validator: validator,
                  dropdownMaxHeight: Dimen.d_250,
                  dropdownPadding: EdgeInsets.zero,
                  dropdownElevation: 1,
                  isExpanded: true,
                  searchMatchFn: (a, searchValue) {
                    return a.value
                        .toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                  hint: RichText(
                    text: TextSpan(
                      text: hint ?? '',
                      style: hintStyle,
                      children: <TextSpan>[
                        if (isRequired && Validator.isNullOrEmpty(title))
                          TextSpan(
                            text: '*',
                            style:
                                InputFieldStyleDesktop.labelMandatoryTextStyle,
                          ),
                      ],
                    ),
                  ),
                  items: items,
                  value: value,
                  onChanged: onChanged,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ClickableDropDown<T> extends FormField<T> {
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final bool isRequired;
  final String? hint;
  final String? info;
  final BuildContext context;
  final VoidCallback? onClick;

  ClickableDropDown({
    required this.context,
    super.key,
    this.value,
    AutovalidateMode? autoValidateMode,
    InputDecoration? decoration,
    this.hint,
    this.onClick,
    this.title,
    this.items,
    this.isRequired = true,
    this.onChanged,
    super.validator,
    this.info,
  }) : super(
          initialValue: value,
          autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            bool hasFocus = false;
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: title ?? '',
                          style: InputFieldStyleMobile.labelTextStyle,
                          children: <TextSpan>[
                            if (isRequired)
                              TextSpan(
                                text: '*',
                                style: InputFieldStyleMobile
                                    .labelMandatoryTextStyle,
                              ),
                          ],
                        ),
                      ).marginOnly(bottom: Dimen.d_4),
                      InputDecorator(
                        decoration: decoration?.copyWith(
                              errorText: field.errorText,
                            ) ??
                            InputDecoration(
                              counterText: '',
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: Dimen.d_12),
                              suffixIconConstraints:
                                  BoxConstraints(maxHeight: Dimen.d_32),
                            ),
                        isFocused: hasFocus,
                        textAlignVertical: TextAlignVertical.bottom,
                        child: DropdownButtonHideUnderline(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              onClick!();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (value != null)
                                  Text(
                                    value.toString(),
                                    style:
                                        InputFieldStyleMobile.inputFieldStyle,
                                  )
                                else
                                  Text(
                                    hint ?? '',
                                    style: InputFieldStyleMobile.hintTextStyle,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _ClickableDropDownFormFieldState<T>();
}

class _ClickableDropDownFormFieldState<T> extends FormFieldState<T> {
  @override
  void didChange(T? value) {
    super.didChange(value);
    final ClickableDropDown<T> dropdownButtonFormField =
        widget as ClickableDropDown<T>;
    assert(dropdownButtonFormField.initialValue != null);
    assert(widget.initialValue != null);
  }

  @override
  void didUpdateWidget(ClickableDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
