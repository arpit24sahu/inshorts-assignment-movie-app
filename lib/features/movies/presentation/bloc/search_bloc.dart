import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/common/constants.dart';
import 'package:movie/features/movies/presentation/bloc/search_event.dart';
import 'package:movie/features/movies/presentation/bloc/search_state.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/use_cases/search_movies.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase searchMovies;

  SearchBloc({required this.searchMovies}) : super(const SearchState()) {
    on<SearchMoviesEvent>(
      _onSearchMovies,
      transformer: _debounce(AppConstants.searchDebounceDelay),
    );
    on<ClearSearchEvent>(_onClearSearch);
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  Future<void> _onSearchMovies(SearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(movies: [], isLoading: false, query: '', error: null));
      return;
    }

    emit(state.copyWith(isLoading: true, query: event.query, error: null));
    try {
      final movies = await searchMovies(event.query);
      emit(state.copyWith(
        movies: movies,
        isLoading: false,
        query: event.query,
        error: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearSearch(ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchState());
  }
}