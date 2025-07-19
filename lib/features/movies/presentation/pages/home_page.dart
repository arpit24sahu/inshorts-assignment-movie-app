import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_bar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Movies'),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MoviesBloc>().add(LoadAllMovies());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieSection(
                    title: 'Trending Movies',
                    movies: state.trendingMovies,
                    isLoading: state.isLoadingTrending,
                    onLoadMore: () {

                    },
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  MovieSection(
                    title: 'Now Playing',
                    movies: state.nowPlayingMovies,
                    isLoading: state.isLoadingNowPlaying,
                    onLoadMore: () {

                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}