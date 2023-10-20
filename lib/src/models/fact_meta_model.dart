// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:catfact/src/services/index_service.dart';

class FactMetaModel {
  final int factId;
  final int pageIndex;
  final int factIndex;
  final int factsPerPage;
  final Duration onScreenDuration;
  final Duration userFocusDuration;
  final DateTime appearanceDateTime;
  final String reason;
  FactMetaModel({
    required this.factId,
    required this.pageIndex,
    required this.factIndex,
    required this.factsPerPage,
    required this.onScreenDuration,
    required this.userFocusDuration,
    required this.appearanceDateTime,
    required this.reason,
  });

  FactMetaModel copyWith({
    int? factId,
    int? pageIndex,
    int? factIndex,
    int? factsPerPage,
    Duration? onScreenDuration,
    Duration? userFocusDuration,
    DateTime? appearanceDateTime,
    String? reason,
  }) {
    return FactMetaModel(
      factId: factId ?? this.factId,
      pageIndex: pageIndex ?? this.pageIndex,
      factIndex: factIndex ?? this.factIndex,
      factsPerPage: factsPerPage ?? this.factsPerPage,
      onScreenDuration: onScreenDuration ?? this.onScreenDuration,
      userFocusDuration: userFocusDuration ?? this.userFocusDuration,
      appearanceDateTime: appearanceDateTime ?? this.appearanceDateTime,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'factId': factId,
      'pageIndex': pageIndex,
      'factIndex': factIndex,
      'factsPerPage': factsPerPage,
      'onScreenDuration': onScreenDuration.inMilliseconds,
      'userFocusDuration': userFocusDuration.inMilliseconds,
      'appearanceTime': appearanceDateTime.millisecondsSinceEpoch,
      'reason': reason,
    };
  }

  factory FactMetaModel.fromMap(Map<String, dynamic> map) {
    return FactMetaModel(
      factId: map['factId'] as int,
      pageIndex: map['pageIndex'] as int,
      factIndex: map['factIndex'] as int,
      factsPerPage: map['factsPerPage'] as int,
      onScreenDuration: Duration(milliseconds: map['onScreenDuration'] ?? 0),
      userFocusDuration: Duration(milliseconds: map['userFocusDuration']),
      appearanceDateTime:
          DateTime.fromMillisecondsSinceEpoch(map['appearanceTime'] as int),
      reason: map['reason'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FactMetaModel(factId: $factId, pageIndex: $pageIndex, factIndex: $factIndex, factsPerPage: $factsPerPage, onScreenDuration: $onScreenDuration, userFocusDuration: $userFocusDuration, appearanceDateTime: $appearanceDateTime, reason: $reason)';
  }

  void syncMetaToLocal() => analyticsService.syncFactMeta(this);
}
