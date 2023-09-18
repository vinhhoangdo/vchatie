import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:rive/rive.dart';

import '../components/components.dart';
import '../model/model.dart';
import '../utils/utils.dart';
import 'pages.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with AutomaticKeepAliveClientMixin {
  RiveAsset selectedBottomNavItem = bottomNavItems.first;
  int pageIndex = 0;

  @override
  void didChangeDependencies() {
    context.read<RoomCubit>().initializeRooms(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: AppRoute.pages.values.toList()[pageIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                bottomNavItems.length,
                (index) => GestureDetector(
                  onTap: () {
                    bottomNavItems[index].input!.change(true);

                    Future.delayed(const Duration(seconds: 1), () {
                      bottomNavItems[index].input!.change(false);
                    });
                    if (bottomNavItems[index] != selectedBottomNavItem) {
                      setState(() {
                        selectedBottomNavItem = bottomNavItems[index];
                      });
                      pageIndex = index;
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBottomItemBar(
                          isActive:
                              bottomNavItems[index] == selectedBottomNavItem),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity:
                              bottomNavItems[index] == selectedBottomNavItem
                                  ? 1
                                  : 0.5,
                          child: RiveAnimation.asset(
                            bottomNavItems.first.src,
                            artboard: bottomNavItems[index].artBoard,
                            onInit: (artboard) {
                              StateMachineController controller =
                                  RiveUtils.getRiveController(artboard,
                                      stateMachineName: bottomNavItems[index]
                                          .stateMachineName);
                              bottomNavItems[index].input =
                                  controller.findSMI("active") as SMIBool;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
