import 'package:flutter_test/flutter_test.dart';
import 'package:misoles_labactivity3/main.dart';

void main() {
  testWidgets('Smoke test: AuthPage loads and toggles between login and register',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LoginRegisterApp());

    // Expect initial Login UI
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Log in'), findsOneWidget);

    // Switch to Register
    final switchButton = find.text('No account yet? Register');
    expect(switchButton, findsOneWidget);
    await tester.tap(switchButton);
    await tester.pumpAndSettle();

    // Verify registration view
    expect(find.text('Register'), findsWidgets);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });
}
