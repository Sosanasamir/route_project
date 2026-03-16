import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movie_app/features/movies/ui/splash_screen.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/features/auth/ui/forget_password_screen.dart';
import 'package:movie_app/features/movies/ui/home_screen.dart';
import 'package:movie_app/features/movies/ui/intro_screen.dart';
import 'package:movie_app/features/auth/ui/login_screen.dart';
import 'package:movie_app/features/movies/ui/onboarding_screen.dart';
import 'package:movie_app/features/auth/ui/register_screen.dart';
import 'package:movie_app/features/movies/ui/tabs/home_tab.dart';
import 'package:movie_app/features/profile/ui/profile_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/search_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/browse_tab.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/translation',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Routes for static screens
      routes: {
        'splash': (context) => const SplashScreen(),
        'intro': (context) => const IntroScreen(),
        'onboarding': (context) => const OnboardingScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'forgetpassword': (context) => const ForgetPasswordScreen(),
        'home': (context) => HomeScreen(),
        'hometab': (context) => const HomeTab(),
        'profile': (context) => const ProfileTab(),
        'search': (context) => const SearchTab(),
        'browse': (context) => const BrowseTab(),
      },
    );
  }
}
