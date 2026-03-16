import 'package:movie_app/features/movies/data/movie_response.dart';

class MovieDetailsResponse {
  final MovieData data;

  MovieDetailsResponse({required this.data});

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailsResponse(data: MovieData.fromJson(json['data']));
  }
}

class MovieData {
  final Movies? movie;

  MovieData({this.movie});

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      movie: json['movie'] != null ? Movies.fromJson(json['movie']) : null,
    );
  }
}
