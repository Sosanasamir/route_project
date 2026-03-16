import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/navigation_cubit.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';
import 'package:movie_app/features/movies/ui/tabs/browse_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/home_tab.dart';
import 'package:movie_app/features/profile/ui/profile_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/search_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> tabs = const [
    HomeTab(),
    SearchTab(),
    BrowseTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
          create: (context) => MovieCubit(MovieRepository())..getHomeMovies(),
        ),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, navState) {
          return Scaffold(
            backgroundColor: const Color(0XFF121312),
            // The body dynamically switches based on navState and MovieCubit state
            body: BlocBuilder<MovieCubit, MovieState>(
              builder: (context, movieState) {
                if (movieState is MovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0XFFF6BD00)),
                  );
                }

                if (movieState is MovieError) {
                  return _buildErrorState(context, movieState.message);
                }

                // If success, display the selected tab
                return tabs[navState];
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0XFF282A28),
              type: BottomNavigationBarType.fixed,
              currentIndex: navState,
              onTap: (index) =>
                  context.read<NavigationCubit>().changeTab(index),
              selectedItemColor: const Color(0XFFF6BD00),
              unselectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie),
                  label: 'Browse',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<MovieCubit>().getHomeMovies(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
