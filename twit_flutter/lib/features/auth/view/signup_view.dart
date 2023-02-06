import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
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
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthField(
                          controller: emailController, hintText: 'Enter Email'),
                      const SizedBox(height: 25),
                      AuthField(
                          controller: passwordController,
                          hintText: 'Enter Password'),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: onSignUp,
                          label: 'Sign Up',
                          backGroundColor: Pallete.whiteColor,
                          textColor: Pallete.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 25),
                      RichText(
                          text: TextSpan(
                              text: "Alredy have an Account?",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              children: [
                            TextSpan(
                              text: ' Log In',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Pallete.blueColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, LoginView.route());
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
