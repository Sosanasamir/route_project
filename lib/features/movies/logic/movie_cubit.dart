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

  List<MovieModel> historyMovies = [];

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

      _emitSuccess();
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void addToHistory(MovieModel movie) {
    historyMovies.removeWhere((item) => item.id == movie.id);

    historyMovies.insert(0, movie);

    if (historyMovies.length > 20) {
      historyMovies.removeLast();
    }

    _emitSuccess();
  }

  Future<void> getMovies() async {
    if (allMovies.isNotEmpty) {
      _emitSuccess();
      return;
    }
    await getHomeMovies();
  }

  Future<void> searchMovie(String query) async {
    if (query.isEmpty) {
      _emitSuccess();
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

  void _emitSuccess() {
    emit(
      MovieSuccess(
        suggested: suggestedMovies,
        action: actionMovies,
        all: allMovies,
      ),
    );
  }
}
