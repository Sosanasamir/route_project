import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/navigation_cubit.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/ui/tabs/browse_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/home_tab.dart';
import 'package:movie_app/features/profile/ui/profile_tab.dart';
import 'package:movie_app/features/movies/ui/tabs/search_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        builder: (context, currentIndex) {
          return Scaffold(
            backgroundColor: const Color(0XFF121312),

            body: IndexedStack(
              index: currentIndex,
              children: const [
                HomeTab(),
                SearchTab(),
                BrowseTab(),
                ProfileTab(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0XFF1A1A1A),
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) =>
                  context.read<NavigationCubit>().changeTab(index),
              selectedItemColor: const Color(0XFFF6BD00),
              unselectedItemColor: Colors.white60,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Browse',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
