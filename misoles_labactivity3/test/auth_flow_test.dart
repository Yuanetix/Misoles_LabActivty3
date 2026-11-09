import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misoles_labactivity3/main.dart';

void main() {
  testWidgets('Complete Lab Activity 3 validation and auth flow test',
      (WidgetTester tester) async {
    // Configure standard mobile portrait dimensions for testing
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const LoginRegisterApp());

    // 1. Attempt login before registering -> form validation triggers first
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Required field validation triggers first
    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);

    // Switch to Register
    final switchRegisterButton = find.text('No account yet? Register');
    await tester.ensureVisible(switchRegisterButton);
    await tester.tap(switchRegisterButton);
    await tester.pumpAndSettle();

    // 2. Test registration validation: empty fields
    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
    expect(find.text('Please confirm your password.'), findsOneWidget);

    // 3. Test invalid email format & short password (< 8 chars)
    final nameField = find.widgetWithText(TextFormField, 'Full Name');
    final emailField = find.widgetWithText(TextFormField, 'Email');
    final passwordField = find.widgetWithText(TextFormField, 'Password');
    final confirmPasswordField =
        find.widgetWithText(TextFormField, 'Confirm Password');

    await tester.enterText(nameField, 'Juan Dela Cruz');
    await tester.enterText(emailField, 'juan'); // Invalid email
    await tester.enterText(passwordField, 'short'); // < 8 characters
    await tester.enterText(confirmPasswordField, 'different'); // Mismatch

    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email.'), findsOneWidget);
    expect(find.text('Use at least 8 characters.'), findsOneWidget);
    expect(find.text('Passwords do not match.'), findsOneWidget);

    // 4. Register with valid details
    await tester.enterText(emailField, 'juan@example.com');
    await tester.enterText(passwordField, 'flutter123'); // 10 chars >= 8
    await tester.enterText(confirmPasswordField, 'flutter123');

    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    // Expect SnackBar "Registration successful! Please log in." and returned to Login
    expect(find.text('Registration successful! Please log in.'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    // 5. Attempt login with wrong password
    final loginSubmitButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.enterText(emailField, 'juan@example.com');
    await tester.enterText(passwordField, 'wrongpass123');
    await tester.ensureVisible(loginSubmitButton);
    await tester.tap(loginSubmitButton);
    await tester.pumpAndSettle();
    expect(find.text('Incorrect email or password.'), findsOneWidget);

    // 6. Login with correct credentials
    await tester.enterText(passwordField, 'flutter123');
    await tester.ensureVisible(loginSubmitButton);
    await tester.tap(loginSubmitButton);
    await tester.pumpAndSettle();

    // Expect Welcome Screen
    expect(find.text('Welcome, Juan Dela Cruz!'), findsOneWidget);
    expect(find.text('juan@example.com'), findsOneWidget);

    // 7. Logout
    final logoutButton = find.widgetWithText(ElevatedButton, 'Logout');
    expect(logoutButton, findsOneWidget);
    await tester.ensureVisible(logoutButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Verify back to login
    expect(find.text('Log in'), findsOneWidget);
  });
}
