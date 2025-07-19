import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../common/constants.dart';
import '../navigation/app_router.dart';
import '../../features/movies/data/data_sources/movie_local_data_source.dart';
import '../../features/movies/data/data_sources/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/use_cases/get_now_playing_movies.dart';
import '../../features/movies/domain/use_cases/get_trending_movies.dart';
import '../../features/movies/domain/use_cases/get_saved_movies.dart';
import '../../features/movies/domain/use_cases/save_movie.dart';
import '../../features/movies/domain/use_cases/remove_movie.dart';
import '../../features/movies/domain/use_cases/search_movies.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';
import '../../features/movies/presentation/bloc/search_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register Dio
  final dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));
  
  dio.options.baseUrl = AppConstants.baseUrl;
  dio.options.queryParameters = {'api_key': AppConstants.apiKey};
  
  getIt.registerSingleton<Dio>(dio);
  
  // Register Hive boxes
  final moviesBox = await Hive.openBox(AppConstants.moviesBoxName);
  final savedMoviesBox = await Hive.openBox(AppConstants.savedMoviesBoxName);
  final cacheBox = await Hive.openBox(AppConstants.cacheBoxName);
  
  getIt.registerSingleton<Box>(moviesBox, instanceName: 'moviesBox');
  getIt.registerSingleton<Box>(savedMoviesBox, instanceName: 'savedMoviesBox');
  getIt.registerSingleton<Box>(cacheBox, instanceName: 'cacheBox');
  
  // Register navigation
  getIt.registerSingleton<AppRouter>(AppRouter());
  
  // Register data sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt<Dio>()),
  );
  
  getIt.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      getIt<Box>(instanceName: 'moviesBox'),
      getIt<Box>(instanceName: 'savedMoviesBox'),
      getIt<Box>(instanceName: 'cacheBox'),
    ),
  );
  
  // Register repository
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      getIt<MovieRemoteDataSource>(),
      getIt<MovieLocalDataSource>(),
    ),
  );
  
  // Register use cases
  getIt.registerLazySingleton(() => GetTrendingMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetNowPlayingMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetSavedMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => SaveMovie(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => RemoveMovie(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => SearchMovies(getIt<MovieRepository>()));
  
  // Register blocs
  getIt.registerFactory(
    () => MoviesBloc(
      getTrendingMovies: getIt<GetTrendingMovies>(),
      getNowPlayingMovies: getIt<GetNowPlayingMovies>(),
      getSavedMovies: getIt<GetSavedMovies>(),
      saveMovie: getIt<SaveMovie>(),
      removeMovie: getIt<RemoveMovie>(),
    ),
  );
  
  getIt.registerFactory(
    () => SearchBloc(searchMovies: getIt<SearchMovies>()),
  );
}