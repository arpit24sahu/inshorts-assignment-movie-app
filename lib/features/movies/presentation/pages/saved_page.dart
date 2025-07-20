import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/movie_grid.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loading_grid.dart';
import '../../domain/entities/movie.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  String _searchQuery = '';
  List<Movie> _filteredMovies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Saved Movies'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: SearchBarWidget(
              hintText: 'Search saved movies...',
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state.isLoadingSaved) {
                  return const LoadingGrid();
                }

                if (state.savedMovies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Text(
                          'No saved movies yet',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          'Start bookmarking your favorite movies!',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                _filteredMovies = _searchQuery.isEmpty
                    ? state.savedMovies
                    : state.savedMovies
                        .where((movie) => movie.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                if (_filteredMovies.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        Text(
                          'No saved movies found for "$_searchQuery"',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return MovieGrid(movies: _filteredMovies);
              },
            ),
          ),
        ],
      ),
    );
  }
}