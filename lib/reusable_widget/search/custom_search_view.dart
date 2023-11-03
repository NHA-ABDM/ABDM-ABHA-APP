import 'package:abha/export_packages.dart';

class CustomSearchView extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hint;
  final bool autofocus;
  final AppTextController appTextController;
  const CustomSearchView({
    required this.appTextController,
    super.key,
    this.onChanged,
    this.hint,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      decoration: AppTextFormDecoration().getDefaultDecoration(
        context: context,
        hintText: hint ?? 'Search',
        prefixIcon: const Icon(
          IconAssets.search,
          color: AppColors.colorAppOrange,
        ),
        borderRadius: Dimen.d_8,
        borderColor: AppColors.colorGreyLight6,
        contentPaddingVertical: Dimen.d_1,
      ),
      textEditingController: appTextController,
      onChanged: onChanged,
      autofocus: autofocus,
    );
  }
}
