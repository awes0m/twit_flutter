import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/common.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/view/signup_view.dart';
import 'features/home/view/home_view.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Twit',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
          data: (user) {
            if (user != null) {
              return const HomeView();
            }
            return const SignUpView();
          },
          error: (error, st) => ErrorPage(error: error.toString()),
          loading: () => const LoadingPage()),
    );
  }
}
