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

  @override
  Widget build(BuildContext context) {
    if (initialMovie == null) {
      return const Scaffold(
        backgroundColor: Color(0XFF121312),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF6BD00)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0XFF121312),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF6BD00),
                      ),
                    ),
                  )
                else ...[
                  _buildStatsSection(movie),
                  _buildSimilarMovies(),
                  _buildSectionTitle("Summary"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      movie.summary ?? "No summary available.",
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (movie.cast != null && movie.cast!.isNotEmpty)
                    _buildCastSection(movie.cast!),

                  _buildSectionTitle("Genres"),
                  _buildGenres(movie.genres ?? []),
                  const SizedBox(height: 50),
                ],
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
            child: const Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
        Container(
          height: 500,
          decoration: const BoxDecoration(
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
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Icon(Icons.bookmark_border, color: Colors.white, size: 30),
            ],
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                movie.year?.toString() ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(MovieModel movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF6BD00)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF6BD00), size: 16),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        margin: const EdgeInsets.only(right: 12),
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
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCastSection(List<CastMember> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Cast"),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: actor.photoUrl != null
                          ? NetworkImage(actor.photoUrl!)
                          : null,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 70,
                      child: Text(
                        actor.name ?? '',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: genres
            .map(
              (g) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  g,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
