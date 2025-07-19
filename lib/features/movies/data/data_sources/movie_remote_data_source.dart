import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/movie_model.dart';
import '../../domain/entities/movie.dart';

part 'movie_remote_data_source.g.dart';

abstract class MovieRemoteDataSource {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> searchMovies(String query);
}

@RestApi()
abstract class MovieApiClient {
  factory MovieApiClient(Dio dio) = _MovieApiClient;

  @GET('/trending/movie/day')
  Future<MoviesResponse> getTrendingMovies();

  @GET('/movie/now_playing')
  Future<MoviesResponse> getNowPlayingMovies();

  @GET('/search/movie')
  Future<MoviesResponse> searchMovies(@Query('query') String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiClient _apiClient;

  MovieRemoteDataSourceImpl(Dio dio) : _apiClient = MovieApiClient(dio);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    final response = await _apiClient.getTrendingMovies();
    return response.results;
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await _apiClient.getNowPlayingMovies();
    return response.results;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response = await _apiClient.searchMovies(query);
    return response.results;
  }
}