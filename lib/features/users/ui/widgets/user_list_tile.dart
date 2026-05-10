import 'package:flutter/material.dart';
import 'package:movie_discovery/core/router/route_names.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/design_system/app_colors.dart';
import 'package:movie_discovery/design_system/app_text_styles.dart';

class UserListTile extends StatelessWidget {
  final UserWithSaveCount item;
  final VoidCallback? onTap;

  const UserListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final user = item.user;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 22,
        backgroundImage:
            user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null
            ? Text(user.name[0].toUpperCase())
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(user.name,
                style: AppTextStyles.h3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          if (user.pendingSync) ...[
            const SizedBox(width: 6),
            const Icon(Icons.sync_rounded, size: 14, color: AppColors.grey500),
          ],
        ],
      ),
      subtitle: user.movieTaste.isNotEmpty
          ? Text(user.movieTaste,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: item.saveCount > 0
          ? GestureDetector(
              onTap: () => context.push(RouteNames.savedMovies(user.id)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${item.saveCount} saved',
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ),
            )
          : null,
    );
  }
}
