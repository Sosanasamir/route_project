import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/profile/data/watchlist_repository.dart';

class WatchlistCubit extends Cubit<List<MovieModel>> {
  final WatchlistRepository repository;

  WatchlistCubit(this.repository) : super([]);

  Future<void> getWatchlist() async {
    try {
      final movies = await repository.getWatchlist();
      emit(movies);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> toggleWatchlist(MovieModel movie) async {
    final isExist = state.any((item) => item.id == movie.id);

    if (isExist) {
      final updatedList = state.where((item) => item.id != movie.id).toList();

      emit(updatedList);

      try {
        await repository.removeFromWatchlist(movie.id!);
      } catch (e) {
        print("Failed to remove from DB: $e");
      }
    } else {
      emit([movie, ...state]);

      try {
        await repository.addToWatchlist(movie);
      } catch (e) {
        print("Failed to add to DB: $e");
      }
    }
  }

  Future<void> clearWatchlist() async {
    try {
      emit([]);

      await repository.clearAllWatchlist();
    } catch (e) {
      print("Error clearing watchlist: $e");
    }
  }

  bool isBookmarked(int movieId) {
    return state.any((movie) => movie.id == movieId);
  }
}
