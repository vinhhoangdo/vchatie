import 'package:flutter/material.dart';
import 'package:my_chating/utils/utils.dart';
import 'package:rive/rive.dart';

import '../components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (email) {},
                ),
                formSpacer,
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (password) {},
                ),
                formSpacer,
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: const Text('Login'),
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
