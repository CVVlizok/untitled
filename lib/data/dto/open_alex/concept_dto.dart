import 'package:json_annotation/json_annotation.dart';

part 'concept_dto.g.dart';

@JsonSerializable()
class ConceptDto {
  final String? id;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String? description;
  @JsonKey(name: 'works_count')
  final int? worksCount;
  @JsonKey(name: 'cited_by_count')
  final int? citedByCount;
  final int? level;

  const ConceptDto({
    this.id,
    this.displayName,
    this.description,
    this.worksCount,
    this.citedByCount,
    this.level,
  });

  factory ConceptDto.fromJson(Map<String, dynamic> json) =>
      _$ConceptDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConceptDtoToJson(this);
}

