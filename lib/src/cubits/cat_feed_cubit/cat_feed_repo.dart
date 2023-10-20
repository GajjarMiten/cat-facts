import 'package:catfact/src/config/globals.dart';
import 'package:catfact/src/config/http/types/response.dart';
import 'package:catfact/src/core/enums/http/http_base_url.dart';
import 'package:catfact/src/core/enums/http/http_endpoints.dart';
import 'package:catfact/src/services/index_service.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:catfact/src/utils/utils.dart';

class CatFeedRepo {
  static CatFeedRepo? _instance;

  CatFeedRepo._();
  static CatFeedRepo get instance => _instance ?? CatFeedRepo.create();

  factory CatFeedRepo.create() {
    _instance ??= CatFeedRepo._();
    return _instance!;
  }

  Future<HttpResult> getFacts({int pageNumber = 1}) async {
    try {
      final res = await api.get(
        Endpoints.allFacts,
        base: BaseUrl.catService,
        queryParams: {
          "limit": factsPerPage,
          "page": pageNumber,
        },
      );

      return res;
    } catch (e) {
      return HttpResult.error(e.toString());
    }
  }

  Future<HttpResult> getRandomFact() async {
    try {
      final res = await api.get(
        Endpoints.fact,
        base: BaseUrl.catService,
      );
      return res;
    } catch (e) {
      return HttpResult.error(e.toString());
    }
  }

  Future sendData(MetaLookupTable data) async {
    try {
      final db = firestoreService.metaDataDB;

      final batch = firestoreService.batch;
      for (var entry in data.entries) {
        final docId = entry.key.toString();
        final data = entry.value;
        final docRef = db.doc(docId);
        batch.set(docRef, {
          "logs": data,
        });
      }
      await batch.commit();
    } catch (e, s) {
      Utils.showErrorToast('Data Sync Failed');
      console(e, stackTrace: s);
    }
  }
}
