import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/core/api/api_services.dart';

class MovieRepository {
  final ApiServices apiService = ApiServices();

  List<MovieModel> _mapToDomain(List<dynamic> apiMovies) {
    return apiMovies.map((movie) {
      return MovieModel(
        id: movie.id,
        title: movie.title,
        year: movie.year?.toString(),
        rating: (movie.rating is num) ? (movie.rating as num).toDouble() : 0.0,
        smallCoverImage: movie.smallCoverImage,
        mediumCoverImage: movie.mediumCoverImage,
        largeCoverImage: movie.largeCoverImage,
        summary: (movie.summary != null && movie.summary!.trim().isNotEmpty)
            ? movie.summary
            : "No summary available",
        runtime: movie.runtime,
        genres: movie.genres,
        cast: movie.cast,
       // screenshots: movie.screenshots,
      );
    }).toList();
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    return await apiService.getMovieDetails(movieId);
  }

  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    final data = await apiService.getMovieSuggestions(movieId);
    return _mapToDomain(data);
  }

  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    final data = await apiService.getMoviesByGenre(genre);
    return _mapToDomain(data);
  }

  Future<List<MovieModel>> searchMovie(String query) async {
    final data = await apiService.searchMovies(query);
    return _mapToDomain(data);
  }

  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    final data = await apiService.getSimilarMovies(movieId);
    return _mapToDomain(data);
  }
}
