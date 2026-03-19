import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository movieRepository;

  MovieCubit(this.movieRepository) : super(MovieInitial());

  List<MovieModel> allMovies = [];
  List<MovieModel> suggestedMovies = [];
  List<MovieModel> actionMovies = [];
  List<MovieModel> historyMovies = [];
  List<MovieModel> watchListMovies = []; 

  Future<void> getHomeMovies() async {
    emit(MovieLoading());
    try {
      final results = await Future.wait([
        movieRepository.getMovieSuggestions(10),
        movieRepository.getMoviesByGenre('Action'),
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
    if (historyMovies.length > 20) historyMovies.removeLast();
    _emitSuccess();
  }

  void addToWatchList(MovieModel movie) {
    if (!watchListMovies.any((item) => item.id == movie.id)) {
      watchListMovies.add(movie);
    }
    _emitSuccess();
  }

  void removeFromWatchList(MovieModel movie) {
    watchListMovies.removeWhere((item) => item.id == movie.id);
    _emitSuccess();
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