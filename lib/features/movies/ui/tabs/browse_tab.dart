import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/borwse_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  String? selectedGenre;
  List<String> dynamicGenres = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrowseCubit>().getBrowseMovies();
    });
  }

  void _extractGenres(List<MovieModel> movies) {
    if (dynamicGenres.isNotEmpty) return;

    final Set<String> genreSet = {};
    for (var movie in movies) {
      if (movie.genres != null) {
        genreSet.addAll(movie.genres!);
      }
    }

    setState(() {
      dynamicGenres = genreSet.toList()..sort();
      if (dynamicGenres.isNotEmpty && selectedGenre == null) {
        selectedGenre = dynamicGenres.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121312),
      body: SafeArea(
        child: BlocConsumer<BrowseCubit, MovieState>(
          listener: (context, state) {
            if (state is MovieSuccess) {
              _extractGenres(state.all);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 10),
                if (dynamicGenres.isNotEmpty) _buildGenreList(),

                Expanded(
                  child: state is MovieLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0XFFF6BD00),
                          ),
                        )
                      : state is MovieSuccess
                      ? _buildMoviesGrid(state.all)
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenreList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: dynamicGenres.length,
        itemBuilder: (context, index) {
          final genre = dynamicGenres[index];
          bool isSelected = selectedGenre == genre;
          return GestureDetector(
            onTap: () {
              setState(() => selectedGenre = genre);
              context.read<BrowseCubit>().getMoviesByGenre(genre);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0XFFF6BD00)
                    : Colors.transparent,
                border: Border.all(color: const Color(0XFFF6BD00), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0XFFF6BD00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoviesGrid(List<MovieModel> movies) {
    if (movies.isEmpty) {
      return const Center(
        child: Text("No movies found", style: TextStyle(color: Colors.white70)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return InkWell(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: movie),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.network(
                  movie.mediumCoverImage ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                _buildRatingBadge(movie.rating.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBadge(String rating) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Color(0XFFF6BD00), size: 16),
            const SizedBox(width: 4),
            Text(
              rating,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
