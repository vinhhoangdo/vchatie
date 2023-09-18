import 'package:flutter/material.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:my_chating/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    getInitialSession();
  }

  Future<void> getInitialSession() async {
    await Future.delayed(Duration.zero);
    try {
      final session = await SupabaseAuth.instance.initialSession;
      if (!mounted) return;
      if (session == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.signUpRoute, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.entryPointRoute, (route) => false);
      }
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar(
          message: 'Error occurred during session refresh');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoute.signUpRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preloader,
    );
  }
}
