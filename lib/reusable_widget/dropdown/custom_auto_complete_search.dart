import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';

class CustomAutoCompleteSearch extends StatelessWidget {
  final List<LocalSearch> list;

  final AppTextController? searchController;
  final void Function(LocalSearch)? onSelected;
  final String? Function(String?)? validator;
  final String hintText;
  final String? title;
  final String? info;
  final bool isRequired;

  const CustomAutoCompleteSearch({
    required this.list,
    required this.validator,
    required this.onSelected,
    required this.hintText,
    super.key,
    this.searchController,
    this.title,
    this.isRequired = false,
    this.info,
  });

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
        AutocompleteSearch<LocalSearch>(
          key: key,
          optionsBuilder: (TextEditingValue textEditingValue) {
            return list
                .where(
                  (LocalSearch option) => option.title
                      .toString()
                      .toLowerCase()
                      .startsWith(textEditingValue.text.toLowerCase()),
                )
                .toList();
          },
          displayStringForOption: (LocalSearch option) =>
              option.title.toTitleCase(),
          // initialValue: searchController?.value,
          textEditingController: searchController,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              decoration: AppTextFormDecoration().underLineBorderDecoration(
                context: context,
                hintText: hintText,
              ),
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              validator: validator,
              style: InputFieldStyleMobile.inputFieldStyle,
              onFieldSubmitted: (_) {
                fieldTextEditingController.clear();
              },
            );
          },
          onSelected: onSelected,
        ),
      ],
    );
  }
}
