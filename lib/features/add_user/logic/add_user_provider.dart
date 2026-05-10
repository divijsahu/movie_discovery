import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'package:movie_discovery/core/storage/database/app_database.dart';
import 'package:movie_discovery/core/sync/sync_worker.dart';
import 'package:movie_discovery/core/utils/connectivity_service.dart';
import 'package:movie_discovery/features/users/data/users_api.dart';

// ignore_for_file: avoid_print

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

    if (kDebugMode) print('\n👤 [AddUser] submitting "$name" — online: $isOnline');

    final localId = await db.usersDao.insertUser(
      UsersTableCompanion.insert(
        name: name,
        movieTaste: movieTaste,
        pendingSync: Value(!isOnline),
      ),
    );
    if (kDebugMode) print('💾 [AddUser] saved locally  (localId=$localId, pendingSync=${!isOnline})');

    if (isOnline) {
      try {
        final response =
            await ref.read(usersApiProvider).createUser(name, movieTaste);
        final serverId = response['id']?.toString();
        if (serverId != null) {
          await db.usersDao.updateServerId(localId, serverId);
          if (kDebugMode) print('☁️  [AddUser] synced to Reqres  (serverId=$serverId)');
        }
      } catch (e) {
        if (kDebugMode) print('⚠️  [AddUser] POST failed, scheduling background sync: $e');
        await _scheduleSync(localId);
      }
    } else {
      if (kDebugMode) print('📵 [AddUser] offline — WorkManager task queued for localId=$localId');
      await _scheduleSync(localId);
    }

    if (kDebugMode) print('✅ [AddUser] done');
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
