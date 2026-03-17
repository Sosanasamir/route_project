import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/core/api/api_services.dart';

class MovieRepository {
  final ApiServices apiService = ApiServices();

  MovieModel _mapSingleToDomain(dynamic movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      year: movie.year?.toString(),
      rating: (movie.rating is num) ? (movie.rating as num).toDouble() : 0.0,
      smallCoverImage: movie.smallCoverImage,
      mediumCoverImage: movie.mediumCoverImage,
      largeCoverImage: movie.largeCoverImage,
      summary: movie.summary,
      runtime: movie.runtime,
      genres: movie.genres,
      cast: movie.cast,
    );
  }

  List<MovieModel> _mapToDomain(List<dynamic> apiMovies) {
    return apiMovies.map((movie) => _mapSingleToDomain(movie)).toList();
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    final rawMovie = await apiService.getMovieDetails(movieId);

    return _mapSingleToDomain(rawMovie);
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
    return data;
  }
}
