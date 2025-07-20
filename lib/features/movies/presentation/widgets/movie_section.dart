import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';
import 'shimmer_widget.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    this.isLoading = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        
        SizedBox(
          height: 280,
          child: isLoading && movies.isEmpty
              ? _buildLoadingShimmer()
              : _buildMovieList(),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      key: ValueKey("shimmer_list"),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: AppConstants.smallPadding),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ShimmerWidget(),
              ),
              SizedBox(height: AppConstants.smallPadding),
              ShimmerWidget(
                height: 16,
                width: double.infinity,
              ),
              SizedBox(height: 4),
              ShimmerWidget(
                height: 14,
                width: 100,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      itemCount: movies.length + (onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length && onLoadMore != null) {
          return _buildLoadMoreButton();
        }

        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: AppConstants.smallPadding),
          child: MovieCard(movie: movies[index]),
        );
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: AppConstants.smallPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: onLoadMore,
              icon: const Icon(Icons.arrow_forward, color: Colors.grey),
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          const Text(
            'Load More',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}