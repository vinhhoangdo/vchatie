import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_chating/components/components.dart';
import 'package:my_chating/routes/route_name.dart';
import 'package:my_chating/utils/utils.dart';
import 'package:rive/rive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;
  bool _isLoading = false;
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authSubscription;

  /// Method for sign up
  Future<void> _signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
        emailRedirectTo: 'io.supabase.chat://login',
      );
      check.fire();
      confetti.fire();
      if (!mounted) return;
    } catch (_) {
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bool haveNavigated = false;
    // Listen to auth state to redirect user when the
    // user clicks on confirmation link
    _authSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        final session = data.session;
        if (session != null && !haveNavigated) {
          haveNavigated = true;
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoute.entryPointRoute, (route) => false);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: formPadding,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('Enter email'),
                  ),
                  validator: (validate) {
                    if (validate == null || validate.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                formSpacer,
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    label: const Text('Enter password'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _passwordVisible
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                  validator: (validate) {
                    if (validate == null || validate.isEmpty) {
                      return 'Required';
                    }
                    if (validate.length < 6) {
                      return 'Must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                formSpacer,
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    label: Text('Enter username'),
                  ),
                  validator: (validate) {
                    if (validate == null || validate.isEmpty) {
                      return 'Required';
                    }
                    final isValid =
                        RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(validate);
                    if (!isValid) {
                      return 'From 3 to 24 long with alphanumeric or underscore';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                formSpacer,
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
                ),
                formSpacer,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoute.signInRoute),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
          ..._isLoading ? animationAuth : [const SizedBox()],
        ],
      ),
    );
  }

  List<Widget> get animationAuth => <Widget>[
        CustomPositioned(
          child: Transform.translate(
            offset: const Offset(0, 50),
            child: RiveAnimation.asset(
              "assets/RiveAssets/check.riv",
              onInit: (artboard) {
                StateMachineController controller =
                    RiveUtils.getRiveController(artboard);
                check = controller.findSMI("Check") as SMITrigger;
                error = controller.findSMI("Error") as SMITrigger;
                reset = controller.findSMI("Reset") as SMITrigger;
              },
            ),
          ),
        ),
        CustomPositioned(
          child: Transform.scale(
            scale: 7,
            child: RiveAnimation.asset(
              "assets/RiveAssets/confetti.riv",
              onInit: (artboard) {
                StateMachineController controller =
                    RiveUtils.getRiveController(artboard);
                confetti =
                    controller.findSMI("Trigger explosion") as SMITrigger;
              },
            ),
          ),
        ),
      ];
}
