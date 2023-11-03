import 'package:abha/utils/validate/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppTextController extends TextEditingController {
  late String _error;
  late ValueChanged<String> _onTextChanged;
  late String _maskType;
  late bool _enabled;
  late FocusNode _focusNode;
  late List<TextInputFormatter> _inputFormatters;

  AppTextController({
    String text = '',
    String error = '',
    ValueChanged<String>? onTextChanged,
    String mask = '',
    bool enabled = true,
    FocusNode? focusNode,
    List<TextInputFormatter> inputFormatters = const [],
  }) {
    _error = error;
    _onTextChanged = onTextChanged ?? (_) {};
    _maskType = mask;
    _enabled = enabled;
    _focusNode = focusNode ?? FocusNode();
    _inputFormatters = inputFormatters;
    if (!Validator.isNullOrEmpty(_maskType)) {
      var maskFormatter = MaskTextInputFormatter(
        mask: _maskType,
      );
      _inputFormatters = [maskFormatter];
    }
    super.text = text;
  }

  bool get enabled => _enabled;
  set enabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  ValueChanged<String> get onTextChanged => _onTextChanged;
  set onTextChanged(ValueChanged<String> value) {
    _onTextChanged = (text) {
      error = '';
      value(text);
    };
  }

  FocusNode get focusNode => _focusNode;
  set focusNode(FocusNode fNode) {
    _focusNode = fNode;
  }

  List<TextInputFormatter> get inputFormatters => _inputFormatters;
  set inputFormatters(List<TextInputFormatter> inputFormatter) {
    _inputFormatters = inputFormatter;
  }

  String get maskType => _maskType;
  set maskType(String value) {
    _maskType = value;
  }
}
