import 'dart:async';

import 'package:catfact/src/config/environment.dart';
import 'package:catfact/src/config/globals.dart';
import 'package:catfact/src/cubits/index_cubit.dart';
import 'package:catfact/src/services/index_service.dart';
import 'package:catfact/src/ui/pages/cat_feed/cat_feed_page.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> setupApp() async {
  await initFirebase();
  await registerServices();
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupApp();
    runApp(const _CatFactWrapper());
  }, (err, stack) {
    console(err, logLevel: Level.fatal, stackTrace: stack, error: err);
    FlutterError.onError = logFlutterError;
    if (!kDevMode) {
      // log errors to third party services
    }
  });
}

class _CatFactWrapper extends StatelessWidget {
  const _CatFactWrapper();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: allProviders,
      child: const _CatFactApp(),
    );
  }
}

class _CatFactApp extends StatelessWidget {
  const _CatFactApp();

  @override
  Widget build(BuildContext context) {
    gContext = context;
    return MaterialApp(
      title: 'Cat Facts',
      debugShowCheckedModeBanner: kDevMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _HomeWrapper(),
    );
  }
}

class _HomeWrapper extends StatefulWidget {
  const _HomeWrapper();

  @override
  State<_HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<_HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return const CatFeedPage();
  }
}
