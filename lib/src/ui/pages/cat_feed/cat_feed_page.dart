import 'package:catfact/src/core/app_theme.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_cubit.dart';
import 'package:catfact/src/cubits/index_cubit.dart';
import 'package:catfact/src/ui/pages/cat_feed/widgets/feed_error_widget.dart';
import 'package:catfact/src/ui/pages/cat_feed/widgets/feed_loading_widget.dart';
import 'package:catfact/src/ui/pages/cat_feed/widgets/feed_widget.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatFeedPage extends StatefulWidget {
  const CatFeedPage({super.key});

  @override
  State<CatFeedPage> createState() => _CatFeedPageState();
}

class _CatFeedPageState extends State<CatFeedPage> with WidgetsBindingObserver {
  @override
  void initState() {
    catFeedCubit.init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) {
      // here we have to let analytics service to store current meta data first
      Future.delayed(1.seconds, catFeedCubit.transferLocalDataToBackend);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CatFeedCubit>().state;
    return Scaffold(
      backgroundColor: AppTheme.appBgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.appBgColor,
        title: const Text("Cat Facts"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    final hasErrors = catFeedState.hasErrors;
    final isProcessing = catFeedState.isProcessing;

    if (isProcessing) {
      return const FeedLoadingWidget();
    } else if (hasErrors) {
      return const FeedErrorWidegt();
    }

    return const FeedWidget();
  }
}
