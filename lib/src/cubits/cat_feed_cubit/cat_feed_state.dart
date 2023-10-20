// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catfact/src/models/base_cubit_state_model.dart';
import 'package:catfact/src/models/fact_model.dart';

class CatFeedState extends BaseCubitState {
  final List<FactModel> feedFacts;
  final bool hasErrors;

  CatFeedState({
    super.isProcessing = false,
    this.hasErrors = false,
    this.feedFacts = const [],
  });

  @override
  CatFeedState clearState() => CatFeedState();

  @override
  CatFeedState startProcessing() => copyWith(isProcessing: true);

  @override
  CatFeedState stopProcessing() => copyWith(isProcessing: false);

  CatFeedState copyWith(
      {bool? isProcessing, List<FactModel>? feedFacts, bool? hasErrors}) {
    return CatFeedState(
      isProcessing: isProcessing ?? this.isProcessing,
      feedFacts: feedFacts ?? this.feedFacts,
      hasErrors: hasErrors ?? this.hasErrors,
    );
  }
}
