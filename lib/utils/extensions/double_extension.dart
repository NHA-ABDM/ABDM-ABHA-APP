part of 'extension.dart';

extension WidgetExtension on Widget {
  Widget sizedBox({
    double? width,
    double? height,
  }) =>
      SizedBox(width: width, height: height, child: this);
}
