import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/api_services.dart';

class MovieRepository {
  final ApiServices apiService = ApiServices();

  // deal with suggested movies
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    final data = await apiService.getMovieSuggestions(movieId);

    return data
        .map(
          (movie) => MovieModel(
            id: movie.id,
            mediumCoverImage: movie.mediumCoverImage ?? '',
            rating: movie.rating != null
                ? double.tryParse(movie.rating.toString()) ?? 0.0
                : 0.0,
          ),
        )
        .toList();
  }

  // deal with movies by genre
  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    final data = await apiService.getMoviesByGenre(genre);
    return data
        .map(
          (movie) => MovieModel(
            id: movie.id,
            mediumCoverImage: movie.mediumCoverImage ?? '',
            rating: movie.rating != null
                ? double.tryParse(movie.rating.toString()) ?? 0.0
                : 0.0,
          ),
        )
        .toList();
  }

  // deal with search
  Future<List<MovieModel>> searchMovie(String query) async {
    final data = await apiService.searchMovies(query);
    return data
        .map(
          (movie) => MovieModel(
            id: movie.id,
            mediumCoverImage: movie.mediumCoverImage ?? '',
            rating: movie.rating != null
                ? double.tryParse(movie.rating.toString()) ?? 0.0
                : 0.0,
          ),
        )
        .toList();
  }
}
