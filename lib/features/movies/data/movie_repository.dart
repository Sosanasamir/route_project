import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/core/api/api_services.dart';
import 'package:movie_app/features/movies/data/movie_response.dart';

class MovieRepository {
  final ApiServices apiService = ApiServices();

  // Helper method now explicitly handles the list from ApiServices
  List<MovieModel> _mapToDomain(List<Movies> apiMovies) {
    return apiMovies.map((movie) {
      try {
        return MovieModel(
          id: movie.id,
          title: movie.title,
          year: movie.year?.toString(),
          rating: (movie.rating is num)
              ? (movie.rating as num).toDouble()
              : 0.0,
          smallCoverImage: movie.smallCoverImage,
          mediumCoverImage: movie.mediumCoverImage,
          largeCoverImage: movie.largeCoverImage,
        );
      } catch (e) {
        print("ERROR MAPPING MOVIE: ${movie.title}");
        print(
          "RATING VALUE: ${movie.rating} | TYPE: ${movie.rating.runtimeType}",
        );
        rethrow;
      }
    }).toList();
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
}
