class MeasurementDto {
  final String id;
  final String type;
  final String value;
  final String unit;
  final String date; // ISO 8601 format

  const MeasurementDto({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'unit': unit,
      'date': date,
    };
  }

  factory MeasurementDto.fromJson(Map<String, dynamic> json) {
    return MeasurementDto(
      id: json['id'] as String,
      type: json['type'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String,
      date: json['date'] as String,
    );
  }
}




