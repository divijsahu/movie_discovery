import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_discovery/core/network/api_constants.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:workmanager/workmanager.dart';

// ignore_for_file: avoid_print

class SyncWorker {
  static const taskName = 'sync_pending_users';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }
}

/// Shared sync logic — called by both the WorkManager callback and on app launch.
/// Opens its own DB and Dio instances (no Riverpod — may run in a separate isolate).
Future<bool> runPendingUserSync() async {
  if (kDebugMode) print('\n🔄 [Sync] running pending user sync...');

  final db = AppDatabase();
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.reqresBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ))..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['x-api-key'] = ApiConstants.reqresApiKey;
        handler.next(options);
      },
    ));

  try {
    final pending = await db.usersDao.getPendingSyncUsers();
    if (kDebugMode) print('🔄 [Sync] ${pending.length} pending user(s) to sync');

    for (final user in pending) {
      try {
        final response = await dio.post(
          ApiConstants.users,
          data: {'name': user.name, 'job': user.movieTaste},
        );
        final serverId = response.data['id']?.toString();
        if (serverId != null) {
          await db.usersDao.updateServerId(user.id, serverId);
        }
        await db.usersDao.markSynced(user.id);
        if (kDebugMode) print('☁️  [Sync] synced "${user.name}" → serverId=$serverId');
      } catch (e) {
        if (kDebugMode) print('⚠️  [Sync] failed to sync "${user.name}": $e');
      }
    }

    if (kDebugMode) print('✅ [Sync] done\n');
    return true;
  } finally {
    await db.close();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != SyncWorker.taskName) return true;
    return runPendingUserSync();
  });
}
