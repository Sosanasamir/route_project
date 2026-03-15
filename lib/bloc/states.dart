import 'package:movie_app/models/movie_model.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieSuccess extends MovieState {
  final List<MovieModel> suggestions;
  final List<MovieModel> actionMovies;
  final List<MovieModel> allMovies;

  MovieSuccess(this.suggestions, this.actionMovies, this.allMovies);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}
