import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catfact/src/config/globals.dart';
import 'package:catfact/src/core/app_theme.dart';
import 'package:catfact/src/cubits/cat_feed_cubit/cat_feed_cubit.dart';
import 'package:catfact/src/cubits/index_cubit.dart';
import 'package:catfact/src/models/fact_meta_model.dart';
import 'package:catfact/src/models/fact_model.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:catfact/src/utils/utils.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  int currentIndex = 1;

  List<FactModel> feedList = [];
  final CarouselController _carouselController = CarouselController();

  Timer? shuffleTimer;

  @override
  void initState() {
    super.initState();
    _updateFeeds();
    shuffleTimer =
        Timer.periodic(5.seconds, (timer) => _updateFeeds(fromTimer: true));
  }

  void _updateFeeds({bool fromTimer = false}) async {
    if (!mounted) {
      return shuffleTimer?.cancel();
    }
    if (fromTimer) {
      Utils.showSuccessToast('New Facts has been loaded. Updating Feeds now');
      await Future.delayed(2.seconds);
      setState(() {
        feedList = BlocProvider.of<CatFeedCubit>(gContext).randomFacts;
      });
    } else {
      setState(() {
        feedList = BlocProvider.of<CatFeedCubit>(gContext).randomFacts;
      });
    }
  }

  @override
  void dispose() {
    shuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: feedList.length + 1,
      itemBuilder: (_, index, pageViewIndex) {
        if (index == 0) {
          return FeedTile(
            factModel: FactModel(fact: "Please scroll upside", length: 14),
            index: index,
            key: const Key('init'),
            hasUserFocus: false,
          );
        }

        final factModel = feedList[index - 1];
        return FeedTile(
          factModel: factModel,
          index: index,
          key: Key(factModel.id.toString()),
          hasUserFocus: index == currentIndex,
        );
      },
      options: CarouselOptions(
          enlargeFactor: 0.2,
          height: double.infinity,
          scrollDirection: Axis.vertical,
          enableInfiniteScroll: false,
          autoPlay: false,
          viewportFraction: 0.4,
          initialPage: 1,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}

class FeedTile extends StatefulWidget {
  const FeedTile({
    super.key,
    required this.factModel,
    required this.index,
    required this.hasUserFocus,
  });

  final int index;
  final FactModel factModel;
  final bool hasUserFocus;

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> with WidgetsBindingObserver {
  DateTime? initDateTime;
  DateTime? userFocusTime;
  Duration userFocusDuration = Duration.zero;

  @override
  void initState() {
    initDateTime = DateTime.now();
    WidgetsBinding.instance.addObserver(this);
    if (widget.hasUserFocus) {
      userFocusTime = DateTime.now();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FeedTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasUserFocus) {
      if (!widget.hasUserFocus) {
        final currentTime = DateTime.now();
        userFocusDuration =
            currentTime.difference(userFocusTime ?? currentTime);
      }
    } else {
      if (widget.hasUserFocus) {
        userFocusTime = DateTime.now();
      }
    }
  }

  Duration _calculateFocusDuration() {
    if (widget.hasUserFocus) {
      final currentTime = DateTime.now();
      userFocusDuration = currentTime.difference(userFocusTime ?? currentTime);
    }

    return userFocusDuration;
  }

  @override
  void dispose() {
    _calculateOnScreenDuration('DISPOSE');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) {
      _calculateOnScreenDuration('ACTIVITY_PAUSED');
      initDateTime = DateTime.now();
    }
  }

  void _calculateOnScreenDuration(String reason) {
    if (initDateTime == null || widget.index == 0) return;
    final diff = DateTime.now().difference(initDateTime!);
    final fact = widget.factModel;
    final factMeta = FactMetaModel(
        factId: fact.id,
        appearanceDateTime: initDateTime!,
        onScreenDuration: diff,
        factIndex: widget.index,
        factsPerPage: factsPerPage,
        pageIndex: catFeedCubit.currentPage,
        userFocusDuration: _calculateFocusDuration(),
        reason: reason);
    console(factMeta);
    factMeta.syncMetaToLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.factBgColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 4),
                  blurRadius: 14,
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.factModel.fact,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.black,
              ),
              width: 40,
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(
                  "${widget.index}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
