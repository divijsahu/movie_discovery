import 'package:workmanager/workmanager.dart';

class SyncWorker {
  static const taskName = 'sync_pending_users';

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Sync logic will be implemented in Phase 7
    return Future.value(true);
  });
}
