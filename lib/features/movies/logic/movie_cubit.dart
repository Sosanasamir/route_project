import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository movieRepository;

  MovieCubit(this.movieRepository) : super(MovieInitial());

  List<MovieModel> _suggestedMovies = [];
  List<MovieModel> _actionMovies = [];
  List<MovieModel> _historyMovies = [];

  List<MovieModel> get historyMovies => _historyMovies;

  Future<void> getHomeMovies() async {
    emit(MovieLoading());
    try {
      final results = await Future.wait([
        movieRepository.getMoviesByGenre('sci-fi'),
        movieRepository.getMoviesByGenre('Action'),
      ]);

      _suggestedMovies = results[0];
      _actionMovies = results[1];

      _emitSuccess();
    } catch (e) {
      emit(MovieError("Failed to fetch movies: ${e.toString()}"));
    }
  }

  void addToHistory(MovieModel movie) {
    _historyMovies.removeWhere((item) => item.id == movie.id);

    _historyMovies.insert(0, movie);

    if (_historyMovies.length > 20) {
      _historyMovies.removeLast();
    }

    _emitSuccess();
  }

  void _emitSuccess() {
    emit(
      MovieSuccess(
        suggested: _suggestedMovies,
        action: _actionMovies,
        history: _historyMovies,
        all: [],
      ),
    );
  }
}
