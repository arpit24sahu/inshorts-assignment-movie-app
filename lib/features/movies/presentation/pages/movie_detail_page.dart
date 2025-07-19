import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/movies_event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/navigation/app_router.dart';
import '../bloc/movies_bloc.dart';
import '../../domain/entities/movie.dart';
import '../widgets/shimmer_widget.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  final Movie? movie;

  const MovieDetailPage({
    super.key,
    required this.movieId,
    this.movie,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  void _checkIfSaved() {
    final savedMovies = context.read<MoviesBloc>().state.savedMovies;
    setState(() {
      _isSaved = savedMovies.any((movie) => movie.id == widget.movieId);
    });
  }

  void _toggleSaved() {
    if (widget.movie == null) return;

    if (_isSaved) {
      context.read<MoviesBloc>().add(RemoveMovieEvent(widget.movieId));
    } else {
      context.read<MoviesBloc>().add(SaveMovieEvent(widget.movie!));
    }

    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void _shareMovie() {
    if (widget.movie == null) return;

    final shareUrl = '${AppConstants.movieDeepLinkPrefix}${widget.movieId}';
    Share.share(
      'Check out this movie: ${widget.movie!.title}\n$shareUrl',
      subject: widget.movie!.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movie == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Movie not found'),
        ),
      );
    }

    final movie = widget.movie!;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: movie.fullBackdropPath.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.fullBackdropPath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerWidget(),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: const Icon(Icons.error),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Icon(
                        Icons.movie,
                        size: 100,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                onPressed: _toggleSaved,
                icon: Icon(
                  _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: _isSaved 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.white,
                ),
              ),
              IconButton(
                onPressed: _shareMovie,
                icon: const Icon(Icons.share, color: Colors.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        child: SizedBox(
                          width: 120,
                          height: 180,
                          child: movie.fullPosterPath.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: movie.fullPosterPath,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerWidget(),
                                  errorWidget: (context, url, error) => Container(
                                    color: Theme.of(context).colorScheme.surface,
                                    child: const Icon(Icons.error),
                                  ),
                                )
                              : Container(
                                  color: Theme.of(context).colorScheme.surface,
                                  child: const Icon(Icons.movie, size: 50),
                                ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      
                      // Movie Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            
                            if (movie.releaseDate.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.releaseDate,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.smallPadding),
                            ],
                            
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${movie.voteAverage.toStringAsFixed(1)}/10',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: AppConstants.smallPadding),
                                Text(
                                  '(${movie.voteCount} votes)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  
                  // Overview
                  if (movie.overview.isNotEmpty) ...[
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppConstants.largePadding),
                  ],
                  
                  // Additional Info
                  _buildInfoSection(context, movie),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movie Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  'Original Title',
                  movie.originalTitle,
                ),
                const Divider(),
                _buildDetailRow(
                  context,
                  'Language',
                  movie.originalLanguage.toUpperCase(),
                ),
                const Divider(),
                _buildDetailRow(
                  context,
                  'Popularity',
                  movie.popularity.toStringAsFixed(1),
                ),
                if (movie.adult) ...[
                  const Divider(),
                  _buildDetailRow(
                    context,
                    'Rating',
                    'Adult Content',
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}