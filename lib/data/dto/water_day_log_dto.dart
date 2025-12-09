class WaterDayLogDto {
  final String date; // ISO 8601 format
  final int targetCups;
  final int drunkCups;

  const WaterDayLogDto({
    required this.date,
    required this.targetCups,
    required this.drunkCups,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'targetCups': targetCups,
      'drunkCups': drunkCups,
    };
  }

  factory WaterDayLogDto.fromJson(Map<String, dynamic> json) {
    return WaterDayLogDto(
      date: json['date'] as String,
      targetCups: json['targetCups'] as int,
      drunkCups: json['drunkCups'] as int,
    );
  }
}

