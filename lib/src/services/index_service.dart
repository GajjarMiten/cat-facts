import 'package:catfact/firebase_options.dart';
import 'package:catfact/src/config/http/http_exports.dart';
import 'package:catfact/src/models/fact_meta_model.dart';
import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:catfact/src/core/enums/firebase_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

part './logging_service.dart';
part './firebase/firebase_service.dart';
part './firebase/firestore_service.dart';
part './local_storage_service.dart';
part './analytics_service.dart';

typedef MetaLookupTable = Map<int, List<dynamic>>;

Future<void> registerServices() async {
  GetIt.I.registerSingleton(FirestoreService._());
  GetIt.I.registerSingleton(LoggingService._());
  GetIt.I.registerSingleton(AnalyticsService._());
  GetIt.I.registerSingletonAsync(() => LocalStorageService.init());
  await GetIt.I.allReady(timeout: 3.seconds);
}

T _getSinglton<T extends Object>() {
  return GetIt.I<T>();
}

LoggingService get loggingService => _getSinglton<LoggingService>();
FirestoreService get firestoreService => _getSinglton<FirestoreService>();
LocalStorageService get localStorageService =>
    _getSinglton<LocalStorageService>();
AnalyticsService get analyticsService => _getSinglton<AnalyticsService>();
