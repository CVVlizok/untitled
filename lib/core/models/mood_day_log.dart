class MoodDayLog {
  final String id;
  final DateTime date;
  final int moodLevel; // 1..5
  final String note;

  const MoodDayLog({
    required this.id,
    required this.date,
    required this.moodLevel,
    required this.note,
  });
}




