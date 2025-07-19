import 'package:flutter/material.dart';

import '../../../../core/common/constants.dart';
import 'shimmer_widget.dart';

class LoadingGrid extends StatelessWidget {
  const LoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: AppConstants.smallPadding,
        mainAxisSpacing: AppConstants.smallPadding,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ShimmerWidget(),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.smallPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 16),
                      SizedBox(height: 4),
                      ShimmerWidget(height: 12, width: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}