// import 'package:abha/export_packages.dart';
// import 'package:abha/main_dev.dart' as app;
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('end-to-end test', () {
//     testWidgets('select language and accept consent',
//         (WidgetTester tester) async {
//       app.main();
//       await tester.pumpAndSettle();
//       await Future.delayed(const Duration(seconds: 14));
//       await tester.pumpAndSettle(const Duration(seconds: 12));

//       await Future.delayed(const Duration(seconds: 14));
//       await Future.delayed(const Duration(seconds: 14));

//       Finder clickEnglishText = find.text(LocalizationConstant.english);
//       await tester.tap(clickEnglishText);
//       await Future.delayed(const Duration(seconds: 2));

//       Finder clickContinueBtn =
//           find.text(LocalizationHandler.of().continuee.toUpperCase());
//       await Future.delayed(const Duration(seconds: 2));
//       await tester.tap(clickContinueBtn);
//       await Future.delayed(const Duration(seconds: 12));

//       Finder clickAgreeBtn =
//           find.text(LocalizationHandler.of().agree.toUpperCase());
//       await Future.delayed(const Duration(seconds: 2));
//       await tester.tap(clickAgreeBtn);
//       await Future.delayed(const Duration(seconds: 12));

//       await Future.delayed(const Duration(seconds: 12));
//     });

//     // testWidgets('do a login with abha address and password',
//     //     (WidgetTester tester) async {
//     //   app.main();
//     //   await tester.pumpAndSettle();
//     //   await Future.delayed(const Duration(seconds: 4));
//     //   await tester.pumpAndSettle(const Duration(seconds: 2));

//     //   await Future.delayed(const Duration(seconds: 4));

//     //   Finder clickenglishText = find.byKey(const Key('englishText'));
//     //   await tester.tap(clickenglishText);
//     //   await Future.delayed(const Duration(seconds: 2));

//     //   Finder clickagreeBtn = find.byKey(const Key('agreeBtn'));
//     //   await tester.tap(clickagreeBtn);
//     //   await Future.delayed(const Duration(seconds: 2));

//     //   await Future.delayed(const Duration(seconds: 2));
//     // });
//   });
// }
