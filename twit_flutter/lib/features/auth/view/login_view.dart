import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';
import 'signup_view.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  
  void onLogIn() {
   ref.read(authControllerProvider.notifier).login(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = UIConstants.appBar();
       final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar,
      body:  isLoading
          ? const Loader()
          :Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AuthField(controller: emailController, hintText: 'Enter Email'),
                const SizedBox(height: 25),
                AuthField(
                    controller: passwordController, hintText: 'Enter Password'),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: onLogIn,
                    label: 'Done',
                    backGroundColor: Pallete.whiteColor,
                    textColor: Pallete.backgroundColor,
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                    text: TextSpan(
                        text: "Don't have an Account?",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                      TextSpan(
                        text: ' Sign Up',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Pallete.blueColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, SignUpView.route());
                          },
                      )
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
