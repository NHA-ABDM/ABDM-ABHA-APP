import 'package:abha/export_packages.dart';

class AutoFocusTextView extends StatelessWidget {
  final TextEditingController textEditingController;
  final StreamController<ErrorAnimationType>? errorController;
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final double width;
  final double height;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? fieldOuterPadding;

  const AutoFocusTextView({
    required this.textEditingController,
    required this.length,
    super.key,
    this.errorController,
    this.onChanged,
    this.onCompleted,
    this.width = 35,
    this.height = 50,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.fieldOuterPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: formKey,
      child: PinCodeTextField(
        appContext: context,
        mainAxisAlignment: mainAxisAlignment,
        autoDisposeControllers: false,
        pastedTextStyle: TextStyle(
          color: context.themeData.primaryColor,
          fontWeight: FontWeight.normal,
          fontSize: Dimen.d_10,
        ),
        length: length,
        obscureText: false,
        obscuringCharacter: '*',
        animationType: AnimationType.fade,
        validator: (v) {
          if (v!.length < length) {
            return '';
          } else {
            return null;
          }
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: height,
          fieldWidth: width,
          fieldOuterPadding: fieldOuterPadding,
          activeColor: AppColors.colorAppBlue,
          selectedColor: AppColors.colorAppBlue,
          inactiveColor: AppColors.colorGrey4,
          borderWidth: Dimen.d_1,
        ),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        cursorColor: AppColors.colorAppBlue,
        animationDuration: const Duration(milliseconds: 200),
        textStyle: CustomTextStyle.headlineLarge(context)?.apply(
          fontSizeDelta: -8,
        ),
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        onCompleted: onCompleted,
        onChanged: onChanged ?? (value) {},
        beforeTextPaste: (text) {
          // print('Allowing to paste $text');
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }
}
