import 'package:json_annotation/json_annotation.dart';
import 'concept_dto.dart';

part 'concepts_response_dto.g.dart';

@JsonSerializable()
class ConceptsResponseDto {
  final List<ConceptDto>? results;
  @JsonKey(name: 'meta')
  final MetaDto? meta;

  const ConceptsResponseDto({
    this.results,
    this.meta,
  });

  factory ConceptsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ConceptsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConceptsResponseDtoToJson(this);
}

@JsonSerializable()
class MetaDto {
  final int? count;
  @JsonKey(name: 'db_response_time_ms')
  final int? dbResponseTimeMs;
  final int? page;
  @JsonKey(name: 'per_page')
  final int? perPage;

  const MetaDto({
    this.count,
    this.dbResponseTimeMs,
    this.page,
    this.perPage,
  });

  factory MetaDto.fromJson(Map<String, dynamic> json) =>
      _$MetaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDtoToJson(this);
}

