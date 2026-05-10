import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/core/sync/sync_worker.dart';
import 'package:movie_discovery/core/utils/connectivity_service.dart';
import 'package:movie_discovery/features/users/data/users_api.dart';

class AddUserNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> addUser({
    required String name,
    required String movieTaste,
  }) async {
    state = const AsyncLoading();

    final isOnline = await ref.read(isOnlineProvider.future);
    final db = ref.read(appDatabaseProvider);

    final localId = await db.usersDao.insertUser(
      UsersTableCompanion.insert(
        name: name,
        movieTaste: movieTaste,
        pendingSync: Value(!isOnline),
      ),
    );

    if (isOnline) {
      try {
        final response =
            await ref.read(usersApiProvider).createUser(name, movieTaste);
        final serverId = response['id']?.toString();
        if (serverId != null) {
          await db.usersDao.updateServerId(localId, serverId);
        }
      } catch (_) {
        await db.usersDao
            .markSynced(localId); // keep local, will retry via WorkManager
        await _scheduleSync(localId);
      }
    } else {
      await _scheduleSync(localId);
    }

    state = const AsyncData(null);
  }

  Future<void> _scheduleSync(int localId) async {
    await Workmanager().registerOneOffTask(
      'sync_pending_users_$localId',
      SyncWorker.taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }
}

final addUserNotifierProvider =
    AsyncNotifierProvider<AddUserNotifier, void>(AddUserNotifier.new);
