import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';
import 'package:movie_app/features/movies/ui/tabs/browse_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    Future.microtask(() => context.read<MovieCubit>().getHomeMovies());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMovieTap(BuildContext context, MovieModel movie) {
    context.read<MovieCubit>().addToHistory(movie);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MovieDetailsScreen(),
        settings: RouteSettings(arguments: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return Center(
            child: CircularProgressIndicator(color: Color(0XFFF6BD00)),
          );
        }

        if (state is MovieError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        }

        if (state is MovieSuccess) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeroWithSuggested(state.suggested),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Action",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BrowseTab()),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "See More",
                            style: TextStyle(
                              color: Color(0xFFF6BD00),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Color(0xFFF6BD00),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionMovies(state.action),
              SizedBox(height: 40),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildHeroWithSuggested(List<MovieModel> suggested) {
    return SizedBox(
      height: 650,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/pic6.png',
            width: double.infinity,
            height: 650,
            fit: BoxFit.cover,
          ),
          Container(
            height: 650,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 380,
              child: PageView.builder(
                controller: _pageController,
                itemCount: suggested.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final movie = suggested[index];
                  double scale = _currentPage == index ? 1.0 : 0.85;
                  return GestureDetector(
                    onTap: () => _onMovieTap(context, movie),
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 350),
                      tween: Tween(begin: 0.85, end: scale),
                      builder: (context, double value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.network(
                              movie.largeCoverImage ??
                                  movie.mediumCoverImage ??
                                  movie.smallCoverImage ??
                                  '',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.white10),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: _buildRatingBox(movie.rating!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Image.asset('assets/images/title.png', width: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMovies(List<MovieModel> action) {
    if (action.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "No action movies",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final movies = action.length > 6 ? action.sublist(0, 6) : action;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _onMovieTap(context, movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    movie.mediumCoverImage ?? movie.smallCoverImage ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white10),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _buildRatingBox(movie.rating!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingBox(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Color(0XFFF6BD00), size: 16),
          SizedBox(width: 4),
          Text(
            rating.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
