import 'package:rive/rive.dart';

class RiveAsset {
  final String artBoard;
  final String stateMachineName;
  final String title;
  final String src;
  late SMIBool? input;

  RiveAsset({
    this.src = "assets/RiveAssets/icons.riv",
    required this.artBoard,
    required this.stateMachineName,
    required this.title,
    this.input,
  });

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavItems = [
  RiveAsset(
      artBoard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Chat"),
  RiveAsset(
      artBoard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "Account"),
  RiveAsset(
      artBoard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
      title: "Settings"),
];
