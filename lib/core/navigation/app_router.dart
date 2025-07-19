import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/movies/presentation/pages/main_page.dart';
import '../../features/movies/presentation/pages/movie_detail_page.dart';
import '../../features/movies/domain/entities/movie.dart';

class AppRouter {
  static const String home = '/';
  static const String movieDetail = '/movie/:id';
  
  late final GoRouter config = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: movieDetail,
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          final movie = state.extra as Movie?;
          return MovieDetailPage(movieId: movieId, movie: movie);
        },
      ),
    ],
  );
  
  static void navigateToMovieDetail(BuildContext context, Movie movie) {
    context.push('/movie/${movie.id}', extra: movie);
  }
  
  static void navigateToMovieDetailById(BuildContext context, int movieId) {
    context.push('/movie/$movieId');
  }
}