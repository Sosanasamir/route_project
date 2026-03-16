import 'package:movie_app/features/movies/data/movie_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<MovieModel> movies;
  SearchSuccess(this.movies);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
