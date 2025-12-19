class MoodDayLogDto {
  final String id;
  final String date; // ISO 8601 format
  final int moodLevel; // 1..5
  final String note;

  const MoodDayLogDto({
    required this.id,
    required this.date,
    required this.moodLevel,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'moodLevel': moodLevel,
      'note': note,
    };
  }

  factory MoodDayLogDto.fromJson(Map<String, dynamic> json) {
    return MoodDayLogDto(
      id: json['id'] as String,
      date: json['date'] as String,
      moodLevel: json['moodLevel'] as int,
      note: json['note'] as String,
    );
  }
}