class NoteEntryDto {
  final String id;
  final String text;
  final String date; // YYYY-MM-DD

  const NoteEntryDto({
    required this.id,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date,
    };
  }

  factory NoteEntryDto.fromJson(Map<String, dynamic> json) {
    return NoteEntryDto(
      id: json['id'] as String,
      text: json['text'] as String,
      date: json['date'] as String,
    );
  }
}







