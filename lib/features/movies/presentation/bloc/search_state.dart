import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

class SearchState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final String query;
  final String? error;

  const SearchState({
    this.movies = const [],
    this.isLoading = false,
    this.query = '',
    this.error,
  });

  SearchState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? query,
    String? error,
  }) {
    return SearchState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [movies, isLoading, query, error];
}