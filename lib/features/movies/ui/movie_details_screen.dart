import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/movie_detail_cubit.dart';
import 'package:movie_app/features/movies/logic/similar_movies_cubit.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel initialMovie;
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.initialMovie,
    required this.movieId,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailCubit>().fetchMovieDetails(widget.movieId);
      context.read<SimilarMoviesCubit>().fetchSimilarMovies(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF121312),
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          final movie = (state is MovieDetailSuccess)
              ? state.movie
              : widget.initialMovie;

          if (state is MovieDetailLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context, movie),
                _buildStatsSection(movie),

                // Ordered Sections
                _buildScreenshots(
                  movie.largeCoverImage != null ? [movie.largeCoverImage!] : [],
                ),
                _buildSimilarMovies(),
                _buildSectionTitle("Summary"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    movie.summary ?? "No summary available.",
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                _buildCastSection(movie.cast ?? []),
                _buildSectionTitle("Genres"),
                _buildGenres(movie.genres ?? []),
                SizedBox(height: 30),
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
          movie.largeCoverImage ?? '',
          height: 450,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Container(
          height: 450,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0XFF121312)],
            ),
          ),
        ),

        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        Positioned(
          top: 40,
          right: 20,
          child: Icon(Icons.bookmark_border, color: Colors.white, size: 30),
        ),

        Positioned.fill(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                iconSize: 50,
                icon: Icon(Icons.play_arrow, color: Color(0XFFF6BD00)),
                onPressed: () {},
              ),
            ),
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
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                movie.year ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(MovieModel movie) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statRect(Icons.favorite, "15"),
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
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildScreenshots(List<String> images) {
    if (images.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Screen Shots"),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarMovies() {
    return BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
      builder: (context, state) {
        if (state is SimilarMoviesLoading) {
          return Center(child: CircularProgressIndicator(color: Colors.amber));
        } else if (state is SimilarMoviesSuccess) {
          final movies = state.movies;
          if (movies.isEmpty) return SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Similar"),
              SizedBox(
                height: 220,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final similarMovie = movies[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            similarMovie.mediumCoverImage ?? '',
                            height: 140,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          similarMovie.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        if (similarMovie.year != null)
                          Text(
                            similarMovie.year!,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is SimilarMoviesError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCastSection(List<CastMember> cast) {
    if (cast.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Cast"),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cast.length,
          itemBuilder: (context, index) {
            final actor = cast[index];

            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(actor.photoUrl ?? ''),
              ),
              title: Text(
                actor.name ?? '',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                actor.character ?? '',
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenres(List<String> genres) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: genres
            .map(
              (g) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(g, style: TextStyle(color: Colors.white)),
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
