class Measurement {
  final String id;
  final String type;
  final String value;
  final String unit;
  final DateTime date;

  const Measurement({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
  });

  @override
  String toString() {
    return 'Measurement(id: $id, type: $type, value: $value, unit: $unit, date: $date)';
  }
}



