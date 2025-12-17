import 'package:json_annotation/json_annotation.dart';

part 'source_dto.g.dart';

@JsonSerializable()
class SourceDto {
  final String? id;
  final String? name;

  const SourceDto({
    this.id,
    this.name,
  });

  factory SourceDto.fromJson(Map<String, dynamic> json) =>
      _$SourceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SourceDtoToJson(this);
}

