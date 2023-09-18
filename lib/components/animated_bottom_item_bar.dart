import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AnimatedBottomItemBar extends StatelessWidget {
  const AnimatedBottomItemBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2.0),
      height: 4,
      width: isActive ? 20.0 : 0.0,
      decoration: BoxDecoration(
        color: upperBarBottomItemColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
