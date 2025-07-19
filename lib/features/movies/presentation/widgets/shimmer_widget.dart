import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/constants.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[500]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? 
              BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}