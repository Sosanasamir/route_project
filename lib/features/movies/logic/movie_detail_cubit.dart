import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailSuccess extends MovieDetailState {
  final MovieModel movie;
  MovieDetailSuccess(this.movie);
}

class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository repository;

  MovieDetailCubit(this.repository) : super(MovieDetailInitial());

  Future<void> fetchMovieDetails(int movieId) async {
    emit(MovieDetailLoading());
    try {
      final movie = await repository.getMovieDetails(movieId);
      emit(MovieDetailSuccess(movie));
    } catch (e) {
      emit(MovieDetailError("Failed to load details. Please try again."));
    }
  }
}
