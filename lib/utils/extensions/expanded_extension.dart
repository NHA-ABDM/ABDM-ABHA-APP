part of 'extension.dart';

///
/// Extension Method for the [Padding] Widget
///
extension ExpanedX on Widget {
  Expanded expand({
    int flex = 1,
  }) =>
      Expanded(flex: flex, child: this);
}

extension FlexibleX on Widget {
  Flexible flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);
}
