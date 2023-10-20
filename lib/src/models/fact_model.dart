class FactModel {
  final String fact;
  final int length;
  final int id;
  FactModel({
    required this.fact,
    required this.length,
  }) : id = fact.hashCode;

  FactModel copyWith({
    String? fact,
    int? length,
  }) {
    return FactModel(
      fact: fact ?? this.fact,
      length: length ?? this.length,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fact': fact,
      'length': length,
    };
  }

  factory FactModel.fromMap(Map<String, dynamic> map) {
    return FactModel(
      fact: map['fact'] as String,
      length: map['length'].toInt() as int,
    );
  }

  @override
  String toString() => 'FactModel(fact: $fact, length: $length)';
}
