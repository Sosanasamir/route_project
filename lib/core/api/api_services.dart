import 'package:movie_app/core/api/api_client.dart';
import 'package:movie_app/features/movies/data/movie_response.dart';

class ApiServices {
  Future<List<Movies>> getMovieSuggestions(int movieId) async {
    final response = await ApiClient.dio.get(
      'movie_suggestions.json',
      queryParameters: {'movie_id': movieId},
    );
    return MovieResponse.fromJson(response.data).data?.movies ?? [];
  }

  Future<List<Movies>> getMoviesByGenre(String genre) async {
    final response = await ApiClient.dio.get(
      'list_movies.json',
      queryParameters: {'limit': 50, 'genre': genre},
    );
    return MovieResponse.fromJson(response.data).data?.movies ?? [];
  }

  Future<List<Movies>> searchMovies(String query) async {
    final response = await ApiClient.dio.get(
      'list_movies.json',
      queryParameters: {'limit': 50, 'query_term': query},
    );
    return MovieResponse.fromJson(response.data).data?.movies ?? [];
  }
}
