// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/search_cubit.dart';
import 'package:movie_app/features/movies/logic/search_states.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 700), () {
      final query = value.trim();
      if (query.length >= 3) {
        context.read<SearchCubit>().search(query);
      } else if (query.isEmpty) {
        // ignore: invalid_use_of_protected_member
        context.read<SearchCubit>().emit(SearchInitial());
      }
    });
    setState(() {});
  }

  void _onMovieTap(BuildContext context, MovieModel movie) {
    context.read<MovieCubit>().addToHistory(movie);

    Navigator.pushNamed(context, 'details', arguments: movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121312),
      appBar: AppBar(
        backgroundColor: const Color(0XFF121312),
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0XFF282A28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial || _searchController.text.isEmpty) {
            return _buildPlaceholder(
              'assets/images/search.png',
              "Discover your next favorite movie",
            );
          }

          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF6BD00)),
            );
          }

          if (state is SearchError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (state is SearchSuccess) {
            if (state.movies.isEmpty) {
              return _buildPlaceholder(
                'assets/images/no_results.png',
                "No movies found for '${_searchController.text}'",
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return _buildMovieCard(state.movies[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlaceholder(String assetPath, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            height: 150,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.movie_creation_outlined,
              size: 100,
              color: Colors.white24,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return InkWell(
      onTap: () => _onMovieTap(context, movie),
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                movie.mediumCoverImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[900]),
              ),
            ),

            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF6BD00), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating?.toString() ?? '0.0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
