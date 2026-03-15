import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_cubit.dart';
import 'package:movie_app/bloc/navigation_cubit.dart';
import 'package:movie_app/repository/movie_repository.dart';
import 'package:movie_app/tabs/browse_tab.dart';
import 'package:movie_app/tabs/home_tab.dart';
import 'package:movie_app/tabs/profile_tab.dart';
import 'package:movie_app/tabs/search_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> tabs = [HomeTab(), SearchTab(), BrowseTab(), ProfileTab()];
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
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0XFF282A28),
              type: BottomNavigationBarType.fixed,
              currentIndex: state,
              onTap: (index) {
                context.read<NavigationCubit>().changeTab(index);
              },
              selectedItemColor: Color(0XFFF6BD00),
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.browser_updated),
                  label: '',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
            ),
            body: tabs[state],
          );
        },
      ),
    );
  }
}
