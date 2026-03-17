import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository repository;

  MovieCubit(this.repository) : super(MovieInitial());

  List<MovieModel> allMovies = [];
  List<MovieModel> suggestedMovies = [];
  List<MovieModel> actionMovies = [];

  Future<void> getHomeMovies() async {
    emit(MovieLoading());
    try {
      final results = await Future.wait([
        repository.getMovieSuggestions(10),
        repository.getMoviesByGenre('Action'),
      ]);

      suggestedMovies = results[0];
      actionMovies = results[1];
      allMovies = [...suggestedMovies, ...actionMovies];

      emit(
        MovieSuccess(
          suggested: suggestedMovies,
          action: actionMovies,
          all: allMovies,
        ),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> searchMovie(String query) async {
    if (query.isEmpty) {
      emit(
        MovieSuccess(
          suggested: suggestedMovies,
          action: actionMovies,
          all: allMovies,
        ),
      );
      return;
    }

    emit(MovieLoading());
    try {
      final searchedMovies = await repository.searchMovie(query);
      emit(MovieSuccess(suggested: [], action: [], all: searchedMovies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
