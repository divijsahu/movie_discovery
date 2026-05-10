import 'package:flutter/material.dart';
import 'package:movie_discovery/design_system/widgets/shimmer/shimmer_box.dart';

class UserListShimmer extends StatelessWidget {
  const UserListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ShimmerBox(width: 44, height: 44, borderRadius: BorderRadius.all(Radius.circular(22))),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 14),
                  SizedBox(height: 6),
                  ShimmerBox(width: 120, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
