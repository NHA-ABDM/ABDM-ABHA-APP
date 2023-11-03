import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dropdown/decoration/drop_down_field_decoration.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';
import 'package:flutter/scheduler.dart';

/// {@macro flutter.widgets.RawAutocomplete.RawAutocomplete}
///
/// {@tool dartpad}
/// This example shows how to create a very basic Autocomplete widget using the
/// default UI.
///
/// ** See code in examples/api/lib/material/autocomplete/autocomplete.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to create an Autocomplete widget with a custom type.
/// Try searching with text from the name or email field.
///
/// ** See code in examples/api/lib/material/autocomplete/autocomplete.1.dart **
/// {@end-tool}
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=-Nny8kzW380}
///
/// See also:
///
///  * [RawAutocomplete], which is what Autocomplete is built upon, and which
///    contains more detailed examples.
class AutocompleteSearch<T extends Object> extends StatelessWidget {
  /// Creates an instance of [Autocomplete].
  const AutocompleteSearch({
    required this.optionsBuilder,
    super.key,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.initialValue,
    this.textEditingController,
  });

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  ///
  /// If not provided, will build a standard Material-style text field by
  /// default.
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T>? onSelected;

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewBuilder}
  ///
  /// If not provided, will build a standard Material-style list of results by
  /// default.
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  /// The maximum height used for the default Material options list widget.
  ///
  /// When [optionsViewBuilder] is `null`, this property sets the maximum height
  /// that the options widget can occupy.
  ///
  /// The default value is set to 200.
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  final AppTextController? textEditingController;

  static Widget _defaultFieldViewBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return _AutocompleteField(
      focusNode: focusNode,
      textEditingController: textEditingController,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      textEditingController: textEditingController,
      focusNode: textEditingController?.focusNode,
      optionsViewBuilder: optionsViewBuilder ??
          (
            BuildContext context,
            AutocompleteOnSelected<T> onSelected,
            Iterable<T> options,
          ) {
            return _AutocompleteOptions<T>(
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              options: options,
              maxOptionsHeight: optionsMaxHeight,
            );
          },
      onSelected: onSelected,
    );
  }
}

// The default Material-style Autocomplete text field.
class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    required this.focusNode,
    required this.textEditingController,
    required this.onFieldSubmitted,
  });

  final FocusNode focusNode;

  final VoidCallback onFieldSubmitted;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        onFieldSubmitted();
      },
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
    super.key,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxOptionsHeight,
            maxWidth: context.width * 0.55,
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(
                  builder: (BuildContext context) {
                    final bool highlight =
                        AutocompleteHighlightedOption.of(context) == index;
                    if (highlight) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((Duration timeStamp) {
                        Scrollable.ensureVisible(context, alignment: 0.5);
                      });
                    }
                    return Container(
                      //color: highlight ? Theme.of(context).focusColor : null,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        displayStringForOption(option),
                        style: InputFieldStyleMobile.inputFieldStyle,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    ).marginOnly(top: Dimen.d_5);
  }
}

class SearchableDropdown<T> extends StatelessWidget {
  final TextEditingController controller;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final bool isRequired;
  final FormFieldValidator<T>? validator;
  final String? hint;
  final String? searchHint;
  final String? info;

  const SearchableDropdown({
    required this.controller,
    Key? key,
    this.items,
    this.value,
    this.onChanged,
    this.title,
    this.isRequired = false,
    this.validator,
    this.hint,
    this.info,
    this.searchHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: title ?? '',
                style: InputFieldStyleMobile.labelTextStyle,
                children: <TextSpan>[
                  if (isRequired)
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
        ).marginOnly(bottom: 4),
        CustomDropdownButtonFormField2<T>(
          title: title,
          isRequired: isRequired,
          offset: const Offset(0, -10),
          icon: const CustomDropDownArrowIcon(),
          decoration:
              DropDownDecoration().circularBorderDecoration(context: context),
          key: key,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          searchController: controller,
          dropdownMaxHeight: Dimen.d_250,
          alignment: Alignment.centerLeft,
          dropdownPadding: EdgeInsets.zero,
          dropdownElevation: 1,
          isExpanded: true,
          searchMatchFn: (a, searchValue) {
            return a.value
                .toString()
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
          onMenuStateChange: (isOpen) {
            controller.clear();
          },
          searchInnerWidget: TextFormField(
            controller: controller,
            style: InputFieldStyleDesktop.hintTextStyle,
            decoration: InputDecoration(
              isDense: true,
              hintText: searchHint,
              hintStyle: CustomTextStyle.titleMedium(context)?.apply(
                color: AppColors.colorGreyDark,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide:
                    const BorderSide(color: AppColors.colorPurple4, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: InputFieldStyleDesktop.focusedBorderColor,
                  width: 0.5,
                ),
              ),
            ),
          ),
          hint: Text(
            hint ?? '',
            style: InputFieldStyleDesktop.hintTextStyle,
          ),
          items: items,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
