import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';

class BrowseCubit extends Cubit<MovieState> {
  final MovieRepository repository;

  BrowseCubit(this.repository) : super(MovieInitial());

  Future<void> getBrowseMovies() async {
    emit(MovieLoading());
    try {
      final movies = await repository.getMoviesByGenre('all');
      emit(MovieSuccess(suggested: [], action: [], all: movies, history: []));
    } catch (e) {
      emit(MovieError("Failed to load browse movies"));
    }
  }

  Future<void> getMoviesByGenre(String genre) async {
    emit(MovieLoading());
    try {
      final movies = await repository.getMoviesByGenre(genre);
      emit(MovieSuccess(suggested: [], action: [], all: movies, history: []));
    } catch (e) {
      emit(MovieError("Failed to load movies for $genre"));
    }
  }
}
