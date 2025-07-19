import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/common/theme.dart';
import 'core/navigation/app_router.dart';
import 'features/movies/data/models/movie_model.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';
import 'features/movies/presentation/bloc/movies_event.dart';
import 'features/movies/presentation/bloc/search_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await configureDependencies();
  
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MoviesBloc>()..add(LoadAllMovies())),
        BlocProvider(create: (context) => getIt<SearchBloc>(),),
      ],
      child: MaterialApp.router(
        title: 'Movies App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: getIt<AppRouter>().config,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}