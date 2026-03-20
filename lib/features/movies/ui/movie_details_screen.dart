import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/similar_movies_cubit.dart';
import 'package:movie_app/features/profile/logic/watchlist_cubit.dart';

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
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is MovieModel) {
        setState(() => initialMovie = args);

        context.read<MovieDetailCubit>().fetchMovieDetails(args.id ?? 0);
        context.read<SimilarMoviesCubit>().fetchSimilarMovies(args.id ?? 0);
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
                _buildActionButtons(),
                _buildStatsRow(movie),
                _buildSectionTitle("Screen Shots"),
                _buildScreenshots(movie),
                _buildSimilarSection(),
                _buildSectionTitle("Summary"),
                _buildSummary(movie.summary),
                _buildSectionTitle("Cast"),
                _buildCastList(movie.cast, state is MovieDetailLoading),
                _buildSectionTitle("Genres"),
                _buildGenresGrid(movie.genres ?? []),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, MovieModel movie) {
    final bool isSaved = context.watch<WatchlistCubit>().isBookmarked(
      movie.id ?? 0,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          width: double.infinity,
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0XFF121312)],
            ),
          ),
          child: Image.network(
            movie.largeCoverImage ?? movie.mediumCoverImage ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: isSaved ? const Color(0XFFF6BD00) : Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  context.read<WatchlistCubit>().toggleWatchlist(movie);
                },
              ),
            ],
          ),
        ),
        const Icon(Icons.play_circle_fill, color: Color(0xFFF6BD00), size: 70),
        Positioned(
          bottom: 10,
          child: Column(
            children: [
              Text(
                movie.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                movie.year?.toString() ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: MaterialButton(
        onPressed: () {},
        color: const Color(0XFFE52621),
        minWidth: double.infinity,
        height: 45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Text(
          "Watch",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(MovieModel movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statBadge(Icons.favorite, "15"),
          _statBadge(Icons.access_time_filled, "${movie.runtime ?? 0} min"),
          _statBadge(Icons.star, "${movie.rating ?? 0.0}"),
        ],
      ),
    );
  }

  Widget _statBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0XFF282A28),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0XFFF6BD00), size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshots(MovieModel movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          1,
          (index) => Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                movie.mediumCoverImage ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimilarSection() {
    return BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
      builder: (context, state) {
        if (state is SimilarMoviesSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Similar"),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        'details',
                        arguments: state.movies[index],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          state.movies[index].mediumCoverImage ?? '',
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSummary(String? summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        summary ?? "No summary available.",
        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _buildCastList(List<CastMember>? cast, bool isLoading) {
    if (isLoading)
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    if (cast == null || cast.isEmpty)
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "Cast not available.",
          style: TextStyle(color: Colors.white54),
        ),
      );

    return Column(
      children: cast
          .take(4)
          .map(
            (member) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0XFF282A28),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      member.photoUrl ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      member.name ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGenresGrid(List<String> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: genres
            .map(
              (g) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0XFF282A28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  g,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
