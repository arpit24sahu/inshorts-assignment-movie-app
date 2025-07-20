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

  final moviesBox = await Hive.openBox(AppConstants.moviesBoxName);
  final savedMoviesBox = await Hive.openBox(AppConstants.savedMoviesBoxName);
  final cacheBox = await Hive.openBox(AppConstants.cacheBoxName);
  
  getIt.registerSingleton<Box>(moviesBox, instanceName: 'moviesBox');
  getIt.registerSingleton<Box>(savedMoviesBox, instanceName: 'savedMoviesBox');
  getIt.registerSingleton<Box>(cacheBox, instanceName: 'cacheBox');

  getIt.registerSingleton<AppRouter>(AppRouter());

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

  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      getIt<MovieRemoteDataSource>(),
      getIt<MovieLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(() => GetTrendingMoviesUseCase(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetNowPlayingMoviesUseCase(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetSavedMoviesUseCase(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => SaveMovieUseCase(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => RemoveMovieUseCase(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => SearchMoviesUseCase(getIt<MovieRepository>()));

  getIt.registerFactory(
    () => MoviesBloc(
      getTrendingMovies: getIt<GetTrendingMoviesUseCase>(),
      getNowPlayingMovies: getIt<GetNowPlayingMoviesUseCase>(),
      getSavedMovies: getIt<GetSavedMoviesUseCase>(),
      saveMovie: getIt<SaveMovieUseCase>(),
      removeMovie: getIt<RemoveMovieUseCase>(),
    ),
  );
  
  getIt.registerFactory(
    () => SearchBloc(searchMovies: getIt<SearchMoviesUseCase>()),
  );
}