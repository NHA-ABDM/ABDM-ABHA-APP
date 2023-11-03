part of 'extension.dart';

///
/// Extension Method for the [Visibility] Widget
///
extension VisibilityX on Widget {
  Visibility visibilityGone({required bool visible}) => Visibility(
        key: key,
        visible: visible,
        child: this,
      );

  Visibility visibilityInvisible({required bool visible}) => Visibility(
        key: key,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: visible,
        child: this,
      );
}
