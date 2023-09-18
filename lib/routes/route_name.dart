import 'package:flutter/material.dart';

import '../pages/pages.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/splash';
  static const String signUpRoute = '/signup';
  static const String signInRoute = '/signin';
  static const String roomsRoute = '/rooms';
  static const String chatRoute = '/chat';
  static const String accountRoute = '/account';
  static const String settingsRoute = '/settings';
  static const String entryPointRoute = '/entryPointRoute';

  static Map<String, Widget> pages = {
    roomsRoute: const RoomsPage(),
    accountRoute: const AccountPage(),
    settingsRoute: const SettingsPage()
  };
}
