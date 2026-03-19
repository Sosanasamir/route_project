import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';

abstract class SimilarMoviesState {}

class SimilarMoviesInitial extends SimilarMoviesState {}

class SimilarMoviesLoading extends SimilarMoviesState {}

class SimilarMoviesSuccess extends SimilarMoviesState {
  final List<MovieModel> movies;
  SimilarMoviesSuccess(this.movies);
}

class SimilarMoviesError extends SimilarMoviesState {
  final String message;
  SimilarMoviesError(this.message);
}

class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  final MovieRepository repository;

  SimilarMoviesCubit(this.repository) : super(SimilarMoviesInitial());

  Future<void> fetchSimilarMovies(int movieId) async {
    emit(SimilarMoviesLoading());
    try {
      final movies = await repository.getMovieSuggestions(movieId);
      emit(SimilarMoviesSuccess(movies));
    } catch (e) {
      emit(
        SimilarMoviesError("Failed to load similar movies. Please try again."),
      );
    }
  }
}
