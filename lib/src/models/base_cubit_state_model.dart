// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class BaseCubitState {
  final bool isProcessing;
  BaseCubitState({
    this.isProcessing = false,
  });
  BaseCubitState startProcessing();
  BaseCubitState stopProcessing();
  BaseCubitState clearState();
}
