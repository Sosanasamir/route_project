import 'package:dio/dio.dart';
import 'package:movie_app/models/movie_response.dart';

class ApiServices {
  static Dio dio = Dio();
  String baseUrl = 'https://movies-api.accel.li/api/v2/';

  // Movie suggestions
  Future<List<Movies>> getMovieSuggestions(int movieId) async {
    final response = await dio.get(
      '${baseUrl}movie_suggestions.json',
      queryParameters: {'movie_id': movieId},
    );

    if (response.statusCode == 200) {
      MovieResponse movieResponse = MovieResponse.fromJson(response.data);
      return movieResponse.data?.movies ?? [];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  // Movies by genre
  Future<List<Movies>> getMoviesByGenre(
    String genre, {
    int page = 1,
    int limit = 50, 
  }) async {
    final response = await dio.get(
      '${baseUrl}list_movies.json',
      queryParameters: {'limit': limit, 'page': page, 'genre': genre},
    );

    if (response.statusCode == 200) {
      MovieResponse movieResponse = MovieResponse.fromJson(response.data);
      print(
        'Loaded ${movieResponse.data!.movies?.length} movies for genre $genre',
      ); // debug
      return movieResponse.data?.movies ?? [];
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  // Search movies
  Future<List<Movies>> searchMovies(
    String query, {
    int page = 1,
    int limit = 50,
  }) async {
    final response = await dio.get(
      '${baseUrl}list_movies.json',
      queryParameters: {'limit': limit, 'page': page, 'query_term': query},
    );

    if (response.statusCode == 200) {
      MovieResponse movieResponse = MovieResponse.fromJson(response.data);
      print(
        'Found ${movieResponse.data!.movies?.length} movies for search "$query"',
      ); // debug
      return movieResponse.data?.movies ?? [];
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
