import 'package:flutter/foundation.dart';
import 'package:movie_app/core/api/api_client.dart';
import 'package:movie_app/features/movies/data/movie_detail_response.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_response.dart';

class ApiServices {
  Future<List<Movies>> getMovieSuggestions(int movieId) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'movie_suggestions.json',
        queryParameters: {'movie_id': movieId, 'with_cast': 'true'},
      );
      return MovieResponse.fromJson(response.data).data?.movies ?? [];
    });
  }

  Future<List<Movies>> getMoviesByGenre(String genre) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'list_movies.json',
        queryParameters: {'limit': 50, 'genre': genre},
      );
      return MovieResponse.fromJson(response.data).data?.movies ?? [];
    });
  }

  Future<List<Movies>> searchMovies(String query) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'list_movies.json',
        queryParameters: {'limit': 50, 'query_term': query},
      );
      return MovieResponse.fromJson(response.data).data?.movies ?? [];
    });
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'movie_details.json',
        queryParameters: {'movie_id': movieId},
      );

      final responseObj = MovieDetailsResponse.fromJson(response.data);
      final apiMovie = responseObj.data.movie;

      if (apiMovie == null) {
        throw Exception("Movie details not found for ID: $movieId");
      }

      return MovieModel(
        id: apiMovie.id,
        title: apiMovie.title,
        year: apiMovie.year?.toString(),
        rating: (apiMovie.rating is num)
            ? (apiMovie.rating as num).toDouble()
            : 0.0,
        smallCoverImage: apiMovie.smallCoverImage,
        mediumCoverImage: apiMovie.mediumCoverImage,
        largeCoverImage: apiMovie.largeCoverImage,
        summary: apiMovie.summary,
        runtime: apiMovie.runtime,
        genres: apiMovie.genres,
        cast: apiMovie.cast,
      );
    });
  }

  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'movie_suggestions.json',
        queryParameters: {'movie_id': movieId, 'with_cast': 'true'},
      );

      final movies = MovieResponse.fromJson(response.data).data?.movies ?? [];

      return movies
          .map(
            (apiMovie) => MovieModel(
              id: apiMovie.id,
              title: apiMovie.title,
              year: apiMovie.year?.toString(),
              rating: (apiMovie.rating is num)
                  ? (apiMovie.rating as num).toDouble()
                  : 0.0,
              smallCoverImage: apiMovie.smallCoverImage,
              mediumCoverImage: apiMovie.mediumCoverImage,
              largeCoverImage: apiMovie.largeCoverImage,
              summary: apiMovie.summary,
              runtime: apiMovie.runtime,
              genres: apiMovie.genres,
              cast: apiMovie.cast,
            ),
          )
          .toList();
    });
  }

  Future<T> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      debugPrint("API Error: $e");
      rethrow;
    }
  }
}
