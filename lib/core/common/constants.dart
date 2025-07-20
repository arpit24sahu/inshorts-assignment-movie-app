import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String apiKey = dotenv.get("TMDB_API_KEY");
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageBaseUrl = 'https://image.tmdb.org/t/p/original';

  static const Duration cacheValidityDuration = Duration(hours: 4);
  static const Duration searchDebounceDelay = Duration(milliseconds: 1000);

  static const String moviesBoxName = 'movies_box';
  static const String savedMoviesBoxName = 'saved_movies_box';
  static const String cacheBoxName = 'cache_box';

  static const String movieDeepLinkPrefix = 'inshortsmovie://movie/';

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double movieCardAspectRatio = 0.67;
}

class ApiEndpoints {
  static const String trending = '/trending/movie/day';
  static const String nowPlaying = '/movie/now_playing';
  static const String search = '/search/movie';
}