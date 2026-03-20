import 'package:flutter/foundation.dart';
import 'package:movie_app/core/api/api_client.dart';
import 'package:movie_app/features/movies/data/movie_detail_response.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_response.dart';

class ApiServices {
  MovieModel _mapToMovieModel(dynamic m) {
    return MovieModel(
      id: m.id,
      title: m.title,
      year: m.year?.toString(),
      rating: (m.rating is num) ? (m.rating as num).toDouble() : 0.0,
      smallCoverImage: m.smallCoverImage,
      mediumCoverImage: m.mediumCoverImage,
      largeCoverImage: m.largeCoverImage,

      summary: m.descriptionFull ?? m.summary,
      runtime: m.runtime,
      genres: m.genres != null ? List<String>.from(m.genres!) : [],

      cast: m.cast != null
          ? List<CastMember>.from(
              m.cast!.map(
                (c) => CastMember(
                  name: c.name,
                  characterName: c.characterName,
                  photoUrl: c.urlSmallImage,
                ),
              ),
            )
          : [],
    );
  }

  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'movie_suggestions.json',
        queryParameters: {'movie_id': movieId, 'with_cast': 'true'},
      );
      final movies = MovieResponse.fromJson(response.data).data?.movies ?? [];
      return movies.map((m) => _mapToMovieModel(m)).toList();
    });
  }

  Future<List<MovieModel>> getMoviesByGenre(String genre) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'list_movies.json',
        queryParameters: {'limit': 20, 'genre': genre, 'sort_by': 'year'},
      );
      final movies = MovieResponse.fromJson(response.data).data?.movies ?? [];
      return movies.map((m) => _mapToMovieModel(m)).toList();
    });
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'list_movies.json',
        queryParameters: {'limit': 20, 'query_term': query},
      );
      final movies = MovieResponse.fromJson(response.data).data?.movies ?? [];
      return movies.map((m) => _mapToMovieModel(m)).toList();
    });
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    return _safeApiCall(() async {
      final response = await ApiClient.dio.get(
        'movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': 'true',
          'with_cast': 'true',
        },
      );

      final responseObj = MovieDetailsResponse.fromJson(response.data);
      final apiMovie = responseObj.data.movie;

      if (apiMovie == null) {
        throw Exception("Movie details not found for ID: $movieId");
      }

      return _mapToMovieModel(apiMovie);
    });
  }

  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    return getMovieSuggestions(movieId);
  }

  Future<T> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      debugPrint("API Error in ApiServices: $e");
      rethrow;
    }
  }
}
