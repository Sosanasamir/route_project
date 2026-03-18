import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Logic & Data Imports
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/borwse_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/search_cubit.dart';
import 'package:movie_app/features/movies/logic/similar_movies_cubit.dart'; // Added
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/logic/navigation_cubit.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';
import 'package:movie_app/features/profile/data/profile_repository.dart';

// UI Imports
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
import 'package:movie_app/features/profile/ui/update_profile_screen.dart';
import 'package:movie_app/features/movies/ui/tabs/search_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/browse_tab.dart';

// Fix for 403 Forbidden errors on YTS images
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  HttpOverrides.global = MyHttpOverrides();

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
    final movieRepository = MovieRepository();
    final profileRepo = ProfileRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
          create: (context) => MovieCubit(movieRepository)..getHomeMovies(),
        ),
        BlocProvider(create: (context) => BrowseCubit(movieRepository)),
        BlocProvider(create: (context) => MovieDetailCubit(movieRepository)),
        BlocProvider(create: (context) => SimilarMoviesCubit(movieRepository)),

        BlocProvider(create: (context) => ProfileCubit(profileRepo)),

        BlocProvider(create: (context) => SearchCubit(movieRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routes: {
          'splash': (context) => const SplashScreen(),
          'intro': (context) => const IntroScreen(),
          'onboarding': (context) => const OnboardingScreen(),
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
          'forgetpassword': (context) => const ForgetPasswordScreen(),
          'home': (context) => const HomeScreen(),
          'details': (context) => const MovieDetailsScreen(),
          'hometab': (context) => const HomeTab(),
          'profile': (context) => const ProfileTab(),
          'update_profile': (context) => const UpdateProfileScreen(),
          'search': (context) => const SearchTab(),
          'browse': (context) => const BrowseTab(),
        },
      ),
    );
  }
}
