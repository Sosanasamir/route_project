import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/similar_movies_cubit.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieModel? initialMovie;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is MovieModel) {
        setState(() {
          initialMovie = args;
        });

        final movieId = args.id ?? 0;

        context.read<MovieDetailCubit>().fetchMovieDetails(movieId);
        context.read<SimilarMoviesCubit>().fetchSimilarMovies(movieId);
      }
    });
  }

  void _addToWatchList(MovieModel movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Added to Watch List",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "${movie.title} was added to your watch list.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _addToHistory(MovieModel movie) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Added to History", style: TextStyle(color: Colors.white)),
        content: Text(
          "${movie.title} was added to your history.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initialMovie == null) {
      return Scaffold(
        backgroundColor: Color(0XFF121312),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF6BD00)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0XFF121312),
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          final movie = (state is MovieDetailSuccess)
              ? state.movie
              : initialMovie!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context, movie),

                if (state is MovieDetailLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF6BD00),
                      ),
                    ),
                  )
                else ...[
                  _buildStatsSection(movie),
                //  _buildScreenshots(movie.screenshots),
                  _buildSimilarMovies(),
                  _buildSectionTitle("Summary"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      (movie.summary != null &&
                              movie.summary!.trim().isNotEmpty)
                          ? movie.summary!
                          : "No summary available.",
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],

                if (movie.cast != null && movie.cast!.isNotEmpty)
                  _buildCastSection(movie.cast!),

                _buildSectionTitle("Genres"),
                _buildGenres(movie.genres ?? []),
                SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, MovieModel movie) {
    return Stack(
      children: [
        Image.network(
          movie.largeCoverImage ?? movie.mediumCoverImage ?? '',
          height: 500,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 500,
            color: Colors.grey[900],
            child: Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0XFF121312)],
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.yellow : Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                  _addToHistory(movie);
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          left: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              _addToWatchList(movie);
            },
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Text(
                movie.title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                movie.year?.toString() ?? '',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildScreenshots(List<String>? screenshots) {
  //   if (screenshots == null || screenshots.isEmpty) return SizedBox.shrink();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildSectionTitle("Screenshots"),
  //       SizedBox(
  //         height: 200,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           padding: EdgeInsets.symmetric(horizontal: 16),
  //           itemCount: screenshots.length,
  //           itemBuilder: (context, index) {
  //             final url = screenshots[index];
  //             return Container(
  //               margin: EdgeInsets.only(right: 12),
  //               width: 300,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(12),
  //                 child: Image.network(url, fit: BoxFit.cover),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildStatsSection(MovieModel movie) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statRect(Icons.favorite, "Favorite"),
          _statRect(Icons.access_time, "${movie.runtime ?? 0}m"),
          _statRect(Icons.star, "${movie.rating ?? 0.0}"),
        ],
      ),
    );
  }

  Widget _statRect(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFF6BD00)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFF6BD00), size: 16),
          SizedBox(width: 5),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSimilarMovies() {
    return BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
      builder: (context, state) {
        if (state is SimilarMoviesSuccess && state.movies.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Similar"),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final simMovie = state.movies[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        'details',
                        arguments: simMovie,
                      ),
                      child: Container(
                        width: 110,
                        margin: EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            simMovie.mediumCoverImage ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildCastSection(List<CastMember> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Cast"),
        SizedBox(
          height: cast.length * 70.0 > 200
              ? 200
              : cast.length * 70.0, 
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Padding(
                padding:  EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: actor.photoUrl != null
                          ? NetworkImage(actor.photoUrl!)
                          : null,
                    ),
                     SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actor.name ?? '',
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           SizedBox(height: 4),
                          Text(
                            actor.character ?? '',
                            style:  TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenres(List<String> genres) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: genres
            .map(
              (g) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  g,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
