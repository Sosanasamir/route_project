import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  
  void _navigateToDetails(BuildContext context, MovieModel movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => MovieDetailCubit(MovieRepository()),
          child: MovieDetailsScreen(
            initialMovie: movie,
            movieId: movie.id ?? 0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0XFF282A28),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return  Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return  Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          } else if (state is MovieSuccess) {
            final List<MovieModel> suggestedMovies = state.suggested;
            final List<MovieModel> actionMovies = state.action;

            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      // Background Graphic
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image.asset(
                          'assets/images/pic6.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/title.png',
                              fit: BoxFit.cover,
                            ),
                             SizedBox(height: 20),

                            // Cinematic Suggested Movies
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: PageView.builder(
                                itemCount: suggestedMovies.length,
                                controller: pageController,
                                onPageChanged: (index) =>
                                    setState(() => currentIndex = index),
                                itemBuilder: (context, index) {
                                  final movie = suggestedMovies[index];
                                  return GestureDetector(
                                    onTap: () =>
                                        _navigateToDetails(context, movie),
                                    child: Transform.scale(
                                      scale: index == currentIndex ? 1.0 : 0.7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          movie.mediumCoverImage ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                             SizedBox(height: 20),

                            // Action Section
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics:  NeverScrollableScrollPhysics(),
                                itemCount: actionMovies.length > 6
                                    ? 6
                                    : actionMovies.length,
                                gridDelegate:
                                     SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 0.6,
                                    ),
                                itemBuilder: (context, index) {
                                  final movie = actionMovies[index];
                                  return GestureDetector(
                                    // FIXED: Using our helper method here
                                    onTap: () =>
                                        _navigateToDetails(context, movie),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        movie.mediumCoverImage ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
