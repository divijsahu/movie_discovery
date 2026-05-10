import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/app.dart';
import 'package:movie_discovery/core/sync/sync_worker.dart';

// ignore_for_file: avoid_print

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) print('\n🎬 [App] initialising...');
  await SyncWorker.initialize();
  if (kDebugMode) print('🔄 [App] WorkManager ready');
  if (kDebugMode) print('🚀 [App] launching\n');
  runApp(const ProviderScope(child: App()));
}
