/// Single reward option from chest or boss pool. Config-driven.
class ChestReward {
  const ChestReward({
    required this.id,
    required this.type,
    required this.label,
    this.value = 0,
  });

  factory ChestReward.fromJson(Map<String, dynamic> json) {
    return ChestReward(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'heal',
      label: json['label'] as String? ?? 'Reward',
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }

  final String id;
  /// e.g. 'max_hp', 'heal', 'damage', 'speed', 'armor'
  final String type;
  final String label;
  final double value;
}
