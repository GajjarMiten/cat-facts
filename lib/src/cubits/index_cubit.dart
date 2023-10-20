import 'package:catfact/src/config/globals.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_cubit.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

final List<SingleChildWidget> allProviders = [
  BlocProvider(create: (_) => CatFeedCubit()),
];

CatFeedCubit get catFeedCubit => gContext.read<CatFeedCubit>();
CatFeedState get catFeedState => catFeedCubit.state;
