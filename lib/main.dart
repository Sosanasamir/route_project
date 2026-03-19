import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme & Firebase Options
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/firebase_options.dart';

// Logic & Repository Imports
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/search_cubit.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';
import 'package:movie_app/features/profile/data/profile_repository.dart';

// UI Imports
import 'package:movie_app/features/movies/ui/splash_screen.dart';
import 'package:movie_app/features/movies/ui/home_screen.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';

// Fix for YTS Image 403 Errors
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final movieRepo = MovieRepository();
    final profileRepo = ProfileRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieCubit(movieRepo)..getHomeMovies(),
        ),
        BlocProvider(create: (context) => MovieDetailCubit(movieRepo)),
        BlocProvider(create: (context) => SearchCubit(movieRepo)),
        BlocProvider(create: (context) => ProfileCubit(profileRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: 'splash',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routes: {
          'splash': (context) => const SplashScreen(),
          'home': (context) => const HomeScreen(),
          'details': (context) => const MovieDetailsScreen(),
        },
      ),
    );
  }
}
