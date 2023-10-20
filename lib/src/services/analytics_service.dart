part of "./index_service.dart";

class AnalyticsService {
  AnalyticsService._();

  static const _localDataKey = 'local-data-key';

  void syncFactMeta(FactMetaModel factMeta) {
    try {
      final MetaLookupTable allFactsMeta = MetaLookupTable.from(
          localStorageService.getValue(_localDataKey) ?? {});
      final factMetas = List<Map>.from(allFactsMeta[factMeta.factId] ?? []);
      factMetas.add(factMeta.toMap());

      allFactsMeta[factMeta.factId] = factMetas;

      localStorageService.setValue(_localDataKey, allFactsMeta);
    } catch (e, s) {
      console(e, stackTrace: s);
    }
  }

  MetaLookupTable getAllData() {
    try {
      return MetaLookupTable.from(
          localStorageService.getValue(_localDataKey) ?? {});
    } catch (e, s) {
      console(e, stackTrace: s);
      return {};
    }
  }

  void clearLocalData() {
    localStorageService.removeValue(_localDataKey);
  }
}
