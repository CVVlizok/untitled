class WaterDayLogDto {
  final String id;
  final String date; // ISO 8601 format
  final int targetCups;
  final int drunkCups;

  const WaterDayLogDto({
    required this.id,
    required this.date,
    required this.targetCups,
    required this.drunkCups,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'targetCups': targetCups,
      'drunkCups': drunkCups,
    };
  }

  factory WaterDayLogDto.fromJson(Map<String, dynamic> json) {
    return WaterDayLogDto(
      id: json['id'] as String,
      date: json['date'] as String,
      targetCups: json['targetCups'] as int,
      drunkCups: json['drunkCups'] as int,
    );
  }
}
