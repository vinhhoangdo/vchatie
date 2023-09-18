import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chating/model/model.dart';
import 'package:my_chating/pages/entry_point.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:my_chating/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: myUrlSupabase,
    anonKey: myAnonKeySupabase,
    authCallbackUrlHostname: 'login',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfilesCubit>(
          create: (context) => ProfilesCubit(),
        ),
        BlocProvider<RoomCubit>(
          create: (context) => RoomCubit()..initializeRooms(context),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VChatie',
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: const SplashPage(),
        initialRoute: AppRoute.splashRoute,
        routes: {
          AppRoute.splashRoute: (context) => const SplashPage(),
          AppRoute.signUpRoute: (context) => const RegisterPage(),
          AppRoute.signInRoute: (context) => const LoginPage(),
          AppRoute.roomsRoute: (context) => const RoomsPage(),
          AppRoute.accountRoute: (context) => const AccountPage(),
          AppRoute.settingsRoute: (context) => const SettingsPage(),
          AppRoute.entryPointRoute: (context) => const EntryPoint(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoute.chatRoute) {
            final args = settings.arguments as RoomArgs;
            return MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  roomId: args.roomId,
                  username: args.username,
                );
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
