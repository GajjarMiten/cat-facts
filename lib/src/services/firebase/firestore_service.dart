part of '../index_service.dart';

typedef FirebaseCollection = CollectionReference<Map<String, dynamic>>;

class FirestoreService {
  FirestoreService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService() {
    _firestore.settings = const Settings(persistenceEnabled: true);
  }

  WriteBatch get batch => _firestore.batch();

  FirebaseCollection get apiLogsDB =>
      _getCollection(FirebaseCollectionEnum.apiLogs);

  FirebaseCollection get metaDataDB =>
      _getCollection(FirebaseCollectionEnum.metaData);

  FirebaseCollection _getCollection(FirebaseCollectionEnum collection) {
    return _firestore.collection(collection.name);
  }
}
