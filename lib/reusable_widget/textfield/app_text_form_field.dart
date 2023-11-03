import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/toolTip/custom_tool_tip_message.dart';
import 'package:flutter/foundation.dart';

class AppTextFormField extends StatefulWidget {
  final String? title;
  final String? labelText;
  final bool isPassword;
  final int maxLength;
  final AppTextController textEditingController;
  final TextInputType? textInputType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int minLines;
  final bool autofocus;
  final bool showCursor;
  final TextCapitalization textCapitalization;
  final Color cursorColor;
  final Color textColor;
  final int fontWeightDelta;
  final double fontSizeDelta;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final String? helperText;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? suffixTwo;
  TextStyle? titleStyle;
  final TextStyle? errorStyle;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  late InputDecoration? decoration;
  final AutovalidateMode? autoValidateMode;
  final bool isRequired;
  final bool readOnly;
  final String? info;
  final String? hintText;
  TextStyle? style;

  AppTextFormField.desktop({
    required this.textEditingController,
    required BuildContext context,
    super.key,
    this.title,
    this.labelText,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = kIsWeb ? TextInputAction.none : TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength = 100,
    this.autofocus = false,
    this.showCursor = true,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor = AppColors.colorBlack6,
    this.textColor = AppColors.colorBlack6,
    this.fontWeightDelta = 0,
    this.fontSizeDelta = 0,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.helperText,
    this.onEditingComplete,
    this.onChanged,
    this.suffix,
    this.suffixTwo,
    this.titleStyle,
    this.errorStyle,
    this.validator,
    this.onSaved,
    InputDecoration? inputDecoration,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.isRequired = false,
    this.prefix,
    this.readOnly = false,
    this.info,
    this.hintText,
  }) {
    decoration = inputDecoration ??
        AppTextFormDecoration().circularBorderDecoration(
          context: context,
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
        );
    style = InputFieldStyleDesktop.inputFieldStyle;
    titleStyle = InputFieldStyleDesktop.labelTextStyle;
  }

  AppTextFormField.mobile({
    required this.textEditingController,
    required BuildContext context,
    super.key,
    this.title,
    this.labelText,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = kIsWeb ? TextInputAction.none : TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength = 100,
    this.autofocus = false,
    this.showCursor = true,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor = AppColors.colorBlack6,
    this.textColor = AppColors.colorBlack6,
    this.fontWeightDelta = 0,
    this.fontSizeDelta = 0,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.helperText,
    this.onEditingComplete,
    this.onChanged,
    this.suffix,
    this.suffixTwo,
    this.titleStyle,
    this.errorStyle,
    this.validator,
    this.onSaved,
    InputDecoration? inputDecoration,
    this.autoValidateMode =
        kIsWeb ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
    this.isRequired = false,
    this.prefix,
    this.readOnly = false,
    this.info,
    this.hintText,
  }) {
    decoration = inputDecoration ??
        AppTextFormDecoration().underLineBorderDecoration(
          context: context,
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
        );

    style = InputFieldStyleMobile.inputFieldStyle;
    titleStyle = InputFieldStyleMobile.labelTextStyle;
  }

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Validator.isNullOrEmpty(widget.title)
        ? TextFormField(
            autovalidateMode: widget.autoValidateMode,
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            obscureText: widget.isPassword,
            controller: widget.textEditingController,
            enabled: widget.textEditingController.enabled,
            inputFormatters: widget.textEditingController.inputFormatters,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            cursorColor: widget.cursorColor,
            showCursor: widget.showCursor,
            maxLength: widget.maxLength,
            textCapitalization: widget.textCapitalization,
            textAlign: widget.textAlign,
            focusNode: widget.focusNode,
            readOnly: widget.readOnly,
            onEditingComplete: widget.onEditingComplete,
            style: CustomTextStyle.bodyMedium(context)?.apply(
              color: widget.textColor,
              fontWeightDelta: widget.fontWeightDelta,
              fontSizeDelta: widget.fontSizeDelta,
            ),
            decoration: widget.decoration ??
                const InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  errorMaxLines: 3,
                ),
          )
        : AnimatedBuilder(
            animation: widget.textEditingController,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: widget.title ?? '',
                          style: widget.titleStyle,
                          children: <TextSpan>[
                            if (widget.isRequired)
                              TextSpan(
                                text: '*',
                                style: InputFieldStyleDesktop
                                    .labelMandatoryTextStyle,
                              ),
                          ],
                        ),
                      ),
                      if (!Validator.isNullOrEmpty(widget.info))
                        CustomToolTipMessage(
                          message: widget.info ?? '',
                        ).marginOnly(left: Dimen.d_5)
                    ],
                  ).marginOnly(bottom: 4),
                  Row(
                    children: WidgetUtility.spreadWidgets([
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: widget.autoValidateMode,
                          keyboardType: widget.textInputType,
                          textInputAction: widget.textInputAction,
                          validator: widget.validator,
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          autofocus: widget.autofocus,
                          obscureText: widget.isPassword,
                          controller: widget.textEditingController,
                          enabled: widget.textEditingController.enabled,
                          inputFormatters:
                              widget.textEditingController.inputFormatters,
                          onChanged: widget.onChanged,
                          onSaved: widget.onSaved,
                          cursorColor: widget.cursorColor,
                          showCursor: widget.showCursor,
                          maxLength: widget.maxLength,
                          textCapitalization: widget.textCapitalization,
                          textAlign: widget.textAlign,
                          focusNode: widget.focusNode,
                          readOnly: widget.readOnly,
                          onEditingComplete: widget.onEditingComplete,
                          style: widget.style,
                          decoration: widget.decoration,
                          // InputDecoration(
                          //     counterText: '',
                          //     isDense: true,
                          //     contentPadding: EdgeInsets.symmetric(vertical: Dimen.d_12),
                          //     icon: prefix,
                          //     suffixIcon: suffix,
                          //     hintText: helperText,
                          //     suffixIconConstraints: BoxConstraints(maxHeight: Dimen.d_32)),
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            },
          );
  }
}
