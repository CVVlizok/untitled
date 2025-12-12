class MoodDayLogDto {
  final String date; // ISO 8601 format
  final int moodLevel; // 1..5
  final String note;

  const MoodDayLogDto({
    required this.date,
    required this.moodLevel,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'moodLevel': moodLevel,
      'note': note,
    };
  }

  factory MoodDayLogDto.fromJson(Map<String, dynamic> json) {
    return MoodDayLogDto(
      date: json['date'] as String,
      moodLevel: json['moodLevel'] as int,
      note: json['note'] as String,
    );
  }
}



