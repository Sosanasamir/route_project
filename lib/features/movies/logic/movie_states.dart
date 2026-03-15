import 'package:movie_app/features/movies/data/movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}

class MovieSuccess extends MovieState {
  final List<MovieModel> suggested;
  final List<MovieModel> action;
  final List<MovieModel> all;

  MovieSuccess({
    required this.suggested,
    required this.action,
    required this.all,
  });
}
