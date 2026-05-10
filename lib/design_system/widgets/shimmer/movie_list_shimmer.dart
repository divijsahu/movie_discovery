import 'package:flutter/material.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/shimmer_box.dart';

class MovieListShimmer extends StatelessWidget {
  const MovieListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: 70,
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  ShimmerBox(width: double.infinity, height: 16),
                  SizedBox(height: 8),
                  ShimmerBox(width: 80, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
