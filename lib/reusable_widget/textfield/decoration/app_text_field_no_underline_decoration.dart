import 'package:flutter/material.dart';

class AppTextFormNoUnderlineDecoration {
  InputDecoration getDefaultDecoration({
    required BuildContext context,
  }) {
    return const InputDecoration(border: InputBorder.none, counterText: '',);
  }
}
