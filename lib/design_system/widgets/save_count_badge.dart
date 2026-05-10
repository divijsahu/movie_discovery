import 'package:flutter/material.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';

class SaveCountBadge extends StatelessWidget {
  final int count;
  const SaveCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Container(
        key: ValueKey(count),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: count > 0
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.grey200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: count > 0 ? AppColors.primary : AppColors.grey500,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
