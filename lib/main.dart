import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/ui/forget_password_screen.dart';
import 'package:movie_app/firebase_options.dart';

// Repositories
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/profile/data/watchlist_repository.dart';
import 'package:movie_app/features/profile/data/profile_repository.dart';

// Logic (Cubits)
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/similar_movies_cubit.dart';
import 'package:movie_app/features/movies/logic/search_cubit.dart';
import 'package:movie_app/features/movies/logic/borwse_cubit.dart';
import 'package:movie_app/features/profile/logic/watchlist_cubit.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';

// UI Screens
import 'package:movie_app/features/movies/ui/splash_screen.dart';
import 'package:movie_app/features/movies/ui/home_screen.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';
import 'package:movie_app/features/auth/ui/login_screen.dart';
import 'package:movie_app/features/profile/ui/update_profile_screen.dart';

/// Overrides for HTTP to bypass specific certificate issues and set user-agent
/// Useful for YTS API and image loading consistency
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

  // Initialize Firebase and Localization
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
    // Injecting repositories
    final movieRepo = MovieRepository();
    final profileRepo = ProfileRepository();
    final watchlistRepo = WatchlistRepository();

    return MultiBlocProvider(
      providers: [
        // 1. Movie Cubit handles the main home screen lists (Trending, Popular, etc.)
        BlocProvider(
          create: (context) => MovieCubit(movieRepo)..getHomeMovies(),
        ),

        // 2. Movie Detail handles fetching specific movie info (Cast/Summary)
        BlocProvider(create: (context) => MovieDetailCubit(movieRepo)),

        // 3. Search logic for movie discovery
        BlocProvider(create: (context) => SearchCubit(movieRepo)),

        // 4. User profile logic (Authentication/User Data)
        BlocProvider(create: (context) => ProfileCubit(profileRepo)),

        // 5. Similar movies (Fetched separately on details screen)
        BlocProvider(create: (context) => SimilarMoviesCubit(movieRepo)),

        // 6. Category/Genre browsing
        BlocProvider(
          create: (context) => BrowseCubit(movieRepo)..getBrowseMovies(),
        ),

        // 7. Watchlist Cubit (CRITICAL: Shared across Details and Profile Tab)
        // ..getWatchlist() ensures data is ready before the user opens the Profile Tab
        BlocProvider(
          create: (context) => WatchlistCubit(watchlistRepo)..getWatchlist(),
        ),
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
          'login': (context) => const LoginScreen(),
          'update_profile': (context) => const UpdateProfileScreen(),
          'forget_password_view': (context) => const ForgetPasswordScreen(),
        },
      ),
    );
  }
}
