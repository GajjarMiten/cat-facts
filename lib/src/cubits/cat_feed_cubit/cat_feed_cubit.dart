import 'dart:async';

import 'package:catfact/src/core/extensions/cubit_extensions/cubit_extensions.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_repo.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_state.dart';
import 'package:catfact/src/models/fact_model.dart';
import 'package:catfact/src/services/index_service.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatFeedCubit extends Cubit<CatFeedState> {
  final CatFeedRepo _repo = CatFeedRepo.create();
  CatFeedCubit() : super(CatFeedState());

  int currentPage = 1;
  int lastPage = 1;
  Timer? catFactsFetcher;
  final intervalInSeconds = 10;

  bool hasInitialized = false;

  Timer? randomFactTimer;

  List<FactModel> get randomFacts {
    final facts = state.feedFacts.shuffled();

    return facts.length > 8 ? facts.sublist(8) : facts;
  }

  void init() {
    if (hasInitialized) return;
    hasInitialized = true;
    getFactsForFeed();
    fetchFactsIntervally();
    transferLocalDataToBackend();
    setRandomFactTimer();
  }

  void fetchFactsIntervally() {
    catFactsFetcher?.cancel();
    catFactsFetcher =
        Timer.periodic(Duration(seconds: intervalInSeconds), (timer) {
      currentPage++;
      currentPage %= lastPage;
      getFactsForFeed(fromTimer: true);
    });
  }

  void cancelFetchTimer() {
    catFactsFetcher?.cancel();
  }

  void getFactsForFeed({bool fromTimer = false}) async {
    try {
      if (fromTimer) {
        final res = await _repo.getFacts(pageNumber: currentPage);

        if (res.hasError || res.isNull) {
          emit(state.copyWith(hasErrors: true));
          return;
        }
        final data = List.from(res.data['data']);
        lastPage = res.data['last_page'];

        final feedList = data.map((e) => FactModel.fromMap(e));
        return emit(state.copyWith(feedFacts: feedList.toList(), hasErrors: false));
      }

      if (isProcessing) return;

      startProcessing();

      final res = await _repo.getFacts(pageNumber: currentPage);
      stopProcessing();
      if (res.hasError || res.isNull) {
        emit(state.copyWith(hasErrors: true));
        return;
      }

      final data = List.from(res.data['data']);
      lastPage = res.data['last_page'];

      final feedList = data.map((e) => FactModel.fromMap(e));
      emit(state.copyWith(feedFacts: feedList.toList(), hasErrors: false));
    } catch (e) {
      stopProcessing();
    }
  }

  void setRandomFactTimer() {
    randomFactTimer?.cancel();
    randomFactTimer = Timer.periodic(4.seconds, (timer) => _getRandomFact());
  }

  void _getRandomFact() async {
    try {
      final res = await _repo.getRandomFact();

      if (res.hasError || res.isNull) {
        return;
      }

      final randomFact = FactModel.fromMap(res.data);

      final allFacts = List<FactModel>.from(state.feedFacts);
      allFacts.add(randomFact);

      emit(state.copyWith(feedFacts: allFacts));
    } catch (e) {
      console(e);
    }
  }

  void transferLocalDataToBackend() async {
    try {
      final allData = analyticsService.getAllData();
      if (allData.isEmpty) return;

      final res = await _repo.sendData(allData);

      if (res != null) {
        analyticsService.clearLocalData();
      }
    } catch (e) {
      console(e);
    }
  }
}
