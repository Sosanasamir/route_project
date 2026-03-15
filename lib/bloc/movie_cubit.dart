import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/repository/movie_repository.dart';
import 'states.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;

  MovieCubit(this.repository) : super(MovieInitial());

  List<MovieModel> allMovies = [];

// get all movies
  Future<void> getHomeMovies() async {
    emit(MovieLoading());
    try {
      final futureSuggested = repository.getMovieSuggestions(10);
      final futureAction = repository.getMoviesByGenre('Action');

      final results = await Future.wait([futureSuggested, futureAction]);

      final suggestedMovies = results[0];
      final actionMovies = results[1];

      allMovies = [...suggestedMovies, ...actionMovies];

      emit(MovieSuccess(suggestedMovies, actionMovies, allMovies));
    } catch (e) {
      emit(MovieError('Error fetching home movies: $e'));
    }
  }

  // search movie
  Future<void> searchMovie(String query) async {
    emit(MovieLoading());
    try {
      if (query.isEmpty) {
        emit(MovieSuccess([], [], allMovies));
        return;
      }

      final searchedMovies = await repository.searchMovie(query);
      emit(MovieSuccess([], [], searchedMovies));
    } catch (e) {
      emit(MovieError('Error searching movies: $e'));
    }
  }
}