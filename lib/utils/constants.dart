import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'shared_preference_utils.dart';

const String myUrlSupabase = 'https://ifmptntkvcodjikynhjf.supabase.co';
const String myAnonKeySupabase =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmbXB0bnRrdmNvZGppa3luaGpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQ2ODU3NTYsImV4cCI6MjAxMDI2MTc1Nn0.SghKJ1otmKn0t1L7vtOlcRB5rzGHFsjpn-dW2wDpwlI';
const String emailKey = 'EMAIL';
const String passwordKey = 'PASSWORD';

const kPrimaryColor = Color(0xFF9400FF);
const kScaffoldBackgroundColorLight = Color(0xFFFAF0E6);
const kPrimaryColorDark = Color(0xFF5C5470);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kErrorColor = Color(0xFFF03738);
const bgBottomNavBarColor = Color(0xFF17203A);
const upperBarBottomItemColor = Color(0xFF8184FF);

/// Supabase client
final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader = Center(
  child: CircularProgressIndicator(
    color: kPrimaryColor,
  ),
);

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 18, height: 18);

/// Some paddig for all the form to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occur
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Outline border of the message content
final outlineBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(20.0),
);

/// Sets of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Displays a red snackbar indidating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: kErrorColor);
  }

  /// Is `dark` mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

/// Set Email and Password to cache
void setEmailAndPassword({required String email, required String password}) {
  SharedPreferenceUtils preferenceUtils = SharedPreferenceUtils();
  preferenceUtils.write(emailKey, email);
  preferenceUtils.write(passwordKey, password);
}
