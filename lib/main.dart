import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/app.dart';
import 'package:movie_discovery/core/sync/sync_worker.dart';

// ignore_for_file: avoid_print

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep the native splash visible until we finish initialising
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (kDebugMode) print('\n🎬 [App] initialising...');
  await SyncWorker.initialize();
  if (kDebugMode) print('🔄 [App] WorkManager ready');
  await _syncOnLaunch();
  if (kDebugMode) print('🚀 [App] launching\n');

  // Dismiss the native splash — Flutter takes over
  FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: App()));
}

Future<void> _syncOnLaunch() async {
  try {
    final results = await Connectivity().checkConnectivity();
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (!isOnline) {
      if (kDebugMode) print('📵 [App] offline — skipping launch sync');
      return;
    }
    await runPendingUserSync();
  } catch (e) {
    if (kDebugMode) print('⚠️  [App] launch sync error: $e');
  }
}
