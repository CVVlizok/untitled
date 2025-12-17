import 'package:json_annotation/json_annotation.dart';
import 'work_dto.dart';
import 'concepts_response_dto.dart';

part 'works_response_dto.g.dart';

@JsonSerializable()
class WorksResponseDto {
  final List<WorkDto>? results;
  final MetaDto? meta;

  const WorksResponseDto({
    this.results,
    this.meta,
  });

  factory WorksResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WorksResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorksResponseDtoToJson(this);
}

