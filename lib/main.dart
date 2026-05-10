import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/app.dart';
import 'package:movie_discovery/core/sync/sync_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SyncWorker.initialize();
  runApp(const ProviderScope(child: App()));
}
