import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_repository.dart';
import 'package:movie_app/features/movies/logic/search_states.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository repository;
  SearchCubit(this.repository) : super(SearchInitial());

  void search(String query) async {
    emit(SearchLoading());
    try {
      final results = await repository.searchMovie(query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
