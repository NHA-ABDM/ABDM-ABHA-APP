import 'package:abha/export_packages.dart';

class AppTextField extends StatefulWidget {
  final String? title;
  final bool isPassword;
  final int maxLength;
  final AppTextController textEditingController;
  final TextInputType? textInputType;
  final TextInputAction textInputAction;
  final int maxLines;
  final bool autofocus;
  final bool showCursor;
  final TextCapitalization textCapitalization;
  final Color cursorColor;
  final Color textColor;
  final int fontWeightDelta;
  final double fontSizeDelta;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final Widget? suffixTwo;
  final TextStyle? titleStyle;
  final TextStyle? errorStyle;
  final bool readOnly;
  final InputDecoration? decoration;

  const AppTextField({
    required this.textEditingController,
    super.key,
    this.title,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength = 100,
    this.autofocus = false,
    this.showCursor = true,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor = AppColors.colorBlack,
    this.textColor = AppColors.colorBlack,
    this.fontWeightDelta = 0,
    this.fontSizeDelta = 0,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.suffix,
    this.suffixTwo,
    this.titleStyle,
    this.errorStyle,
    this.readOnly = false,
    this.decoration,
  });

  @override
  State<AppTextField> createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
  late FocusNode focusNode;
  late Color bottomIndicatorColor;

  @override
  void initState() {
    focusNode = widget.textEditingController.focusNode;
    bottomIndicatorColor = Colors.black12;
    focusNode.addListener(() {
      focusNode.requestFocus();
      setState(() {
        if (focusNode.hasFocus) {
          if (widget.textEditingController.error.isNotEmpty) {
            bottomIndicatorColor = AppColors.colorRed;
          } else {
            bottomIndicatorColor = Theme.of(context).primaryColor;
          }
        } else {
          if (widget.textEditingController.error.isNotEmpty) {
            bottomIndicatorColor = AppColors.colorRed;
          } else {
            bottomIndicatorColor = (widget.textEditingController.enabled)
                ? AppColors.colorBlack
                : AppColors.colorGreyLight2;
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Validator.isNullOrEmpty(widget.title)
        ? TextField(
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            autofocus: widget.autofocus,
            obscureText: widget.isPassword,
            controller: widget.textEditingController,
            enabled: widget.textEditingController.enabled,
            inputFormatters: widget.textEditingController.inputFormatters,
            onChanged: widget.onChanged,
            cursorColor: widget.cursorColor,
            showCursor: widget.showCursor,
            maxLength: widget.maxLength,
            textCapitalization: widget.textCapitalization,
            textAlign: widget.textAlign,
            focusNode: widget.focusNode,
            readOnly: widget.readOnly,
            onEditingComplete: widget.onEditingComplete,
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: widget.textColor,
              fontWeightDelta: widget.fontWeightDelta,
              fontSizeDelta: widget.fontSizeDelta,
              letterSpacingDelta: 0.5,
            ),
            decoration:
                widget.decoration ?? const InputDecoration(counterText: ''),
          )
        : AnimatedBuilder(
            animation: widget.textEditingController,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? '',
                    style: widget.titleStyle ??
                        CustomTextStyle.titleSmall(context)
                            ?.apply(color: AppColors.colorGreyDark7),
                  ).marginOnly(bottom: Dimen.d_10),
                  Row(
                    children: WidgetUtility.spreadWidgets([
                      Expanded(
                        child: TextField(
                          keyboardType: widget.textInputType,
                          textInputAction: widget.textInputAction,
                          maxLines: widget.maxLines,
                          autofocus: widget.autofocus,
                          obscureText: widget.isPassword,
                          controller: widget.textEditingController,
                          enabled: widget.textEditingController.enabled,
                          inputFormatters:
                              widget.textEditingController.inputFormatters,
                          onChanged: widget.textEditingController.onTextChanged,
                          cursorColor: widget.cursorColor,
                          showCursor: widget.showCursor,
                          maxLength: widget.maxLength,
                          textCapitalization: widget.textCapitalization,
                          textAlign: widget.textAlign,
                          focusNode: focusNode,
                          onEditingComplete: widget.onEditingComplete,
                          style: CustomTextStyle.titleSmall(context)?.apply(
                            color: widget.textColor,
                            fontWeightDelta: widget.fontWeightDelta,
                            fontSizeDelta: widget.fontSizeDelta,
                          ),
                          decoration: widget.decoration ??
                              const InputDecoration(counterText: ''),
                        ),
                      ),
                      if (widget.textEditingController.enabled)
                        widget.suffixTwo
                      else
                        widget.suffix
                    ]),
                  ),
                  // Container(
                  //   height: 2,
                  //   color: bottomIndicatorColor,
                  // ),
                ],
              );
            },
          );
  }
}
