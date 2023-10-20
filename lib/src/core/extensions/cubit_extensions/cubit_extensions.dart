import 'package:catfact/src/models/base_cubit_state_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension CubitExt<T extends Cubit<BaseCubitState>> on T {
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void startProcessing() => emit(state.startProcessing());
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void stopProcessing() => emit(state.stopProcessing());
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void clear() => emit(state.clearState());

  bool get isProcessing => state.isProcessing;
}

extension BlocExt<T extends Bloc<dynamic, BaseCubitState>> on T {
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void startProcessing() => emit(state.startProcessing());
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void stopProcessing() => emit(state.stopProcessing());
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void clear() => emit(state.clearState());
}
